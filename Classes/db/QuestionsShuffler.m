//
//  QuestionsShuffler.m
//  CloseUp
//
//  Created by Fede on 24/05/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "QuestionsShuffler.h"


@implementation QuestionsShuffler

+ (NSArray *)shuffle:(NSArray *)questions inBetweeners:(NSArray *)inBetweeners {
    NSArray *questionsSorted = [self sortedByDifficulty:questions];
    NSUInteger totalQuestions = [questions count] + [inBetweeners count];
    NSUInteger questionsOrderedIndex = 0;
    NSUInteger inBetweenersIndex = 0;
    NSMutableArray *gameQuestions = [[NSMutableArray alloc] initWithCapacity:totalQuestions];
    for (int i = 0; i < totalQuestions; i++) {
        Question *currentQuestion;
        if ((i + 1) % 5 == 0) {
            currentQuestion = [inBetweeners objectAtIndex:inBetweenersIndex++];
        } else {
            currentQuestion = [questionsSorted objectAtIndex:questionsOrderedIndex++];
        }
        [gameQuestions addObject:currentQuestion];
        [currentQuestion setDisplayIndex:i];
    }
    return gameQuestions;
}

+ (NSArray *)sortedByDifficulty:(NSArray *)questions {
    NSComparisonResult (^comparator)(id, id) = ^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 difficulty] > [obj2 difficulty]) {
            return (NSComparisonResult) NSOrderedDescending;
        }
        if ([obj1 difficulty] < [obj2 difficulty]) {
            return (NSComparisonResult) NSOrderedAscending;
        }
        return (NSComparisonResult) NSOrderedSame;
    };
    return [questions sortedArrayUsingComparator:comparator];
}

@end
