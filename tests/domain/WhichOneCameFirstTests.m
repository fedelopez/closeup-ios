//
//  WhichOneCameFirstTests.m
//  CloseUp
//
//  Created by Fede on 10/01/11.
//  Copyright 2011 FLL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "WhichOneCameFirst.h"
#import "WhichOneCameFirstViewController.h"

@interface WhichOneCameFirstTests : SenTestCase {
    WhichOneCameFirst *question;
}
@end

@implementation WhichOneCameFirstTests

- (void)setUp {
    question = [[WhichOneCameFirst alloc] init];
    [question setCorrectAnswer:@"Blade Runner"];

    [question setMovieTitle1:@"Blade Runner"];
    [question setMovieTitleYear1:1982];

    [question setMovieTitle2:@"Terminator 2"];
    [question setMovieTitleYear2:1984];
}

- (void)tearDown {
    [question release];
}

- (void)testCorrectAnswerWithYear {
    STAssertEqualObjects(@"Blade Runner (1982)", [question correctAnswerWithYear], @"Wrong answer title");
}

- (void)testWrongAnswerWithYear {
    STAssertEqualObjects(@"Terminator 2 (1984)", [question wrongAnswerWithYear], @"Wrong answer title");
}

- (void)testUserAnswerForDisplayForMovieTitle2 {
    [question setCorrectAnswer:@"Terminator 2"];
    [question answer:@"Terminator 2"];
    STAssertEqualObjects(@"Terminator 2 (1984)", [question userAnswerForDisplay], @"Wrong user answer for display");
}

- (void)testUserAnswerForDisplay {
    [question answer:@"Blade Runner"];
    STAssertEqualObjects(@"Blade Runner (1982)", [question userAnswerForDisplay], @"Wrong user answer for display");
}

- (void)testCorrectAnswerForDisplayWhenIncorrect {
    [question answer:@"Terminator 2"];
    STAssertEqualObjects(@"Blade Runner (1982)", [question correctAnswerForDisplay], @"Wrong correct answer for display");
}

- (void)testCorrectAnswerForDisplayWhenCorrect {
    [question answer:@"Blade Runner"];
    STAssertEqualObjects(@"", [question correctAnswerForDisplay], @"Wrong correct answer for display");
}

- (void)testUserAnswerForDisplayNotAnswered {
    WhichOneCameFirst *whichOne = [[WhichOneCameFirst alloc] init];
    STAssertEqualObjects(@"Not answered", [whichOne userAnswerForDisplay], @"Wrong user answer for display");
    [whichOne release];
}

- (void)testCorrectAnswerForDisplayNotAnswered {
    STAssertEqualObjects(@"Blade Runner (1982)", [question correctAnswerForDisplay], @"Wrong correct answer for display");
}

- (void)testToViewController {
    STAssertTrue([[question toViewController] isKindOfClass:[WhichOneCameFirstViewController class]], @"Wrong view controller.");
}

@end
