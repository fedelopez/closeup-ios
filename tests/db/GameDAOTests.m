//
//  QuestionsLoader.m
//  CloseUp
//
//  Created by Fede on 5/04/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "DBHelper.h"

#import "GameDAO.h"

@interface GameDAOTests : SenTestCase {
    GameDAO *dbManager;
    NSString *tempDBPath;
    NSFileManager *fileManager;
}
@end


@implementation GameDAOTests

- (void)setUp {
    NSString *questionsSmallDB = @"questions-small.sqlite";
    NSString *databasePath = [[NSBundle bundleForClass:[self class]] pathForResource:questionsSmallDB ofType:nil];
    tempDBPath = [databasePath stringByReplacingOccurrencesOfString:questionsSmallDB withString:@"db-manager-tests.sqlite"];
    fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtPath:tempDBPath error:NULL];
    [fileManager copyItemAtPath:databasePath toPath:tempDBPath error:NULL];
    NSLog(@"DB path for tests: %@", tempDBPath);
    dbManager = [[GameDAO alloc] initWithDbFileName:tempDBPath];
}

- (void)tearDown {
    [fileManager removeItemAtPath:tempDBPath error:NULL];
    [fileManager release];
    [dbManager release];
}

- (void)testLoadLessUsedMultiAnswerQuestionIds {
    int questionsToLoad = 10;
    NSArray *questionIds = [dbManager loadLessUsedQuestionIds:@"multi_answer_question" maxNumToLoad:questionsToLoad];
    STAssertEquals([[NSNumber numberWithInt:10] unsignedIntegerValue], [questionIds count], @"Wrong array size");

    STAssertTrue([questionIds containsObject:[NSNumber numberWithInt:1]], @"Expected question id not found");
    STAssertTrue([questionIds containsObject:[NSNumber numberWithInt:4]], @"Expected question id not found");
    STAssertTrue([questionIds containsObject:[NSNumber numberWithInt:6]], @"Expected question id not found");
    STAssertTrue([questionIds containsObject:[NSNumber numberWithInt:7]], @"Expected question id not found");
    STAssertTrue([questionIds containsObject:[NSNumber numberWithInt:10]], @"Expected question id not found");
    STAssertTrue([questionIds containsObject:[NSNumber numberWithInt:13]], @"Expected question id not found");
    STAssertTrue([questionIds containsObject:[NSNumber numberWithInt:14]], @"Expected question id not found");
    STAssertTrue([questionIds containsObject:[NSNumber numberWithInt:3]], @"Expected question id not found");
    STAssertTrue([questionIds containsObject:[NSNumber numberWithInt:8]], @"Expected question id not found");
    STAssertTrue([questionIds containsObject:[NSNumber numberWithInt:9]], @"Expected question id not found");
}

- (void)testLoadLessUsedTrueFalseQuestionIds {
    int questionsToLoad = 10;
    NSArray *questionIds = [dbManager loadLessUsedQuestionIds:@"true_false_question" maxNumToLoad:questionsToLoad];
    STAssertEquals([[NSNumber numberWithInt:2] unsignedIntegerValue], [questionIds count], @"Wrong array size");
    STAssertEquals(12, [[questionIds objectAtIndex:0] intValue], @"Wrong question id");
    STAssertEquals(15, [[questionIds objectAtIndex:1] intValue], @"Wrong question id");
}

- (void)testLoadLessUsedTrueFalseQuestionIdsCountGivesZero {
    [dbManager executeStatement:@"update question set number_appearances = 2 where question_id  = 12"];
    [dbManager executeStatement:@"update question set number_appearances = 3 where question_id  = 15"];
    int questionsToLoad = 2;
    NSArray *questionIds = [dbManager loadLessUsedQuestionIds:@"true_false_question" maxNumToLoad:questionsToLoad];
    STAssertEquals([[NSNumber numberWithInt:questionsToLoad] unsignedIntegerValue], [questionIds count], @"Wrong array size");
    STAssertEquals(12, [[questionIds objectAtIndex:0] intValue], @"Wrong question id");
    STAssertEquals(15, [[questionIds objectAtIndex:1] intValue], @"Wrong question id");
}

- (void)testLoadNewGame {
    Game *game = [dbManager loadNewGame:STRAIGHT_10];
    NSUInteger expectedInstances = 1;
    STAssertEquals(expectedInstances, [game retainCount], @"Too many instances created");
    STAssertEquals(TOTAL_QUESTIONS_PER_GAME, [game numberOfQuestions], @"Wrong number of questions");
    STAssertFalse([game finished], @"Expected a non finished game");
    STAssertEquals(0, [game currentQuestionIndex], @"Wrong current question index");

    NSUInteger questionIndex = 0;
    MultiAnswerQuestion *question1 = [game.questions objectAtIndex:questionIndex++];
    STAssertTrue([question1 isKindOfClass:[MultiAnswerQuestion class]], @"Expected multi answer question");

    MultiAnswerQuestion *question2 = [game.questions objectAtIndex:questionIndex++];
    STAssertTrue([question2 isKindOfClass:[MultiAnswerQuestion class]], @"Expected multi answer question");

    MultiAnswerQuestion *question3 = [game.questions objectAtIndex:questionIndex++];
    STAssertTrue([question3 isKindOfClass:[MultiAnswerQuestion class]], @"Expected multi answer question");

    MultiAnswerQuestion *question4 = [game.questions objectAtIndex:questionIndex++];
    STAssertTrue([question4 isKindOfClass:[MultiAnswerQuestion class]], @"Expected multi answer question");

    MultiAnswerQuestion *question5 = [game.questions objectAtIndex:questionIndex++];
    STAssertTrue([question5 isKindOfClass:[WhichOneCameFirst class]], @"Expected multi answer question");

    WhichOneCameFirst *question6 = [game.questions objectAtIndex:questionIndex++];
    STAssertTrue([question6 isKindOfClass:[MultiAnswerQuestion class]], @"Expected which one came first question");

    MultiAnswerQuestion *question7 = [game.questions objectAtIndex:questionIndex++];
    STAssertTrue([question7 isKindOfClass:[MultiAnswerQuestion class]], @"Expected multi answer question");

    MultiAnswerQuestion *question8 = [game.questions objectAtIndex:questionIndex++];
    STAssertTrue([question8 isKindOfClass:[MultiAnswerQuestion class]], @"Expected multi answer question");

    MultiAnswerQuestion *question9 = [game.questions objectAtIndex:questionIndex++];
    STAssertTrue([question9 isKindOfClass:[MultiAnswerQuestion class]], @"Expected multi answer question");

    TrueFalseQuestion *question10 = [game.questions objectAtIndex:questionIndex];
    STAssertTrue([question10 isKindOfClass:[TrueFalseQuestion class]], @"Expected true false question");
}

- (void)testLoadMultiAnswerQuestions {
    NSNumber *question1 = [NSNumber numberWithInt:10];
    NSNumber *question2 = [NSNumber numberWithInt:7];

    NSArray *questions = [dbManager loadMultiAnswerQuestions:[NSArray arrayWithObjects:question1, question2, nil]];
    STAssertEquals([[NSNumber numberWithInt:2] unsignedIntegerValue], [questions count], @"Wrong number of questions");

    NSUInteger expectedPossibleAnswers = 4;

    MultiAnswerQuestion *actualQ1 = [questions objectAtIndex:0];
    STAssertEquals(7, actualQ1.questionId, @"Wrong questionId");
    STAssertTrue([actualQ1.imageName isEqualToString:@"A14KGT.jpg"], @"Wrong imageName");
    STAssertTrue([actualQ1.correctAnswer isEqualToString:@"Falbala"], @"Wrong correctAnswer");
    STAssertTrue([actualQ1.question isEqualToString:@"What is the name of this famous Asterix character?"], @"Wrong question");
    STAssertEquals(100, [actualQ1 difficulty], @"Wrong difficulty");
    STAssertEquals(expectedPossibleAnswers, [actualQ1.possibleAnswers count], @"Wrong number of possible answers");
    STAssertTrue([[actualQ1.possibleAnswers objectAtIndex:0] isEqualToString:@"Impedimenta"], @"Wrong answer");
    STAssertTrue([[actualQ1.possibleAnswers objectAtIndex:1] isEqualToString:@"Falbala"], @"Wrong answer");
    STAssertTrue([[actualQ1.possibleAnswers objectAtIndex:2] isEqualToString:@"Angelica"], @"Wrong answer");
    STAssertTrue([[actualQ1.possibleAnswers objectAtIndex:3] isEqualToString:@"Belladonna"], @"Wrong answer");
    STAssertFalse([actualQ1 isAnswered], @"Wrong user answer");

    MultiAnswerQuestion *actualQ2 = [questions objectAtIndex:1];
    STAssertEquals(10, actualQ2.questionId, @"Wrong questionId");
    STAssertTrue([actualQ2.imageName isEqualToString:@"B8520F.jpg"], @"Wrong imageName");
    STAssertEquals(150, [actualQ2 difficulty], @"Wrong difficulty");
}

- (void)testLoadTrueFalseQuestions {
    NSNumber *question1 = [NSNumber numberWithInt:15];
    NSNumber *question2 = [NSNumber numberWithInt:12];

    NSArray *questions = [dbManager loadTrueFalseQuestions:[NSArray arrayWithObjects:question1, question2, nil]];
    STAssertEquals([[NSNumber numberWithInt:2] unsignedIntegerValue], [questions count], @"Wrong number of questions");

    TrueFalseQuestion *actualQ1 = [questions objectAtIndex:0];
    STAssertEquals(12, actualQ1.questionId, @"Wrong questionId");
    STAssertTrue([actualQ1.imageName isEqualToString:@"BGMDMC.jpg"], @"Wrong imageName");
    STAssertTrue([actualQ1.correctAnswer isEqualToString:@"TRUE"], @"Wrong correctAnswer");
    STAssertTrue([actualQ1.question isEqualToString:@"The Hurt Locker is the first film directed by a woman to win the Oscar for best director. True or False?"], @"Wrong question");
    STAssertEquals(50, [actualQ1 difficulty], @"Wrong difficulty");
    STAssertFalse([actualQ1 isAnswered], @"Expected not answered");
    STAssertNil([actualQ1 correctAnswerWhenFalse], @"Expected null correctAnswerWhenFalse");

    TrueFalseQuestion *actualQ2 = [questions objectAtIndex:1];
    STAssertEquals(15, actualQ2.questionId, @"Wrong questionId");
    STAssertTrue([actualQ2.imageName isEqualToString:@"B7WDBB.jpg"], @"Wrong imageName");
    STAssertTrue([actualQ2.correctAnswer isEqualToString:@"FALSE"], @"Wrong correctAnswer");
    STAssertTrue([actualQ2.question isEqualToString:@"Joey Lauren Adams won the Golden Globe for her performance in Chasing Amy"], @"Wrong question");
    STAssertEquals(25, [actualQ2 difficulty], @"Wrong difficulty");
    STAssertFalse([actualQ2 isAnswered], @"Expected not answered");
    STAssertEqualObjects(@"She lost to Helen Hunt for As Good as It Gets.", [actualQ2 correctAnswerWhenFalse], @"Wrong correctAnswerWhenFalse");
}

- (void)testLoadNextWhichOneCameFirst {
    WhichOneCameFirst *actual = [dbManager loadWhichOneCameFirstQuestion];
    STAssertEquals(16, actual.questionId, @"Wrong questionId");
    STAssertEqualObjects(@"kelly-gang-background.jpg", [actual imageName], @"Wrong imageName");
    STAssertEqualObjects(@"Rain Man", [actual correctAnswer], @"Wrong correctAnswer");
    STAssertEqualObjects(@"Which one came first?", [actual question], @"Wrong question");
    STAssertEquals(50, [actual difficulty], @"Wrong difficulty");
    STAssertFalse([actual isAnswered], @"Expected not answered");
    STAssertEqualObjects(@"Dead Poets Society", [actual movieTitle1], @"Wrong movie title");
    STAssertEqualObjects(@"Rain Man", [actual movieTitle2], @"Wrong movie title");
    STAssertEqualObjects(@"A7E8GA.jpg", [actual movieTitle1ImageName], @"Wrong movie image");
    STAssertEqualObjects(@"B85KC6.jpg", [actual movieTitle2ImageName], @"Wrong movie image");
    STAssertEquals(1989, [actual movieTitleYear1], @"Wrong movie year");
    STAssertEquals(1988, [actual movieTitleYear2], @"Wrong movie year");
}

- (void)testNumberOfQuestionsForSavedGame {
    int actualCount = [dbManager numberOfQuestionsForSavedGame];
    STAssertEquals(0, actualCount, @"No expected saved game");

    [DBHelper addRecordToSavedGameTable:tempDBPath];

    actualCount = [dbManager numberOfQuestionsForSavedGame];
    STAssertEquals(1, actualCount, @"Expected saved game with one question");
}

- (void)testSelectedQuestionForSavedGame {
    [DBHelper addRecordToSavedGameTable:tempDBPath];

    int actualCount = [dbManager intResultForSql:@"select selected_question_index from saved_game"];
    STAssertEquals(0, actualCount, @"Expected question index to be 0");
}

- (void)testLoadSavedGameReturnsNullWhenEmpty {
    Game *game = [dbManager loadSavedGame];
    STAssertNil(game, "Game not null");
}

- (void)testSaveGame {
    MultiAnswerQuestion *question1 = [[[MultiAnswerQuestion alloc] init] autorelease];
    [question1 setQuestionId:1];
    [question1 setDisplayIndex:0];
    [question1 answer:@"Circles and a triangle"];
    [question1 setAppearedOnScreen:TRUE];

    TrueFalseQuestion *question2 = [[[TrueFalseQuestion alloc] init] autorelease];
    [question2 setQuestionId:15];
    [question2 setDisplayIndex:1];
    [question2 answer:@"TRUE"];
    [question2 setAppearedOnScreen:FALSE];

    NSArray *questions = [[NSArray alloc] initWithObjects:question1, question2, nil];
    Game *game = [[[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10] autorelease];
    [game setCurrentQuestionIndex:2];
    [questions release];

    NSTimeInterval expectedTime1 = 9;
    [game setRemainingSeconds:expectedTime1];

    STAssertEquals(0, [dbManager numberOfQuestionsForSavedGame], @"No expected saved game");

    [dbManager saveGame:game];

    STAssertEquals(2, [dbManager numberOfQuestionsForSavedGame], @"Expected saved game with 2 questions");

    Game *resumedGame = [dbManager loadSavedGame];
    STAssertFalse([resumedGame finished], @"Expected game not finished");
    STAssertEquals(2, [resumedGame currentQuestionIndex], @"Wrong question index");
    STAssertEquals(2, [resumedGame numberOfQuestions], @"Wrong number of questions");
    STAssertFalse([resumedGame paused], @"Expected not paused");
    STAssertEquals(expectedTime1, resumedGame.remainingSeconds, @"Wrong remaining time");

    NSUInteger expectedQuestions = 2;
    NSUInteger expectedPossibleAnswers = 4;

    STAssertEquals(expectedQuestions, [resumedGame.questions count], @"Wrong loaded questions");

    MultiAnswerQuestion *actualQ1 = [resumedGame.questions objectAtIndex:0];
    STAssertEquals(1, actualQ1.questionId, @"Wrong questionId");
    STAssertTrue([actualQ1.imageName isEqualToString:@"B7TMDW.jpg"], @"Wrong imageName");
    STAssertTrue([actualQ1.correctAnswer isEqualToString:@"Circles and a triangle"], @"Wrong correctAnswer");
    STAssertTrue([actualQ1.question isEqualToString:@"In the Seven Samurais, which symbols on their war banner represent these brave warriors?"], @"Wrong question");
    STAssertEquals(expectedPossibleAnswers, [actualQ1.possibleAnswers count], @"Wrong number of possible answers");
    STAssertTrue([[actualQ1.possibleAnswers objectAtIndex:0] isEqualToString:@"Kanji symbols"], @"Wrong answer");
    STAssertTrue([[actualQ1.possibleAnswers objectAtIndex:1] isEqualToString:@"Circles and a triangle"], @"Wrong answer");
    STAssertTrue([[actualQ1.possibleAnswers objectAtIndex:2] isEqualToString:@"Great waves"], @"Wrong answer");
    STAssertTrue([[actualQ1.possibleAnswers objectAtIndex:3] isEqualToString:@"Dragons"], @"Wrong answer");
    STAssertEqualObjects(@"Circles and a triangle", [[actualQ1 userAnswers] lastObject], @"Wrong user answer");
    STAssertEquals(0, actualQ1.displayIndex, @"Wrong display index");

    TrueFalseQuestion *actualQ2 = [resumedGame.questions objectAtIndex:1];
    STAssertEquals(15, [actualQ2 questionId], @"Wrong questionId");
    STAssertEqualObjects(@"B7WDBB.jpg", [actualQ2 imageName], @"Wrong imageName");
    STAssertEqualObjects(@"FALSE", [actualQ2 correctAnswer], @"Wrong correctAnswer");
    STAssertEqualObjects(@"Joey Lauren Adams won the Golden Globe for her performance in Chasing Amy", [actualQ2 question], @"Wrong question");
    STAssertEqualObjects(@"TRUE", [[actualQ2 userAnswers] lastObject], @"Wrong user answer");
    STAssertEqualObjects(@"She lost to Helen Hunt for As Good as It Gets.", [actualQ2 correctAnswerWhenFalse], @"Wrong correct answer when false");
    STAssertEquals(1, [actualQ2 displayIndex], @"Wrong display index");
}

- (void)testSaveGameClearLastAnswerWhenCorrectlyAnswered {
    MultiAnswerQuestion *question1 = [[[MultiAnswerQuestion alloc] init] autorelease];
    [question1 setQuestionId:1];
    [question1 setDisplayIndex:0];
    [question1 answer:@"Kanji Symbols"];
    [question1 answer:@"Circles and a triangle"];
    [question1 setAppearedOnScreen:TRUE];

    TrueFalseQuestion *question2 = [[[TrueFalseQuestion alloc] init] autorelease];
    [question2 setQuestionId:15];
    [question2 setDisplayIndex:1];

    NSArray *questions = [[NSArray alloc] initWithObjects:question1, question2, nil];
    Game *game = [[[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10] autorelease];
    [game setCurrentQuestionIndex:0];
    [questions release];

    [dbManager saveGame:game];

    Game *resumedGame = [dbManager loadSavedGame];
    STAssertEquals(0, [resumedGame currentQuestionIndex], @"Wrong question index");

    MultiAnswerQuestion *actualQ1 = [resumedGame.questions objectAtIndex:0];
    STAssertTrue([actualQ1 isAnswered], @"Question answer not reset.");
    STAssertEqualObjects([actualQ1 userAnswerForDisplay], @"Kanji Symbols", @"Correct answer not removed");
    STAssertEquals(2, [actualQ1 numberOfTries], @"Number of tries incorrect");

}

- (void)testSavePausedGame {
    MultiAnswerQuestion *multi = [[[MultiAnswerQuestion alloc] init] autorelease];
    NSArray *questions = [[[NSArray alloc] initWithObjects:multi, nil] autorelease];
    Game *game = [[[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10] autorelease];
    [game setPaused:TRUE];

    [dbManager saveGame:game];

    Game *resumedGame = [dbManager loadSavedGame];
    STAssertTrue([resumedGame paused], @"Expected paused game");
}

- (void)testSaveGameMode {
    MultiAnswerQuestion *multi = [[[MultiAnswerQuestion alloc] init] autorelease];
    NSArray *questions = [[[NSArray alloc] initWithObjects:multi, nil] autorelease];
    Game *game = [[[Game alloc] initWithQuestions:questions gameMode:BEAT_THE_CLOCK] autorelease];

    [dbManager saveGame:game];

    Game *resumedGame = [dbManager loadSavedGame];
    STAssertEquals(BEAT_THE_CLOCK, [resumedGame gameMode], @"Expected BEAT_THE_CLOCK");
}

- (void)testSaveGameAppearedOnScreen {
    MultiAnswerQuestion *multi = [[[MultiAnswerQuestion alloc] init] autorelease];
    [multi setQuestionId:1];
    [multi setDisplayIndex:0];
    [multi setAppearedOnScreen:FALSE];

    TrueFalseQuestion *tf = [[[TrueFalseQuestion alloc] init] autorelease];
    [tf setQuestionId:12];
    [tf setDisplayIndex:1];
    [tf setAppearedOnScreen:TRUE];

    NSArray *questions = [[NSArray alloc] initWithObjects:multi, tf, nil];
    Game *game = [[[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10] autorelease];
    [game setCurrentQuestionIndex:0];
    [questions release];

    [dbManager saveGame:game];

    STAssertEquals(2, [dbManager numberOfQuestionsForSavedGame], @"Expected saved game with 2 questions");

    Game *resumedGame = [dbManager loadSavedGame];

    MultiAnswerQuestion *actual1 = [resumedGame.questions objectAtIndex:0];
    STAssertFalse(actual1.appearedOnScreen, @"Expected appeared on screen");

    TrueFalseQuestion *actual2 = [resumedGame.questions objectAtIndex:1];
    STAssertTrue(actual2.appearedOnScreen, @"Expected appeared on screen");
}

- (void)testSaveGameWithDifferentQuestionTypes {
    MultiAnswerQuestion *question1 = [[[MultiAnswerQuestion alloc] init] autorelease];
    [question1 setQuestionId:1];
    [question1 setDisplayIndex:0];
    [question1 answer:@"Circles and a triangle"];

    TrueFalseQuestion *question2 = [[[TrueFalseQuestion alloc] init] autorelease];
    [question2 setQuestionId:12];
    [question2 setDisplayIndex:1];

    WhichOneCameFirst *question3 = [[[WhichOneCameFirst alloc] init] autorelease];
    [question3 setQuestionId:16];
    [question3 setDisplayIndex:2];
    [question3 answer:@"Rain Man"];

    NSArray *questions = [[NSArray alloc] initWithObjects:question1, question2, question3, nil];
    Game *game = [[[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10] autorelease];
    [game setCurrentQuestionIndex:3];
    [questions release];

    [dbManager saveGame:game];

    Game *resumedGame = [dbManager loadSavedGame];
    STAssertFalse([resumedGame finished], @"Expected game not finished");
    STAssertEquals(3, [resumedGame currentQuestionIndex], @"Wrong question index");
    STAssertEquals(3, [resumedGame numberOfQuestions], @"Wrong number of questions");

    MultiAnswerQuestion *actualQ1 = [resumedGame.questions objectAtIndex:0];
    STAssertEquals(1, actualQ1.questionId, @"Wrong questionId");
    STAssertEquals(0, actualQ1.displayIndex, @"Wrong displayIndex");
    STAssertEqualObjects(@"Circles and a triangle", [[actualQ1 userAnswers] lastObject], @"Wrong user answer");

    TrueFalseQuestion *actualQ2 = [resumedGame.questions objectAtIndex:1];
    STAssertEquals(12, actualQ2.questionId, @"Wrong questionId");
    STAssertEquals(1, actualQ2.displayIndex, @"Wrong displayIndex");
    STAssertEqualObjects(@"BGMDMC.jpg", actualQ2.imageName, @"Wrong imageName");
    STAssertEqualObjects(@"TRUE", actualQ2.correctAnswer, @"Wrong correctAnswer");
    STAssertEqualObjects(@"The Hurt Locker is the first film directed by a woman to win the Oscar for best director. True or False?", actualQ2.question, @"Wrong question");
    STAssertFalse([actualQ2 isAnswered], @"Expected no user answer");
    STAssertEquals(50, [actualQ2 difficulty], @"Wrong difficulty");

    WhichOneCameFirst *actualQ3 = [resumedGame.questions objectAtIndex:2];
    STAssertEquals(16, actualQ3.questionId, @"Wrong questionId");
    STAssertEquals(2, actualQ3.displayIndex, @"Wrong displayIndex");
    STAssertEqualObjects(@"Rain Man", [[actualQ3 userAnswers] lastObject], @"Wrong user answer");
}

- (void)testSaveGameNumberOfLives {
    TrueFalseQuestion *question1 = [[[TrueFalseQuestion alloc] init] autorelease];
    [question1 setQuestionId:12];
    [question1 setDisplayIndex:0];

    NSArray *questions = [[NSArray alloc] initWithObjects:question1, nil];
    Game *game = [[[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10] autorelease];
    [game decreaseLivesRemaining];
    int expected = [game remainingLives];
    [questions release];

    [dbManager saveGame:game];

    Game *resumedGame = [dbManager loadSavedGame];
    STAssertEquals(expected, [resumedGame remainingLives], @"Wrong number of lifes");
}

- (void)testSaveGameSuspended {
    TrueFalseQuestion *question1 = [[[TrueFalseQuestion alloc] init] autorelease];
    [question1 setQuestionId:12];
    [question1 setDisplayIndex:0];

    NSArray *questions = [[[NSArray alloc] initWithObjects:question1, nil] autorelease];
    Game *game = [[[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10] autorelease];
    [game setSuspended:true];

    [dbManager saveGame:game];

    Game *resumedGame = [dbManager loadSavedGame];
    STAssertTrue([resumedGame suspended], @"Expected suspended");
}

- (void)testSaveGameQuestionWithApostrophe {
    MultiAnswerQuestion *question1 = [[[MultiAnswerQuestion alloc] init] autorelease];
    [question1 setQuestionId:3];
    [question1 setDisplayIndex:0];
    [question1 answer:@"Saruman's eye"];

    NSArray *questions = [[NSArray alloc] initWithObjects:question1, nil];
    Game *game = [[[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10] autorelease];
    [questions release];

    [dbManager saveGame:game];

    Game *resumedGame = [dbManager loadSavedGame];
    TrueFalseQuestion *savedQuestion = [resumedGame.questions lastObject];
    STAssertEqualObjects(@"Saruman's eye", [savedQuestion correctAnswer], @"");
}

- (void)testUpdateNumberOfAppearancesForGameQuestions {
    Question *question1 = [[[Question alloc] init] autorelease];
    [question1 setQuestionId:2];
    [question1 setCorrectAnswer:@"cecile de france"];
    [question1 answer:@"marion cotillard"];
    [question1 setAppearedOnScreen:TRUE];

    Question *question2 = [[[Question alloc] init] autorelease];
    [question2 setQuestionId:5];
    [question2 setCorrectAnswer:@"clint eastwood"];
    [question2 answer:@"clint eastwood"];
    [question2 setAppearedOnScreen:TRUE];

    NSArray *questions = [[[NSArray alloc] initWithObjects:question1, question2, nil] autorelease];
    Game *game = [[[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10] autorelease];

    int expectedNumAppearancesQ1 = [DBHelper countNumberOfAppearances:tempDBPath questionId:2];
    int expectedNumAppearancesQ2 = [DBHelper countNumberOfAppearances:tempDBPath questionId:5];

    [dbManager updateNumberOfAppearancesForGameQuestions:game];

    int actualNumAppearancesQ1 = [DBHelper countNumberOfAppearances:tempDBPath questionId:2];
    int actualNumAppearancesQ2 = [DBHelper countNumberOfAppearances:tempDBPath questionId:5];

    STAssertEquals(expectedNumAppearancesQ1, actualNumAppearancesQ1, @"Expected number of appearances NOT to increase");
    STAssertEquals(expectedNumAppearancesQ2 + 1, actualNumAppearancesQ2, @"Expected number of appearances to increase");
}

- (void)testUpdateNumberOfAppearancesForGameQuestionsNotAnswered {
    Question *question1 = [[[Question alloc] init] autorelease];
    [question1 setQuestionId:10];

    NSArray *questions = [[[NSArray alloc] initWithObjects:question1, nil] autorelease];
    Game *game = [[[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10] autorelease];

    int expected = [DBHelper countNumberOfAppearances:tempDBPath questionId:10];

    [dbManager updateNumberOfAppearancesForGameQuestions:game];

    int actual = [DBHelper countNumberOfAppearances:tempDBPath questionId:10];

    STAssertEquals(expected, actual, @"Expected number of appearances NOT to increase");
}

- (void)testDatabaseVersion {
    NSString *const expected = @"2.0";
    NSString *const actual = [dbManager databaseVersion];
    STAssertEqualObjects(expected, actual, @"Expected '%@', Got '%@'", expected, actual);
}

- (void)testDatabaseVersionForLegacyDatabase {
    [dbManager executeStatement:@"drop table about"]; //simulate we have 1.0 version
    NSString *const actual = [dbManager databaseVersion];
    STAssertEqualObjects(LEGACY_DB_VERSION, actual, @"Expected '%@', Got '%@'", LEGACY_DB_VERSION, actual);
}


@end
