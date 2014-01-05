//
//  QuestionTests.m
//  CloseUp
//
//  Created by Fede on 25/03/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "Question.h"

@interface QuestionTests : SenTestCase {
    Question *question;
}
@end

@implementation QuestionTests

- (void)setUp {
    question = [[Question alloc] init];
    [question setQuestion:@"Where are the Warner Bros studios?"];
    [question setCorrectAnswer:@"Burbank, LA"];
    [question setDisplayIndex:8];
}

- (void)tearDown {
    [question release];
}

- (void)testIsAnswered {
    STAssertFalse([question isAnswered], @"Expected unanswered question");

    [question answer:@"hmmm, I think I don't know this one..."];
    STAssertTrue([question isAnswered], @"Expected answered question");
}

- (void)testIsNotCorrect {
    [question answer:@"Burbanko"];
    STAssertFalse([question isCorrect], @"Expected wrong answer for question");
}

- (void)testIsCorrect {
    [question answer:@"Burbank, LA"];
    STAssertTrue([question isCorrect], @"Expected correct answer for question");
}

- (void)testIsCorrectCaseInsensitive {
    [question answer:@"burbank, LA"];
    STAssertTrue([question isCorrect], @"Expected correct answer for question");
}

- (void)testThumbImageName {
    [question setImageName:@"question1.jpg"];
    STAssertTrue([[question thumbImageName] isEqualToString:@"thumbquestion1.png"], @"Wrong thumb image name");

    [question setImageName:@"changedtogifquestion1.gif"];
    STAssertTrue([[question thumbImageName] isEqualToString:@"thumbchangedtogifquestion1.gif"], @"Wrong thumb image name");
}

- (void)testPointsImageName {
    [question setDifficulty:100];
    STAssertEqualObjects(@"points100.png", [question pointsImageName], @"Wrong points image name");

    [question setDifficulty:320];
    STAssertEqualObjects(@"points320.png", [question pointsImageName], @"Wrong points image name");
}


- (void)testUserAnswers {
    NSUInteger expectedAnswers = 0;
    STAssertEquals(expectedAnswers, [[question userAnswers] count], @"Expected text empty user answers");

    [question answer:@"The Never Ending Story"];
    expectedAnswers++;
    STAssertEquals(expectedAnswers, [[question userAnswers] count], @"Expected one answered question");
    STAssertEqualObjects(@"The Never Ending Story", [[question userAnswers] lastObject], @"Expected one answered question");
}

- (void)testCorrectAnswerForDisplay {
    STAssertEqualObjects(@"Burbank, LA", [question correctAnswerForDisplay], @"Wrong correct answer for display text");
}

- (void)testQuestionWithIndexForDisplay {
    STAssertEqualObjects(@"9 - Where are the Warner Bros studios?", [question questionWithIndexForDisplay], @"Expected with index");
}


- (void)testNumberOfTries {
    STAssertEquals(1, [question numberOfTries], @"Wrong number of tries");

    [question answer:@"Monterey Hills"];
    STAssertEquals(0, [question numberOfTries], @"Expected number of tries to decrement");
    [question answer:@"Echo Park"];
    STAssertEquals(0, [question numberOfTries], @"Expected number of tries not negative");
}

- (void)testIsCorrectNoErrors {
    STAssertFalse([question isCorrectNoErrors], @"Expected not correct yet");

    [question answer:@"Monterey Hills"];
    STAssertFalse([question isCorrectNoErrors], @"Expected not correct yet");
    [question answer:@"Echo Park"];
    STAssertFalse([question isCorrectNoErrors], @"Expected not correct yet");
}

- (void)testIsCorrectNoErrorsWhenAnswerCorrect {
    STAssertFalse([question isCorrectNoErrors], @"Expected not correct yet");

    [question answer:@"Burbank, LA"];
    STAssertTrue([question isCorrectNoErrors], @"Expected correct yet");
}

- (void)testIsCorrectNoErrorsWhenOneIncorrectAnswer {
    [question answer:@"Hollywood, LA"];
    STAssertFalse([question isCorrectNoErrors], @"Expected not correct yet");
    [question answer:@"Burbank, LA"];
    STAssertFalse([question isCorrectNoErrors], @"Expected not correct yet");
}

- (void)testUserAnswerForDisplay {
    STAssertEqualObjects(@"Not answered", [question userAnswerForDisplay], @"Expected text for empty answer");

    [question answer:@"The Never Ending Story"];
    STAssertEqualObjects(@"The Never Ending Story", [question userAnswerForDisplay], @"Expected text for answered question");
}

- (void)testClearLastAnswer {
    [question answer:@"The Never Ending Story"];
    [question clearLastAnswer];
    STAssertFalse([question isAnswered], @"Expected cleared");
}

- (void)testClearLastAnswerMultipleTries {
    [question setNumberOfTries:2];
    [question answer:@"The Never Ending Story"];
    [question answer:@"Another wrong answer"];
    STAssertEquals(0, [question numberOfTries], @"Number of tries not decreased");

    [question clearLastAnswer];

    STAssertTrue([question isAnswered], @"Expected last answer cleared");
    STAssertEquals(@"The Never Ending Story", [question userAnswerForDisplay], @"Wrong user answer");
    STAssertEquals(1, [question numberOfTries], @"Number of tries not reset");
}

- (void)testClearLastAnswerWhenLastIsCorrect {
    [question setNumberOfTries:2];
    [question answer:@"The Never Ending Story"];
    [question answer:@"Burbank, LA"];
    STAssertEquals(1, [question numberOfTries], @"Number of tries not decreased");

    [question clearLastAnswer];

    STAssertTrue([question isAnswered], @"Expected last answer cleared");
    STAssertEquals(@"The Never Ending Story", [question userAnswerForDisplay], @"Wrong user answer");
    STAssertEquals(1, [question numberOfTries], @"Number of tries not reset");
}

- (void)testInitialNumberOfTries {
    STAssertEquals(1, [question initialNumberOfTries], @"Wrong initialNumberOfTries");
}

@end
