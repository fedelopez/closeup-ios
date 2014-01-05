//
//  ScoreDAOTests.m
//  CloseUp
//
//  Created by Federico Lopez Laborda on 7/6/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "DBHelper.h"
#import "ScoreDAO.h"


@interface ScoreDAOTests : SenTestCase {
    ScoreDAO *scoreDAO;
    NSString *tempDBPath;
    NSFileManager *fileManager;
}
@end

@implementation ScoreDAOTests

- (void)setUp {
    NSString *questionsSmallDB = @"questions-small.sqlite";
    NSString *databasePath = [[NSBundle bundleForClass:[self class]] pathForResource:questionsSmallDB ofType:nil];
    tempDBPath = [databasePath stringByReplacingOccurrencesOfString:questionsSmallDB withString:@"db-manager-tests.sqlite"];
    fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtPath:tempDBPath error:NULL];
    [fileManager copyItemAtPath:databasePath toPath:tempDBPath error:NULL];
    NSLog(@"DB path for tests: %@", tempDBPath);
    scoreDAO = [[ScoreDAO alloc] initWithDbFileName:tempDBPath];
}

- (void)tearDown {
    [fileManager removeItemAtPath:tempDBPath error:NULL];
    [fileManager release];
    [scoreDAO release];
}

- (void)testSaveScore {
    int count = [DBHelper countRowsOnTable:tempDBPath tableName:@"high_scores"];
    STAssertEquals(3, count, @"Wrong number of scores");

    Score *score = [[[Score alloc] init] autorelease];
    [score setDate:[NSDate date]];
    [score setPoints:345];
    [score setTotalQuestions:10];
    [score setCorrectQuestions:6];

    [scoreDAO saveScore:score];

    count = [DBHelper countRowsOnTable:tempDBPath tableName:@"high_scores"];
    STAssertEquals(4, count, @"Expected score to be saved");
}

- (void)testDoNotSaveScoreWhenZeroPoints {
    int count = [DBHelper countRowsOnTable:tempDBPath tableName:@"high_scores"];
    STAssertEquals(3, count, @"Wrong number of scores");

    Score *score = [[[Score alloc] init] autorelease];
    [score setDate:[NSDate date]];
    [score setPoints:0];
    [score setCorrectQuestions:0];

    [scoreDAO saveScore:score];

    count = [DBHelper countRowsOnTable:tempDBPath tableName:@"high_scores"];
    STAssertEquals(3, count, @"Expected score not to be saved");
}

- (void)testLoadHighScores {
    NSArray *highScores = [scoreDAO loadHighScores];
    NSUInteger expectedRows = 3;
    STAssertEquals(expectedRows, [highScores count], @"Expected with high scores");

    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    Score *highScore = [highScores objectAtIndex:0];
    STAssertEquals(10, [highScore totalQuestions], @"Wrong total questions");
    STAssertEquals(8, [highScore correctQuestions], @"Wrong correct questions");
    STAssertEquals(2000, [highScore points], @"Wrong points");
    STAssertEqualObjects([dateFormatter dateFromString:@"2010-06-01"], [highScore date], @"Wrong date");

    highScore = [highScores objectAtIndex:1];
    STAssertEquals(10, [highScore totalQuestions], @"Wrong total questions");
    STAssertEquals(5, [highScore correctQuestions], @"Wrong correct questions");
    STAssertEquals(1500, [highScore points], @"Wrong points");
    STAssertEqualObjects([dateFormatter dateFromString:@"2010-06-04"], [highScore date], @"Wrong date");

    highScore = [highScores objectAtIndex:2];
    STAssertEquals(10, [highScore totalQuestions], @"Wrong total questions");
    STAssertEquals(1, [highScore correctQuestions], @"Wrong correct questions");
    STAssertEquals(25, [highScore points], @"Wrong points");
    STAssertEqualObjects([dateFormatter dateFromString:@"2010-06-03"], [highScore date], @"Wrong date");
}

- (void)testIsHighScore {
    Score *score = [[[Score alloc] init] autorelease];
    [score setPoints:0];
    STAssertFalse([scoreDAO isHighScore:score], @"Is high score");

    [score setPoints:2001];
    STAssertTrue([scoreDAO isHighScore:score], @"Not high score");
}

- (void)testIsHighScoreWhenNullPoints {
    Score *score = [[[Score alloc] init] autorelease];
    STAssertFalse([scoreDAO isHighScore:score], @"Is high score");
}

- (void)testLoadStatsTrendDown {
    Stats *stats = [scoreDAO loadStats];
    STAssertEquals(47, [stats accuracy], @"Wrong accuracy");
    STAssertEquals(5, [stats average], @"Wrong average");
    STAssertEquals(DOWN, [stats trend], @"Wrong trend");
}

- (void)testLoadStatsTrendLevel {
    [scoreDAO executeStatement:@"update high_scores set correct_questions = 8 where high_score_id = 3"];
    Stats *stats = [scoreDAO loadStats];
    STAssertEquals(70, [stats accuracy], @"Wrong accuracy");
    STAssertEquals(7, [stats average], @"Wrong average");
    STAssertEquals(LEVEL, [stats trend], @"Wrong trend");
}

- (void)testLoadStatsTrendUp {
    [scoreDAO executeStatement:@"update high_scores set correct_questions = 9 where high_score_id = 3"];
    Stats *stats = [scoreDAO loadStats];
    STAssertEquals(73, [stats accuracy], @"Wrong accuracy");
    STAssertEquals(7, [stats average], @"Wrong average");
    STAssertEquals(UP, [stats trend], @"Wrong trend");
}

- (void)testLoadStatsTrendUpWhenTotalQuestionsAnswered {
    [scoreDAO executeStatement:@"update high_scores set correct_questions = 10 where high_score_id = 3"];
    Stats *stats = [scoreDAO loadStats];
    STAssertEquals(UP, [stats trend], @"Wrong trend");
}

- (void)testLoadStatsOneScoreOnly {
    [scoreDAO executeStatement:@"delete from high_scores where high_score_id in (2, 3)"];
    Stats *stats = [scoreDAO loadStats];
    STAssertEquals(50, [stats accuracy], @"Wrong accuracy");
    STAssertEquals(5, [stats average], @"Wrong average");
    STAssertEquals(LEVEL, [stats trend], @"Wrong trend");
}

- (void)testLoadStatsNoScores {
    [scoreDAO executeStatement:@"delete from high_scores"];
    Stats *stats = [scoreDAO loadStats];
    STAssertEquals(0, [stats accuracy], @"Wrong accuracy");
    STAssertEquals(0, [stats average], @"Wrong average");
    STAssertEquals(NONE, [stats trend], @"Wrong trend");
}

@end
