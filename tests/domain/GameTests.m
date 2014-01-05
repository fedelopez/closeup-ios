//
//  GameTests.m
//  CloseUp
//
//  Created by Fede on 25/03/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "Game.h"

@interface GameTests : SenTestCase {
    Question *question1;
    Question *question2;
    Question *question3;
    Game *game;
}
@end

@implementation GameTests

- (void)setUp {
    question1 = [[Question alloc] init];
    [question1 setQuestionId:1];
    [question1 setCorrectAnswer:@"Burbank, LA"];

    question2 = [[Question alloc] init];
    [question2 setQuestionId:2];
    [question2 setCorrectAnswer:@"Sarah Connor"];

    question3 = [[Question alloc] init];
    [question3 setQuestionId:3];
    [question3 setCorrectAnswer:@"The soggy bottom boys"];

    NSArray *questions = [[NSArray alloc] initWithObjects:question1, question2, question3, nil];
    game = [[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10];
    [questions release];
}

- (void)tearDown {
    [question1 release];
    [question2 release];
    [question3 release];
    [game release];
}

- (void)testDefaultNumberOfSecondsToAnswer {
    STAssertEquals(DefaultNumberOfSecondsToAnswer, [game remainingSeconds], @"Wrong initialisation");

    NSTimeInterval timeInterval = 8;
    [game setRemainingSeconds:timeInterval];
    STAssertEquals(timeInterval, [game remainingSeconds], @"Wrong set value");
}

- (void)testAddAchievement {
    NSUInteger count = 0;
    STAssertEquals(count, [game.achievements count], @"Expected no achievements");

    Achievement *gameCompleted = [[[Achievement alloc] init] autorelease];
    [gameCompleted setAchievementType:GAME_COMPLETED];
    [game addAchievement:gameCompleted];
    Achievement *threeInARow = [[[Achievement alloc] init] autorelease];
    [threeInARow setAchievementType:THREE_IN_A_ROW];
    [game addAchievement:threeInARow];

    count = 2;
    STAssertEquals(count, [game.achievements count], @"Expected two achievements");

    STAssertEquals(gameCompleted, [game.achievements objectAtIndex:0], @"Expected game completed");
    STAssertEquals(threeInARow, [game.achievements objectAtIndex:1], @"Expected three in a row");
}

- (void)testAddAchievementOneEachOnly {
    Achievement *gameCompleted = [[[Achievement alloc] init] autorelease];
    [gameCompleted setAchievementType:GAME_COMPLETED];
    [game addAchievement:gameCompleted];
    Achievement *gameCompleted2 = [[[Achievement alloc] init] autorelease];
    [gameCompleted2 setAchievementType:GAME_COMPLETED];
    [game addAchievement:gameCompleted2];

    NSUInteger count = 1;
    STAssertEquals(count, [game.achievements count], @"Expected two achievements");

    STAssertEquals(gameCompleted, [game.achievements objectAtIndex:0], @"Expected game completed");
}

- (void)testCurrentQuestion {
    Question *actualQuestion = [game currentQuestion];
    STAssertEquals(1, actualQuestion.questionId, @"Expected question 1");

    actualQuestion = [game currentQuestion];
    STAssertEquals(1, actualQuestion.questionId, @"Expected question 1");
}

- (void)testNumberOfQuestions {
    STAssertEquals(3, [game numberOfQuestions], @"Wrong number of questions");
}

- (void)testApplyCurrentQuestion {
    [game applyCurrentQuestion:question2];
    Question *actualQuestion = [game currentQuestion];
    STAssertEquals(2, actualQuestion.questionId, @"Expected question 2");
}

- (void)testNumberOfCorrectQuestions {
    STAssertEquals(0, [game numberOfCorrectQuestions], @"Expected no correct questions");
    [question1 answer:@"Burbank, LA"];
    STAssertEquals(1, [game numberOfCorrectQuestions], @"Expected one correct questions");
    [question2 answer:@"sarah connor"];
    STAssertEquals(2, [game numberOfCorrectQuestions], @"Expected two correct questions");
    [question3 answer:@"The soggy bottom boys"];
    STAssertEquals(3, [game numberOfCorrectQuestions], @"Expected three correct questions");

    [question3 answer:@"Je ne sais pas"];
    STAssertEquals(2, [game numberOfCorrectQuestions], @"Expected two correct questions");
}

- (void)testNumberOfUnansweredQuestions {
    STAssertEquals(3, [game numberOfUnansweredQuestions], @"Expected all questions unanswered");

    [question1 answer:@"Burbank, LA"];
    STAssertEquals(2, [game numberOfUnansweredQuestions], @"Expected two questions unanswered");

    [question2 answer:@"sarah connor"];
    STAssertEquals(1, [game numberOfUnansweredQuestions], @"Expected one questions unanswered");

    [question3 answer:@"The soggy bottom boys"];
    STAssertEquals(0, [game numberOfUnansweredQuestions], @"Expected all questions answered");
}

- (void)testNumberOfUnansweredQuestionsWhenSomeTimedUp {
    [question1 setTimedUp:TRUE];
    STAssertEquals(2, [game numberOfUnansweredQuestions], @"Expected two questions unanswered");

    [question2 setTimedUp:TRUE];
    STAssertEquals(1, [game numberOfUnansweredQuestions], @"Expected one questions unanswered");

    [question3 setTimedUp:TRUE];
    STAssertEquals(0, [game numberOfUnansweredQuestions], @"Expected all questions answered");
}

- (void)testUnansweredQuestionsDisplayText {
    STAssertTrue([[game unansweredQuestionsDisplayText] isEqualToString:@"You have 3 unanswered questions"], @"Wrong text for unanswered questions");

    [question1 answer:@"Burbank, LA"];
    STAssertTrue([[game unansweredQuestionsDisplayText] isEqualToString:@"You have 2 unanswered questions"], @"Wrong text for unanswered questions");

    [question2 answer:@"sarah connor"];
    STAssertTrue([[game unansweredQuestionsDisplayText] isEqualToString:@"You have one unanswered question"], @"Wrong text for unanswered questions");

    [question3 answer:@"another answer"];
    STAssertTrue([[game unansweredQuestionsDisplayText] isEqualToString:@"All questions are answered"], @"Wrong text for unanswered questions");
}

- (void)testComputeScore {
    STAssertNil([game computeScore], @"Expected nil since the game is not finished yet");

    [question1 answer:@"Burbank, LA"];
    [question1 setDifficulty:130];

    [question2 answer:@"Sarah Connor"];
    [question2 setDifficulty:50];

    [question3 answer:@"Wrong answer"];
    [question3 setDifficulty:25];

    [game setFinished:TRUE];

    Score *score = [game computeScore];
    STAssertEquals(3, [score totalQuestions], @"Wrong total questions");
    STAssertEquals(2, [score correctQuestions], @"Wrong correct questions");
    STAssertEquals(180, [score points], @"Wrong points");

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyyyy"];
    NSString *expectedDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *actualDate = [dateFormatter stringFromDate:[score date]];

    [dateFormatter release];

    STAssertTrue([expectedDate isEqualToString:actualDate], @"Wrong score date");
}

- (void)testComputeScoreAllCorrect {
    [question1 answer:@"Burbank, LA"];
    [question1 setDifficulty:130];

    [question2 answer:@"Sarah Connor"];
    [question2 setDifficulty:50];

    [question3 answer:@"The soggy bottom boys"];
    [question3 setDifficulty:25];

    [game setFinished:TRUE];

    Score *score = [game computeScore];
    STAssertEquals(3, [score totalQuestions], @"Wrong total questions");
    STAssertEquals(3, [score correctQuestions], @"Wrong correct questions");
    STAssertEquals(410, [score points], @"Score is (score * 2) when all questions are correct");
}

- (void)testComputeScoreZeroMistakes {
    [question1 answer:@"Burbank, LA"];
    [question1 setDifficulty:130];

    [question2 answer:@"Sarah Connor"];
    [question2 setDifficulty:50];

    [question3 answer:@"The soggy bottom boys"];
    [question3 setDifficulty:25];

    [game setFinished:TRUE];

    Score *score = [game computeScore];
    STAssertTrue([score perfect], @"Game is finished and with zero mistakes");
}

- (void)testComputeScoreOneMistakes {
    [question1 answer:@"Hollywood, LA"];
    [question1 answer:@"Burbank, LA"];
    [question1 setDifficulty:130];

    [question2 answer:@"Sarah Connor"];
    [question2 setDifficulty:50];

    [question3 answer:@"The soggy bottom boys"];
    [question3 setDifficulty:25];

    [game setFinished:TRUE];

    Score *score = [game computeScore];
    STAssertFalse([score perfect], @"Game is finished and with one mistakes");
}

- (void)testIsPerfectNoQuestionsAnswered {
    STAssertFalse([game isPerfect], @"Expected not perfect");
}

- (void)testIsPerfectWhenFinished {
    [question1 answer:@"Burbank, LA"];
    [question2 answer:@"Sarah Connor"];
    [question3 answer:@"The soggy bottom boys"];

    STAssertFalse([game isPerfect], @"Game is not marked as finished");
}

- (void)testIsPerfect {
    [question1 answer:@"Burbank, LA"];
    [question2 answer:@"Sarah Connor"];
    [question3 answer:@"The soggy bottom boys"];
    [game setFinished:YES];

    STAssertTrue([game isPerfect], @"Game is finished and with zero mistakes");
}

- (void)testIsPerfectOnlyWhenZeroMistakes {
    [question1 answer:@"Burbank, LA"];
    [question2 answer:@"Sarah?"];
    [question2 answer:@"Sarah Connor"];
    [question3 answer:@"The soggy bottom boys"];
    [game setFinished:YES];

    STAssertFalse([game isPerfect], @"One question was answered wrong");
}

- (void)testTotalLives {
    STAssertEquals(NumberOfLivesStraight10, [game totalLives], @"Wrong total lives");
}

- (void)testTotalLivesWhenSuddenDeath {
    NSArray *questions = [[[NSArray alloc] initWithObjects:question1, question2, question3, nil] autorelease];
    Game *suddenDeathGame = [[[Game alloc] initWithQuestions:questions gameMode:SUDDEN_DEATH] autorelease];
    STAssertEquals(NumberOfLivesSuddenDeath, [suddenDeathGame totalLives], @"Wrong total lives");
}

- (void)testTotalLivesWhenBeatTheClock {
    NSArray *questions = [[[NSArray alloc] initWithObjects:question1, question2, question3, nil] autorelease];
    Game *beatTheClockGame = [[[Game alloc] initWithQuestions:questions gameMode:BEAT_THE_CLOCK] autorelease];
    STAssertEquals(NumberOfLivesBeatTheClock, [beatTheClockGame totalLives], @"Wrong total lives");
}

- (void)testDecreaseLivesRemaining {
    STAssertEquals(NumberOfLivesStraight10, [game remainingLives], @"Expected all lives remaining");
    [game decreaseLivesRemaining];
    STAssertEquals(NumberOfLivesStraight10 - 1, [game remainingLives], @"Expected num lives to decrease");
    [game decreaseLivesRemaining];
    STAssertEquals(NumberOfLivesStraight10 - 2, [game remainingLives], @"Expected num lives to decrease");
}

- (void)testDecreaseLivesRemainingWhenSuddenDeath {
    NSArray *questions = [[[NSArray alloc] initWithObjects:question1, question2, question3, nil] autorelease];
    Game *suddenDeathGame = [[[Game alloc] initWithQuestions:questions gameMode:SUDDEN_DEATH] autorelease];
    STAssertEquals(NumberOfLivesSuddenDeath, [suddenDeathGame remainingLives], @"Expected all lives remaining");
    [suddenDeathGame decreaseLivesRemaining];
    STAssertEquals(0, [suddenDeathGame remainingLives], @"Expected no more lives");
}

- (void)testDecreaseLivesRemainingWhenBeatTheClock {
    NSArray *questions = [[[NSArray alloc] initWithObjects:question1, question2, question3, nil] autorelease];
    Game *beatTheClockGame = [[[Game alloc] initWithQuestions:questions gameMode:BEAT_THE_CLOCK] autorelease];
    STAssertEquals(NumberOfLivesBeatTheClock, [beatTheClockGame remainingLives], @"Expected all lives remaining");
    [beatTheClockGame decreaseLivesRemaining];
    STAssertEquals(NumberOfLivesBeatTheClock - 1, [beatTheClockGame remainingLives], @"Expected more lives remaining");
}


@end
