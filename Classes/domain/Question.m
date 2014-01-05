//
//  Question.m
//  CloseUp
//
//  Created by Fede on 28/02/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "Question.h"
#import "QuestionViewController.h"

@implementation Question

@synthesize questionId;
@synthesize question;
@synthesize correctAnswer;
@synthesize imageName;
@synthesize difficulty;
@synthesize appearedOnScreen;
@synthesize displayIndex;
@synthesize numberOfTries;
@synthesize timedUp;

NSUInteger const NumberOfTries = 1;

- (Question *)init {
    self = [super init];
    if (self) {
        appearedOnScreen = FALSE;
        numberOfTries = [self initialNumberOfTries];
        userAnswers = [[NSMutableArray alloc] initWithCapacity:NumberOfTries];
    }
    return self;
}

- (BOOL)isAnswered {
    return [userAnswers count] > 0;
}

- (BOOL)isCorrect:(NSString *)userAnswer {
    NSComparisonResult result = [correctAnswer localizedCaseInsensitiveCompare:userAnswer];
    return result == NSOrderedSame;
}

- (BOOL)isCorrect {
    return [self isAnswered] && [self isCorrect:[userAnswers lastObject]];
}

- (BOOL)isCorrectNoErrors {
    return [self isCorrect] && [self numberOfTries] >= [self initialNumberOfTries];
}


- (NSArray *)userAnswers {
    return [[userAnswers copy] autorelease];
}

- (NSString *)thumbImageName {
    NSString *imageNamePng = [imageName stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
    return [@"thumb" stringByAppendingString:imageNamePng];
}

- (NSString *)pointsImageName {
    return [@"points" stringByAppendingFormat:@"%d.png", difficulty];;
}

- (void)answer:(NSString *)userAnswer {
    if (numberOfTries == 0) {
        return;
    }
    [userAnswers addObject:userAnswer];
    if (![self isCorrect]) {
        numberOfTries--;
    }
}

- (NSString *)questionWithIndexForDisplay {
    NSString *indexQuestion = [NSString stringWithFormat:@"%d - ", (displayIndex + 1)];
    return [indexQuestion stringByAppendingString:question];
}

- (NSString *)userAnswerForDisplay {
    if ([self isAnswered]) {
        return [[self userAnswers] lastObject];
    }
    return @"Not answered";
}

- (QuestionViewController *)toViewController {
    return nil;
}

- (NSString *)correctAnswerForDisplay {
    return [self correctAnswer];
}

- (void)clearLastAnswer {
    if (userAnswers.lastObject != nil) {
        NSString *lastAnswer = userAnswers.lastObject;
        if (![self isCorrect:lastAnswer]) {
            numberOfTries++;
        }
        [userAnswers removeLastObject];
    }
}

- (int)initialNumberOfTries {
    return NumberOfTries;
}

- (void)dealloc {
    [question release];
    [correctAnswer release];
    [userAnswers release];
    [imageName release];
    [super dealloc];
}

@end
