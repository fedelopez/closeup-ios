//
//  TwitterStoryComposerTests.m
//  CloseUp
//
//  Created by Fede on 17/04/12.
//  Copyright 2012 FLL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "Score.h"
#import "TwitterStoryComposer.h"

@interface TwitterStoryComposerTests : SenTestCase {
    TwitterStoryComposer *composer;
    Score *score;
}
@end


@implementation TwitterStoryComposerTests

- (void)setUp {
    score = [[Score alloc] init];
    [score setDate:[NSDate date]];
    [score setPoints:345];
    [score setTotalQuestions:10];
    [score setCorrectQuestions:6];

    composer = [[TwitterStoryComposer alloc] initWithScore:score];
}

- (void)tearDown {
    [score release];
    [composer release];
}

- (void)testCompose {
    NSString *expected = @"My CloseUp score: 345 points! @closeuptheapp";
    NSString *actual = [composer compose];

    STAssertEqualObjects(expected, actual, @"Wrong tweet.");
    STAssertTrue([expected length] <= 140, @"Tweet exceeds number of legal characters.");
}

- (void)testComposePerfect {
    [score setCorrectQuestions:10];
    [score setPoints:994];
    [score setPerfect:true];

    NSString *expected = @"My CloseUp score: 994 points and all questions correctly answered! @closeuptheapp";
    NSString *actual = [composer compose];

    STAssertEqualObjects(expected, actual, @"Wrong tweet.");
    STAssertTrue([expected length] <= 140, @"Tweet exceeds number of legal characters.");
}

- (void)testComposeForZeroPoints {
    [score setCorrectQuestions:0];

    NSString *expected = @"My CloseUp score: no points today, but I'll be back!! @closeuptheapp";
    NSString *actual = [composer compose];

    STAssertEqualObjects(expected, actual, @"Wrong tweet.");
    STAssertTrue([expected length] <= 140, @"Tweet exceeds number of legal characters.");
}

@end
