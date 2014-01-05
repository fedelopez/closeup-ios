//
//  QuestionsLoader.m
//  CloseUp
//
//  Created by Fede on 5/04/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "GameDAO.h"
#import "SQLStatementHelper.h"
#import "QuestionsShuffler.h"

@implementation GameDAO

static const int multiAnswerQuestionsPerGame = 8;
static const int trueFalseQuestionsPerGame = 1;
static const int whichOneCameFirstQuestionsPerGame = 1;

static const char *multiAnswerQuestionTable = "multi_answer_question";
static const char *trueFalseQuestionTable = "true_false_question";
static const char *whichOneCameFirstQuestionTable = "which_one_came_first";

- (NSMutableArray *)loadLessUsedQuestionIds:(NSString *)questionTable maxNumToLoad:(int)maxNumToLoad {
    NSMutableArray *questions = [[NSMutableArray alloc] initWithCapacity:maxNumToLoad];
    int questionIdsLoaded = 0;
    int currentMinAppearances = -1;
    while (questionIdsLoaded < maxNumToLoad) {
        NSString *minSQL = [SQLStatementHelper minNumberOfAppearancesForQuestionTableSQL:questionTable minNumAppearances:currentMinAppearances];
        currentMinAppearances = [self intResultForSql:minSQL];
        if (currentMinAppearances == -1) {
            break;
        } else {
            NSString *countSQL = [SQLStatementHelper countNumberOfQuestionsWithNumberOfAppearancesSQL:questionTable numAppearances:currentMinAppearances];
            int count = [self intResultForSql:countSQL];
            if (count == 0) {
                continue;
            }
            int nextNumToLoad;
            int remainingToLoad = maxNumToLoad - questionIdsLoaded;
            if (count >= remainingToLoad) {
                nextNumToLoad = remainingToLoad;
            } else {
                nextNumToLoad = count;
            }
            [self fillQuestionIdArray:questionTable questionIds:questions numberOfApperances:currentMinAppearances numToLoad:nextNumToLoad];
            questionIdsLoaded += nextNumToLoad;
        }
    }
    return questions;
}

- (void)fillQuestionIdArray:(NSString *)questionTable questionIds:(NSMutableArray *)questionIds numberOfApperances:(int)numberOfApperances numToLoad:(int)numToLoad {
    sqlite3 *database;
    if (sqlite3_open([dbFileName UTF8String], &database) == SQLITE_OK) {
        NSString *sqlStatementString = [SQLStatementHelper selectRandomQuestionsSQL:questionTable numAppearances:numberOfApperances limit:numToLoad];
        int size = [sqlStatementString length] + 1;
        char sqlStatement[size];
        [sqlStatementString getCString:sqlStatement maxLength:size encoding:NSASCIIStringEncoding];
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                int questionId = sqlite3_column_int(compiledStatement, 0);
                [questionIds addObject:[NSNumber numberWithInt:questionId]];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}

- (Game *)loadNewGame:(GameMode)mode {
    //multi answer questions
    NSMutableArray *multiAnswerQuestionIds = [self loadLessUsedQuestionIds:[NSString stringWithUTF8String:multiAnswerQuestionTable] maxNumToLoad:multiAnswerQuestionsPerGame];
    NSArray *multiAnswerQuestions = [self loadMultiAnswerQuestions:multiAnswerQuestionIds];
    [multiAnswerQuestionIds release];

    //which one came first question
    WhichOneCameFirst *whichOneCameFirst = [self loadWhichOneCameFirstQuestion];
    //true false question
    NSMutableArray *trueFalseQuestionIds = [self loadLessUsedQuestionIds:[NSString stringWithUTF8String:trueFalseQuestionTable] maxNumToLoad:trueFalseQuestionsPerGame];
    NSArray *trueFalseQuestions = [self loadTrueFalseQuestions:trueFalseQuestionIds];
    TrueFalseQuestion *trueFalseQuestion = [trueFalseQuestions objectAtIndex:0];
    [trueFalseQuestionIds release];

    NSArray *inBetweeners = [NSArray arrayWithObjects:whichOneCameFirst, trueFalseQuestion, nil];

    //shuffle the multi answer with the true false questions
    NSArray *gameQuestions = [[QuestionsShuffler shuffle:multiAnswerQuestions inBetweeners:inBetweeners] autorelease];
    Game *game = [[[Game alloc] initWithQuestions:gameQuestions gameMode:mode] autorelease];

    return game;
}

- (NSArray *)loadMultiAnswerQuestions:(NSArray *)multiAnswerQuestions {
    NSString *selectSQL = [SQLStatementHelper selectMultiAnswerQuestionsSQL:multiAnswerQuestions];
    int sqlLength = [selectSQL length] + 1;
    char selectStatement[sqlLength];
    [selectSQL getCString:selectStatement maxLength:sqlLength encoding:NSASCIIStringEncoding];

    NSMutableArray *questions = [[[NSMutableArray alloc] initWithCapacity:[multiAnswerQuestions count]] autorelease];
    sqlite3 *database;
    if (sqlite3_open([dbFileName UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, selectStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                Question *question = [self multiAnswerQuestionFrom:compiledStatement];
                [questions addObject:question];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);

    return questions;
}

- (NSArray *)loadTrueFalseQuestions:(NSArray *)trueFalseQuestions {
    NSString *selectSQL = [SQLStatementHelper selectTrueFalseQuestionsSQL:trueFalseQuestions];
    int sqlLength = [selectSQL length] + 1;
    char selectStatement[sqlLength];
    [selectSQL getCString:selectStatement maxLength:sqlLength encoding:NSASCIIStringEncoding];

    NSMutableArray *questions = [[[NSMutableArray alloc] initWithCapacity:[trueFalseQuestions count]] autorelease];
    sqlite3 *database;
    if (sqlite3_open([dbFileName UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, selectStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                Question *question = [self trueFalseQuestionFrom:compiledStatement];
                [questions addObject:question];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);

    return questions;
}

- (WhichOneCameFirst *)loadWhichOneCameFirstQuestion {
    NSArray *questionIds = [self loadLessUsedQuestionIds:[NSString stringWithUTF8String:whichOneCameFirstQuestionTable] maxNumToLoad:whichOneCameFirstQuestionsPerGame];
    NSString *selectSQL = [SQLStatementHelper selectWhichOneCameFirstQuestionSQL:[[questionIds objectAtIndex:0] stringValue]];
    [questionIds release];
    int sqlLength = [selectSQL length] + 1;
    char selectStatement[sqlLength];

    [selectSQL getCString:selectStatement maxLength:sqlLength encoding:NSASCIIStringEncoding];

    WhichOneCameFirst *question = nil;
    sqlite3 *database;
    if (sqlite3_open([dbFileName UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, selectStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                question = [self whichOneCameFirstFrom:compiledStatement];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    return question;
}

- (int)numberOfQuestionsForSavedGame {
    return [self intResultForSql:@"select count(question_id) as total from saved_game_question"];
}

- (void)removeCorrectAnswerIfQuestionIsDisplayIndex:(Question *)question currentGame:(Game *)game {
    if ([question isCorrect] && [question displayIndex] == [game currentQuestionIndex]) {
        [question clearLastAnswer];
    }
}

- (void)saveGame:(Game *)game {
    [self deleteSavedGameTables];
    sqlite3 *database;

    if (sqlite3_open([dbFileName UTF8String], &database) == SQLITE_OK) {
        NSString *insertSQL = [SQLStatementHelper insertGameSQL:game];
        int size = [insertSQL length] + 1;
        char insertGameSQLStatement[size];
        [insertSQL getCString:insertGameSQLStatement maxLength:size encoding:NSASCIIStringEncoding];

        sqlite3_stmt *compiledStatement;
        sqlite3_prepare_v2(database, insertGameSQLStatement, -1, &compiledStatement, NULL);
        if (SQLITE_DONE != sqlite3_step(compiledStatement)) {
            NSLog(@"Error while inserting on saved_game table. '%s'", sqlite3_errmsg(database));
        } else {
            NSLog(@"Successful SQL: '%@'", insertSQL);
        }
        sqlite3_reset(compiledStatement);
        for (int i = 0; i < [game.questions count]; i++) {
            Question *question = [game.questions objectAtIndex:i];
            [self removeCorrectAnswerIfQuestionIsDisplayIndex:question currentGame:game];
            insertSQL = [SQLStatementHelper insertQuestionSQL:question];
            size = [insertSQL length] + 1;
            char sqlStatement[size];
            [insertSQL getCString:sqlStatement maxLength:size encoding:NSASCIIStringEncoding];
            sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
            if (SQLITE_DONE != sqlite3_step(compiledStatement)) {
                NSLog(@"Error while inserting on saved_game_question table. '%s'", sqlite3_errmsg(database));
            }
            sqlite3_reset(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}

- (void)deleteSavedGameTables {
    [self executeStatement:@"delete from saved_game_question"];
    [self executeStatement:@"delete from saved_game"];
}

- (void)updateNumberOfAppearancesForGameQuestions:(Game *)game {
    NSMutableArray *displayedQuestions = [[[NSMutableArray alloc] initWithCapacity:[game numberOfQuestions]] autorelease];
    for (int i = 0; i < [game numberOfQuestions]; i++) {
        Question *question = [game.questions objectAtIndex:i];
        if ([question appearedOnScreen] && [question isCorrect]) {
            [displayedQuestions addObject:question];
        }
    }
    NSString *updateSQL = [SQLStatementHelper updateNumberOfAppearancesSQL:displayedQuestions];
    [self executeStatement:updateSQL];
}

- (void)fillAnswers:(Question *)question userAnswer:(NSString *)userAnswer {
    NSString *string = [userAnswer stringByReplacingOccurrencesOfString:@"{" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSArray *answers = [string componentsSeparatedByString:@"}"];
    for (NSString *answer in answers) {
        if ([answer length] == 0) continue;
        [question answer:answer];
    }
}

- (void)fillQuestionState:(sqlite3_stmt *)compiledStatement question:(Question *)question cursor:(int)cursor questions:(NSMutableArray *)questions {
    int questionIndex = sqlite3_column_int(compiledStatement, cursor++);
    [question setDisplayIndex:questionIndex];
    BOOL appearedOnScreen = (BOOL) sqlite3_column_int(compiledStatement, cursor);
    [question setAppearedOnScreen:appearedOnScreen];
    [questions replaceObjectAtIndex:questionIndex withObject:question];
}

- (Game *)loadSavedGame {
    sqlite3 *database;
    int count = [self numberOfQuestionsForSavedGame];
    if (count == 0) {
        return nil;
    }

    NSMutableArray *questions = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
    for (int i = 0; i < count; i++) {
        [questions insertObject:[NSNull null] atIndex:i];
    }
    if (sqlite3_open([dbFileName UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        [self loadMultiAnswerQuestions:database intoQuestions:questions compiledStatement:&compiledStatement];
        [self loadTrueFalseQuestions:database questions:questions compiledStatement:&compiledStatement];
        [self loadWhichOneCameFirtsQuestions:database questions:questions compiledStatement:&compiledStatement];

        sqlite3_finalize(compiledStatement);
    }

    Game *game = [self loadCurrentSavedGame:database withQuestions:questions];
    sqlite3_close(database);

    return game;
}

- (void)loadWhichOneCameFirtsQuestions:(sqlite3 *)database questions:(NSMutableArray *)questions compiledStatement:(sqlite3_stmt **)compiledStatement {
    const char *whichOneQuestionStatement = "select q.question_id, q.image_name, q.correct_answer, q.question_text, q.difficulty, w.movie_title1, w.movie_title2, w.movie_title1_image, w.movie_title2_image, w.movie_title1_year, w.movie_title2_year, s.user_answer, s.question_index, s.appeared_on_screen from question q inner join which_one_came_first w on q.question_id = w.question_id inner join saved_game_question s on q.question_id = s.question_id";
    if (sqlite3_prepare_v2(database, whichOneQuestionStatement, -1, compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step((*compiledStatement)) == SQLITE_ROW) {
            WhichOneCameFirst *whichOne = [self whichOneCameFirstFrom:*compiledStatement];
            char *userAnswerChar = (char *) sqlite3_column_text((*compiledStatement), 11);
            if (userAnswerChar != NULL) {
                NSString *userAnswer = [NSString stringWithUTF8String:userAnswerChar];
                [self fillAnswers:whichOne userAnswer:userAnswer];
            }
            [self fillQuestionState:*compiledStatement question:whichOne cursor:12 questions:questions];
        }
        sqlite3_reset((*compiledStatement));
    }
}

- (void)loadTrueFalseQuestions:(sqlite3 *)database questions:(NSMutableArray *)questions compiledStatement:(sqlite3_stmt **)compiledStatement {
    const char *trueFalseQuestionStatement = "select q.question_id, q.image_name, q.correct_answer, q.question_text, q.difficulty, tfq.answer_when_false, s.user_answer, s.question_index, s.appeared_on_screen from question q inner join true_false_question tfq on q.question_id = tfq.question_id inner join saved_game_question s on q.question_id = s.question_id";
    if (sqlite3_prepare_v2(database, trueFalseQuestionStatement, -1, compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step((*compiledStatement)) == SQLITE_ROW) {
            TrueFalseQuestion *tfq = [self trueFalseQuestionFrom:*compiledStatement];
            char *userAnswerChar = (char *) sqlite3_column_text((*compiledStatement), 6);
            if (userAnswerChar != NULL) {
                NSString *userAnswer = [NSString stringWithUTF8String:userAnswerChar];
                [self fillAnswers:tfq userAnswer:userAnswer];
            }
            [self fillQuestionState:*compiledStatement question:tfq cursor:7 questions:questions];
        }
        sqlite3_reset((*compiledStatement));
    }
}

- (void)loadMultiAnswerQuestions:(sqlite3 *)database intoQuestions:(NSMutableArray *)questions compiledStatement:(sqlite3_stmt **)compiledStatement {
    const char *sqlStatement = "select q.question_id, q.image_name, q.correct_answer, q.question_text, q.difficulty, maq.answer1, maq.answer2, maq.answer3, maq.answer4, s.user_answer, s.question_index, s.appeared_on_screen from question q inner join multi_answer_question maq on q.question_id = maq.question_id inner join saved_game_question s on q.question_id = s.question_id";
    if (sqlite3_prepare_v2(database, sqlStatement, -1, compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step((*compiledStatement)) == SQLITE_ROW) {
            MultiAnswerQuestion *mcq = [self multiAnswerQuestionFrom:*compiledStatement];
            char *userAnswerChar = (char *) sqlite3_column_text((*compiledStatement), 9);
            if (userAnswerChar != NULL) {
                NSString *userAnswer = [NSString stringWithUTF8String:userAnswerChar];
                [self fillAnswers:mcq userAnswer:userAnswer];
            }
            [self fillQuestionState:*compiledStatement question:mcq cursor:10 questions:questions];
        }
        sqlite3_reset(*compiledStatement);
    }
}

- (Game *)loadCurrentSavedGame:(sqlite3 *)database withQuestions:(NSMutableArray *)questions {
    Game *game = nil;
    sqlite3_stmt *compiledStatement;
    const char *sqlStatement = "select selected_question_index, remaining_lives, paused, remaining_seconds, game_mode, suspended from saved_game";
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
        if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            int cursor = 0;
            int selectedQuestionIndex = sqlite3_column_int(compiledStatement, cursor++);
            int remainingLives = sqlite3_column_int(compiledStatement, cursor++);
            int paused = sqlite3_column_int(compiledStatement, cursor++);
            int remainingSeconds = sqlite3_column_int(compiledStatement, cursor++);
            int gameMode = sqlite3_column_int(compiledStatement, cursor++);
            BOOL suspended = (BOOL) sqlite3_column_int(compiledStatement, cursor);

            game = [[[Game alloc] initWithQuestions:questions gameMode:gameMode] autorelease];
            [game setCurrentQuestionIndex:selectedQuestionIndex];
            [game setRemainingLives:remainingLives];
            [game setPaused:paused == 0 ? FALSE : TRUE];
            [game setRemainingSeconds:remainingSeconds];
            [game setSuspended:suspended];
        }
        sqlite3_reset(compiledStatement);
    }
    return game;
}

- (MultiAnswerQuestion *)multiAnswerQuestionFrom:(sqlite3_stmt *)statement {
    int statementIndex = 0;
    int questionId = sqlite3_column_int(statement, statementIndex++);
    NSString *imageName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    NSString *correctAnswer = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    NSString *question = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    int difficulty = sqlite3_column_int(statement, statementIndex++);

    NSString *answer1 = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    NSString *answer2 = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    NSString *answer3 = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    NSString *answer4 = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex)];

    MultiAnswerQuestion *mcq = [[[MultiAnswerQuestion alloc] init] autorelease];
    [mcq setQuestionId:questionId];
    [mcq setImageName:imageName];
    [mcq setQuestion:question];
    [mcq setDifficulty:difficulty];
    [mcq setPossibleAnswers:[NSArray arrayWithObjects:answer1, answer2, answer3, answer4, nil]];
    [mcq setCorrectAnswer:correctAnswer];

    return mcq;
}

- (TrueFalseQuestion *)trueFalseQuestionFrom:(sqlite3_stmt *)statement {
    int statementIndex = 0;
    int questionId = sqlite3_column_int(statement, statementIndex++);
    NSString *imageName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    NSString *correctAnswer = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    NSString *question = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    int difficulty = sqlite3_column_int(statement, statementIndex++);
    NSString *correctAnswerWhenFalse = nil;
    if (sqlite3_column_text(statement, statementIndex) != nil) {
        correctAnswerWhenFalse = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex)];
    }
    TrueFalseQuestion *tfq = [[[TrueFalseQuestion alloc] init] autorelease];
    [tfq setQuestionId:questionId];
    [tfq setImageName:imageName];
    [tfq setCorrectAnswer:correctAnswer];
    [tfq setQuestion:question];
    [tfq setDifficulty:difficulty];
    [tfq setCorrectAnswerWhenFalse:correctAnswerWhenFalse];

    return tfq;
}

- (WhichOneCameFirst *)whichOneCameFirstFrom:(sqlite3_stmt *)statement {
    int statementIndex = 0;
    int questionId = sqlite3_column_int(statement, statementIndex++);
    NSString *imageName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    NSString *correctAnswer = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    NSString *questionTitle = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    int difficulty = sqlite3_column_int(statement, statementIndex++);
    NSString *movieTitle1 = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    NSString *movieTitle2 = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    NSString *movieTitle1Image = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    NSString *movieTitle2Image = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];
    int movieTitle1Year1 = sqlite3_column_int(statement, statementIndex++);
    int movieTitle1Year2 = sqlite3_column_int(statement, statementIndex);

    WhichOneCameFirst *question = [[[WhichOneCameFirst alloc] init] autorelease];
    [question setQuestionId:questionId];
    [question setImageName:imageName];
    [question setCorrectAnswer:correctAnswer];
    [question setQuestion:questionTitle];
    [question setDifficulty:difficulty];

    [question setMovieTitle1:movieTitle1];
    [question setMovieTitle2:movieTitle2];
    [question setMovieTitle1ImageName:movieTitle1Image];
    [question setMovieTitle2ImageName:movieTitle2Image];
    [question setMovieTitleYear1:movieTitle1Year1];
    [question setMovieTitleYear2:movieTitle1Year2];

    return question;
}

- (NSString *)databaseVersion {
    NSString *const version = [self stringResultForSql:@"select db_version from about"];
    return version == nil ? LEGACY_DB_VERSION : version;
}

@end
