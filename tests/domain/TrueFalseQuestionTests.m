//
//  TrueFalseQuestionTests.m
//  CloseUp
//
//  Created by Fede on 25/01/11.
//  Copyright 2011 FLL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "TrueFalseQuestion.h"
#import "TrueFalseViewController.h"

@interface TrueFalseQuestionTests : SenTestCase {
    TrueFalseQuestion *question;
}
@end

@implementation TrueFalseQuestionTests

- (void)setUp {
    question = [[TrueFalseQuestion alloc] init];
}

- (void)tearDown {
    [question release];
}

- (void)testCorrectUserAnswerWhenTrue {
    [question setCorrectAnswer:@"TRUE"];
    [question answer:@"TRUE"];
    STAssertTrue([question isCorrect], @"Expected correct answer");
}

- (void)testCorrectUserAnswerWhenFalse {
    [question setCorrectAnswer:@"FALSE"];
    [question answer:@"FALSE"];
    STAssertTrue([question isCorrect], @"Expected correct answer");
}

- (void)testNotCorrectUserAnswerWhenTrue {
    [question setCorrectAnswer:@"TRUE"];
    [question answer:@"FALSE"];
    STAssertFalse([question isCorrect], @"Expected incorrect answer");
}

- (void)testNotCorrectUserAnswerWhenFalse {
    [question setCorrectAnswer:@"FALSE"];
    [question answer:@"TRUE"];
    STAssertFalse([question isCorrect], @"Expected incorrect answer");
}

- (void)testCorrectAnswerForDisplayWhenFalse {
    [question setCorrectAnswerWhenFalse:@"The director of the film was Kubrick."];
    [question setCorrectAnswer:@"FALSE"];
    [question answer:@"TRUE"];

    STAssertEqualObjects(@"The director of the film was Kubrick.", [question correctAnswerForDisplay], @"Wrong correct answer for display text");
}

- (void)testCorrectAnswerForDisplayWhenTrue {
    [question setCorrectAnswerWhenFalse:@"Does not matter what this method returns."];
    [question setCorrectAnswer:@"TRUE"];
    [question answer:@"FALSE"];

    STAssertEqualObjects(@"True", [question correctAnswerForDisplay], @"Wrong correct answer for display text");
}

- (void)testCorrectAnswerForDisplay {
    [question setCorrectAnswerWhenFalse:@"Does not matter what this method returns."];
    [question setCorrectAnswer:@"TRUE"];
    [question answer:@"TRUE"];

    STAssertEqualObjects(@"", [question correctAnswerForDisplay], @"Expected empty text if correct answer");
}

- (void)testUserAnswerForDisplay {
    [question answer:@"TRUE"];
    STAssertEqualObjects(@"True", [question userAnswerForDisplay], @"Expected capitalized text for user answer");

    [question answer:@"FAlSE"];
    STAssertEqualObjects(@"False", [question userAnswerForDisplay], @"Expected capitalized text for user answer");
}

- (void)testToViewController {
    STAssertTrue([[question toViewController] isKindOfClass:[TrueFalseViewController class]], @"Wrong view controller.");
}


@end
