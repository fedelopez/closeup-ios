//
//  QuestionViewControlerTests.m
//  CloseUp
//
//  Created by Federico Lopez Laborda on 3/15/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Question.h"
#import "QuestionViewController.h"

@interface QuestionViewControllerTests : SenTestCase {
    Question *question;
    QuestionViewController *questionViewController;
}

@end

@implementation QuestionViewControllerTests

- (void)setUp {
    question = [[Question alloc] init];
    questionViewController = [[QuestionViewController alloc] initWithQuestion:question];
}

- (void)tearDown {
    [question release];
    [questionViewController release];
}

@end