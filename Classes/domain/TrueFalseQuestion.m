//
//  TrueFalseQuestion.m
//  CloseUp
//
//  Created by Fede on 10/04/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "TrueFalseQuestion.h"
#import "TrueFalseViewController.h"

@implementation TrueFalseQuestion

@synthesize correctAnswerWhenFalse;

- (NSString *)correctAnswerForDisplay {
    if ([self isCorrect]) {
        return @"";
    }
    if ([[self correctAnswer] boolValue] == FALSE) {
        return [self correctAnswerWhenFalse];
    } else {
        return [[self correctAnswer] capitalizedString];
    }
}

- (NSString *)userAnswerForDisplay {
    if (![self isAnswered]) return nil;
    return [[[super userAnswers] lastObject] capitalizedString];
}

- (QuestionViewController *)toViewController {
    QuestionViewController *viewController = [[[TrueFalseViewController alloc] initWithQuestion:self] autorelease];
    return viewController;
}


@end
