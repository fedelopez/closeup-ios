//
//  MultiAnswerQuestion.m
//  CloseUp
//
//  Created by Fede on 28/02/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "MultiAnswerQuestion.h"
#import "MultiAnswerViewController.h"


@implementation MultiAnswerQuestion

@synthesize possibleAnswers;

- (QuestionViewController *)toViewController {
    QuestionViewController *viewController = [[[MultiAnswerViewController alloc] initWithQuestion:self] autorelease];
    return viewController;
}

- (int)initialNumberOfTries {
    return 3;
}


- (void)dealloc {
    [possibleAnswers release];
    [super dealloc];
}

@end
