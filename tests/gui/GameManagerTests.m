//
//  Created by fede on 3/3/12.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Game.h"
#import "GameManager.h"
#import "OCMockObject.h"
#import "OCMArg.h"
#import "OCMockRecorder.h"

@interface GameManagerTests : SenTestCase {
    GameManager *gameManager;
    Game *game;
    id gameDAO;
    Question *question1, *question2, *question3, *question4, *question5, *question6;
    id theNavigationController;
}
@end


@implementation GameManagerTests

- (void)setUp {
    question1 = [[Question alloc] init];
    [question1 setQuestionId:0];
    [question1 setDisplayIndex:0];
    [question1 setNumberOfTries:3];
    [question1 setCorrectAnswer:@"The soggy bottom boys"];
    question2 = [[Question alloc] init];
    [question2 setQuestionId:1];
    [question2 setDisplayIndex:1];
    [question2 setNumberOfTries:3];
    [question2 setCorrectAnswer:@"Underbelly"];
    question3 = [[MultiAnswerQuestion alloc] init];
    [question3 setQuestionId:2];
    [question3 setDisplayIndex:2];
    [question3 setNumberOfTries:3];
    [question3 setCorrectAnswer:@"Underbelly: Razor"];
    question4 = [[Question alloc] init];
    [question4 setQuestionId:3];
    [question4 setDisplayIndex:3];
    [question4 setNumberOfTries:3];
    [question4 setCorrectAnswer:@"Jurassic Park"];
    question5 = [[Question alloc] init];
    [question5 setQuestionId:4];
    [question5 setDisplayIndex:4];
    [question5 setNumberOfTries:3];
    [question5 setCorrectAnswer:@"Friends"];
    question6 = [[Question alloc] init];
    [question6 setQuestionId:5];
    [question6 setDisplayIndex:5];
    [question6 setNumberOfTries:3];
    [question6 setCorrectAnswer:@"How I met your mother"];

    NSArray *questions = [[NSArray alloc] initWithObjects:question1, question2, question3, question4, question5, question6, nil];
    game = [[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10];
    [questions release];

    theNavigationController = [[OCMockObject mockForClass:[UINavigationController class]] retain];
    gameDAO = [[OCMockObject mockForClass:[GameDAO class]] retain];

    gameManager = [[GameManager alloc] initGameManager:theNavigationController];
    [gameManager setGame:game];
    [gameManager setGameDAO:gameDAO];
}

- (void)tearDown {
    [question1 release];
    [question2 release];
    [question3 release];
    [question4 release];
    [question5 release];
    [question6 release];
    [game release];
    [gameManager release];
    [gameDAO release];
    [theNavigationController release];
}

- (void)testRemainingSecondsUpdatesGameInstance {
    NSTimeInterval remainingSeconds = 3;
    [gameManager remainingSeconds:remainingSeconds];
    STAssertEquals(remainingSeconds, [game remainingSeconds], @"Time not set on game");
}


- (void)testGameCompletedAchievement {
    [[theNavigationController expect] presentViewController:[OCMArg any] animated:TRUE completion:[OCMArg any]];
    [[gameDAO expect] updateNumberOfAppearancesForGameQuestions:game];

    NSUInteger expectedCount = 0;
    STAssertEquals(expectedCount, [game.achievements count], @"No achievements expected");

    expectedCount = 1;
    [gameManager displayQuestion:question6.displayIndex + 1];

    STAssertEquals(expectedCount, [game.achievements count], @"One achievement expected");
    STAssertEquals(GAME_COMPLETED, [[game.achievements objectAtIndex:0] achievementType], @"Expected GAME_COMPLETED");
}


- (void)testThreeInARowNotAchieved {
    [[theNavigationController expect] pushViewController:[OCMArg any] animated:TRUE];
    [question1 answer:@"The beach boys"];
    [gameManager questionAnswered:question1];
    NSUInteger zero = 0;
    STAssertEquals(zero, [game.achievements count], @"No achievements expected");

    [[theNavigationController expect] pushViewController:[OCMArg any] animated:TRUE];
    [question2 answer:@"Underbelly"];
    [gameManager questionAnswered:question2];
    STAssertEquals(zero, [game.achievements count], @"No achievements expected");

    [[theNavigationController expect] pushViewController:[OCMArg any] animated:TRUE];
    [question3 answer:@"Goodfellas"];
    [gameManager questionAnswered:question3];
    STAssertEquals(zero, [game.achievements count], @"No achievements expected");
}

- (void)testThreeInARowCounterReset {
    [[theNavigationController expect] pushViewController:[OCMArg any] animated:TRUE];
    [question1 answer:@"The soggy bottom boys"];
    [gameManager questionAnswered:question1];
    NSUInteger zero = 0;
    STAssertEquals(zero, [game.achievements count], @"No achievements expected");

    [[theNavigationController expect] pushViewController:[OCMArg any] animated:TRUE];
    [question2 answer:@"Underbelly"];
    [gameManager questionAnswered:question2];
    STAssertEquals(zero, [game.achievements count], @"No achievements expected");

    [question3 answer:@"Love my way"];
    [gameManager questionAnswered:question3];
    STAssertEquals(zero, [game.achievements count], @"No achievements expected");

    [[theNavigationController expect] pushViewController:[OCMArg any] animated:TRUE];
    [question3 answer:@"Underbelly: Razor"];
    [gameManager questionAnswered:question3];
    STAssertEquals(zero, [game.achievements count], @"No achievements expected");
}

- (void)testThreeInARowAchieved {
    [[theNavigationController expect] pushViewController:[OCMArg any] animated:TRUE];
    [question1 answer:@"The soggy bottom boys"];
    [gameManager questionAnswered:question1];
    NSUInteger expected = 0;
    STAssertEquals(expected, [game.achievements count], @"No achievements expected");

    [[theNavigationController expect] pushViewController:[OCMArg any] animated:TRUE];
    [question2 answer:@"Underbelly"];
    [gameManager questionAnswered:question2];
    STAssertEquals(expected, [game.achievements count], @"No achievements expected");

    [[theNavigationController expect] pushViewController:[OCMArg any] animated:TRUE];
    [[theNavigationController expect] visibleViewController];

    [question3 answer:@"Underbelly: Razor"];
    [gameManager questionAnswered:question3];
    expected = 1;
    STAssertEquals(expected, [game.achievements count], @"Achievement expected");
    STAssertEquals(THREE_IN_A_ROW, [[game.achievements objectAtIndex:0] achievementType], @"Achievement expected");
}

- (void)testGameFinishedAfterExpiringLives {
    STAssertFalse([game finished], @"Game finished");

    [question1 setNumberOfTries:3];

    [[theNavigationController expect] pushViewController:[OCMArg any] animated:TRUE];
    [[gameDAO expect] updateNumberOfAppearancesForGameQuestions:game];

    [question1 answer:@"The soggy bottom kids"];
    [gameManager questionAnswered:question1];

    [question1 answer:@"The soggy bottom dudes"];
    [gameManager questionAnswered:question1];

    [[theNavigationController expect] presentViewController:[OCMArg any] animated:YES completion:[OCMArg any]];
    [question1 answer:@"The soggy bottom children"];
    [gameManager questionAnswered:question1];

    STAssertTrue([game finished], @"Game not finished");
}

- (void)testPauseGame {
    STAssertFalse([game paused], @"Expected not paused.");
    [[theNavigationController expect] pushViewController:[OCMArg any] animated:TRUE];
    [gameManager pauseGame:question1];
    STAssertTrue([game paused], @"Expected paused.");
    [theNavigationController verify];
}

- (void)testResumeGame {
    [[theNavigationController expect] popViewControllerAnimated:TRUE];
    id questionVC = [[[OCMockObject mockForClass:[QuestionViewController class]] retain] autorelease];
    [[[theNavigationController stub] andReturn:questionVC] visibleViewController];
    [game setPaused:TRUE];

    [[questionVC expect] resumeTimeIndicator];

    [gameManager resumeGame];

    STAssertFalse([game paused], @"Expected resumed.");
    [theNavigationController verify];
}

@end