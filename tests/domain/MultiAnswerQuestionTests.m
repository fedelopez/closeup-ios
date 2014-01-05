//
//  Created by fede on 11/19/11.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "MultiAnswerQuestion.h"
#import "MultiAnswerViewController.h"

@interface MultiAnswerQuestionTests : SenTestCase {
    MultiAnswerQuestion *question;
}
@end

@implementation MultiAnswerQuestionTests

- (void)setUp {
    question = [[MultiAnswerQuestion alloc] init];
    [question setQuestion:@"Where are the Warner Bros studios?"];
    [question setCorrectAnswer:@"Burbank, LA"];
    [question setDisplayIndex:8];
}

- (void)tearDown {
    [question release];
}

- (void)testUserAnswers {
    NSUInteger expectedAnswers = 1;
    [question answer:@"Monterey Hills"];
    STAssertEquals(expectedAnswers, [[question userAnswers] count], @"Expected one answered question");
    STAssertEqualObjects(@"Monterey Hills", [[question userAnswers] lastObject], @"Expected one answered question");

    expectedAnswers++;
    [question answer:@"Echo Park"];
    STAssertEquals(expectedAnswers, [[question userAnswers] count], @"Expected two answered questions");
    STAssertEqualObjects(@"Echo Park", [[question userAnswers] lastObject], @"Expected two answered questions");

    expectedAnswers++;
    [question answer:@"Monterey Hills"];
    STAssertEquals(expectedAnswers, [[question userAnswers] count], @"Expected three answered questions");
    STAssertEqualObjects(@"Monterey Hills", [[question userAnswers] lastObject], @"Expected three answered question");
}

- (void)testNumberOfTries {
    STAssertEquals(3, [question numberOfTries], @"Wrong number of tries");

    [question answer:@"Monterey Hills"];
    STAssertEquals(2, [question numberOfTries], @"Expected number of tries to decrement");
    [question answer:@"Echo Park"];
    STAssertEquals(1, [question numberOfTries], @"Expected number of tries to decrement");
    [question answer:@"Hollywood Hills"];
    STAssertEquals(0, [question numberOfTries], @"Expected number of tries to decrement");
    [question answer:@"Hollywood Hills"];
    STAssertEquals(0, [question numberOfTries], @"Expected number of tries not negative");
}

- (void)testToViewController {
    STAssertTrue([[question toViewController] isKindOfClass:[MultiAnswerViewController class]], @"Wrong view controller.");
}

- (void)testInitialNumberOfTries {
    STAssertEquals(3, [question initialNumberOfTries], @"Wrong initialNumberOfTries");
}

@end