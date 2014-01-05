//
//  WhichOneCameFirst.m
//  CloseUp
//
//  Created by Fede on 9/01/11.
//  Copyright 2011 FLL. All rights reserved.
//

#import "WhichOneCameFirst.h"
#import "WhichOneCameFirstViewController.h"

@implementation WhichOneCameFirst

@synthesize movieTitle1, movieTitle2, movieTitleYear1, movieTitleYear2, movieTitle1ImageName, movieTitle2ImageName;

- (NSString *)correctAnswerWithYear {
    int year = movieTitleYear2;
    if ([movieTitle1 isEqualToString:[self correctAnswer]]) {
        year = movieTitleYear1;
    }
    return [[self correctAnswer] stringByAppendingFormat:@" (%d)", year];
}

- (NSString *)wrongAnswerWithYear {
    NSString *wrongAnswer = movieTitle2;
    int year = movieTitleYear2;
    if ([movieTitle2 isEqualToString:[self correctAnswer]]) {
        wrongAnswer = movieTitle1;
        year = movieTitleYear1;
    }
    return [wrongAnswer stringByAppendingFormat:@" (%d)", year];
}

- (NSString *)userAnswerForDisplay {
    if ([self isAnswered]) {
        if ([self isCorrect]) {
            return [self correctAnswerWithYear];
        } else {
            return [self wrongAnswerWithYear];
        }
    }
    return @"Not answered";
}

- (NSString *)correctAnswerForDisplay {
    if ([self isAnswered] && ![self isCorrect]) {
        return [self correctAnswerWithYear];
    } else if (![self isAnswered]) {
        return [self correctAnswerWithYear];
    }
    return @"";
}

- (QuestionViewController *)toViewController {
    QuestionViewController *viewController = [[[WhichOneCameFirstViewController alloc] initWithQuestion:self] autorelease];
    return viewController;
}

- (void)dealloc {
    [movieTitle1 release];
    [movieTitle2 release];
    [movieTitle1ImageName release];
    [movieTitle2ImageName release];
    [super dealloc];
}

@end
