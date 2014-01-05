//
//  SQLStatementHelperTests.m
//  CloseUp
//
//  Created by Fede on 11/05/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "SQLStatementHelper.h"

@interface SQLStatementHelperTests : SenTestCase {
}
@end

@implementation SQLStatementHelperTests

- (void)testInsertGameSQL {
    NSArray *questions = [[[NSArray alloc] initWithObjects:nil] autorelease];
    Game *game = [[[Game alloc] initWithQuestions:questions gameMode:SUDDEN_DEATH] autorelease];
    [game setCurrentQuestionIndex:3];
    [game setRemainingLives:2];
    [game setRemainingSeconds:4];
    [game setSuspended:true];

    NSString *actualSQL = [SQLStatementHelper insertGameSQL:game];
    NSString *expectedSQL = @"insert into saved_game(saved_game_id, selected_question_index, remaining_lives, paused, remaining_seconds, game_mode, suspended)";
    expectedSQL = [expectedSQL stringByAppendingString:@" values('RESUMED', 3, 2, 0, 4, 2, 1)"];

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

- (void)testInsertQuestionSQL {
    Question *question = [[[Question alloc] init] autorelease];
    [question setQuestionId:5];
    [question setDisplayIndex:10];
    [question answer:@"Burbank, LA"];
    [question setAppearedOnScreen:FALSE];

    NSString *actualSQL = [SQLStatementHelper insertQuestionSQL:question];
    NSString *expectedSQL = @"insert into saved_game_question(saved_game_id, question_id, user_answer, question_index, appeared_on_screen)";
    expectedSQL = [expectedSQL stringByAppendingString:@" values('RESUMED', 5, \"{Burbank, LA}\", 10, 0)"];

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

- (void)testInsertQuestionMultipleUserAnswersSQL {
    Question *question = [[[Question alloc] init] autorelease];
    [question setNumberOfTries:2];
    [question setQuestionId:5];
    [question setDisplayIndex:10];
    [question answer:@"Burbank"];
    [question answer:@"Echo Park"];
    [question setAppearedOnScreen:FALSE];

    NSString *actualSQL = [SQLStatementHelper insertQuestionSQL:question];
    NSString *expectedSQL = @"insert into saved_game_question(saved_game_id, question_id, user_answer, question_index, appeared_on_screen)";
    expectedSQL = [expectedSQL stringByAppendingString:@" values('RESUMED', 5, \"{Burbank},{Echo Park}\", 10, 0)"];

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

- (void)testInsertQuestionAppearedOnScreenSQL {
    Question *question = [[[Question alloc] init] autorelease];
    [question setQuestionId:5];
    [question setDisplayIndex:10];
    [question answer:@"Burbank, LA"];
    [question setAppearedOnScreen:TRUE];

    NSString *actualSQL = [SQLStatementHelper insertQuestionSQL:question];
    NSString *expectedSQL = @"insert into saved_game_question(saved_game_id, question_id, user_answer, question_index, appeared_on_screen)";
    expectedSQL = [expectedSQL stringByAppendingString:@" values('RESUMED', 5, \"{Burbank, LA}\", 10, 1)"];

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

- (void)testInsertQuestionSQLWithNullValue {
    Question *question = [[[Question alloc] init] autorelease];
    [question setQuestionId:7];
    [question setDisplayIndex:2];

    NSString *actualSQL = [SQLStatementHelper insertQuestionSQL:question];
    NSString *expectedSQL = @"insert into saved_game_question(saved_game_id, question_id, user_answer, question_index, appeared_on_screen)";
    expectedSQL = [expectedSQL stringByAppendingString:@" values('RESUMED', 7, null, 2, 0)"];

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

- (void)testSelectMultiAnswerQuestionsSQL {
    NSNumber *question1 = [NSNumber numberWithInt:7];
    NSNumber *question2 = [NSNumber numberWithInt:10];

    NSArray *questionIds = [[[NSArray alloc] initWithObjects:question1, question2, nil] autorelease];

    NSString *actualSQL = [SQLStatementHelper selectMultiAnswerQuestionsSQL:questionIds];
    NSString *expectedSQL = @"select q.question_id, q.image_name, q.correct_answer, q.question_text, q.difficulty, ma.answer1, ma.answer2, ma.answer3, ma.answer4 from question q";
    expectedSQL = [expectedSQL stringByAppendingString:@" inner join multi_answer_question ma on q.question_id = ma.question_id where q.question_id in (7, 10)"];

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

- (void)testSelectTrueFalseQuestionsSQL {
    NSNumber *question1 = [NSNumber numberWithInt:7];
    NSNumber *question2 = [NSNumber numberWithInt:10];
    NSNumber *question3 = [NSNumber numberWithInt:15];

    NSArray *questionIds = [[[NSArray alloc] initWithObjects:question1, question2, question3, nil] autorelease];

    NSString *actualSQL = [SQLStatementHelper selectTrueFalseQuestionsSQL:questionIds];
    NSString *expectedSQL = @"select q.question_id, q.image_name, q.correct_answer, q.question_text, q.difficulty, tf.answer_when_false from question q";
    expectedSQL = [expectedSQL stringByAppendingString:@" inner join true_false_question tf on q.question_id = tf.question_id where q.question_id in (7, 10, 15)"];

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

- (void)testSelectWhichOneCameFirstQuestionSQL {
    NSString *actualSQL = [SQLStatementHelper selectWhichOneCameFirstQuestionSQL:@"29"];
    NSString *expectedSQL = @"select q.question_id, q.image_name, q.correct_answer, q.question_text, q.difficulty, w.movie_title1, w.movie_title2, w.movie_title1_image, w.movie_title2_image, w.movie_title1_year, w.movie_title2_year from question q";
    expectedSQL = [expectedSQL stringByAppendingString:@" inner join which_one_came_first w on q.question_id = w.question_id where q.question_id = 29"];

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

- (void)testUpdateNumberOfAppearancesSQL {
    Question *question1 = [[[Question alloc] init] autorelease];
    [question1 setQuestionId:7];
    Question *question2 = [[[Question alloc] init] autorelease];
    [question2 setQuestionId:10];
    Question *question3 = [[[Question alloc] init] autorelease];
    [question3 setQuestionId:1];
    NSArray *questions = [[[NSArray alloc] initWithObjects:question1, question2, question3, nil] autorelease];

    NSString *actualSQL = [SQLStatementHelper updateNumberOfAppearancesSQL:questions];
    NSString *expectedSQL = @"update question set number_appearances = number_appearances + 1 where question_id in (7, 10, 1)";

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

- (void)testInsertHighScoreSQL {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowString = [dateFormatter stringFromDate:[NSDate date]];

    Score *score = [[[Score alloc] init] autorelease];
    [score setDate:[NSDate date]];
    [score setTotalQuestions:2];
    [score setCorrectQuestions:1];
    [score setPoints:135];

    NSString *actualSQL = [SQLStatementHelper insertHighScoreSQL:score];
    NSString *expectedSQL = @"insert into high_scores(total_questions, correct_questions, points, date_game) values(2, 1, 135, date('";
    expectedSQL = [expectedSQL stringByAppendingString:nowString];
    expectedSQL = [expectedSQL stringByAppendingString:@"'))"];

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

- (void)testMinNumberOfAppearancesForQuestionTableSQL {
    NSString *actualSQL = [SQLStatementHelper minNumberOfAppearancesForQuestionTableSQL:@"question_tbl" minNumAppearances:3];
    NSString *expectedSQL = @"select ifnull(min(number_appearances), -1) from question parent inner join question_tbl child on parent.question_id = child.question_id where parent.number_appearances > 3";

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

- (void)testCountNumberOfQuestionsWithNumberOfAppearancesSQL {
    NSString *actualSQL = [SQLStatementHelper countNumberOfQuestionsWithNumberOfAppearancesSQL:@"toto_tbl" numAppearances:8];
    NSString *expectedSQL = @"select count(1) from question parent inner join toto_tbl child on parent.question_id = child.question_id where parent.number_appearances = 8";

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

- (void)testSelectRandomQuestionsSQL {
    NSString *actualSQL = [SQLStatementHelper selectRandomQuestionsSQL:@"toto_tbl" numAppearances:8 limit:5];
    NSString *expectedSQL = @"select distinct parent.question_id from question parent inner join toto_tbl child on parent.question_id = child.question_id where parent.number_appearances = 8 order by random() limit 5";

    STAssertEqualObjects(expectedSQL, actualSQL, @"Wrong SQL produced");
}

@end
