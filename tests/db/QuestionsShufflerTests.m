//
//  QuestionsShufflerTests.m
//  CloseUp
//
//  Created by Fede on 24/05/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "QuestionsShuffler.h"

@interface QuestionsShufflerTests : SenTestCase {
    NSMutableArray *questions;
    NSMutableArray *inBetweeners;
    Question *lastQuestion;
}
@end


@implementation QuestionsShufflerTests

- (void)setUp {
    Question *q1 = [[[Question alloc] init] autorelease];
    [q1 setQuestionId:1];
    [q1 setDifficulty:30];
    Question *q2 = [[[Question alloc] init] autorelease];
    [q2 setQuestionId:2];
    [q2 setDifficulty:30];
    Question *q3 = [[[Question alloc] init] autorelease];
    [q3 setQuestionId:3];
    [q3 setDifficulty:10];
    Question *q4 = [[[Question alloc] init] autorelease];
    [q4 setQuestionId:4];
    [q4 setDifficulty:15];
    Question *q5 = [[[Question alloc] init] autorelease];
    [q5 setQuestionId:5];
    [q5 setDifficulty:100];
    Question *q6 = [[[Question alloc] init] autorelease];
    [q6 setQuestionId:7];
    [q6 setDifficulty:100];
    Question *q7 = [[[Question alloc] init] autorelease];
    [q7 setQuestionId:8];
    [q7 setDifficulty:120];
    Question *q8 = [[[Question alloc] init] autorelease];
    [q8 setQuestionId:9];
    [q8 setDifficulty:50];
    Question *q9 = [[[Question alloc] init] autorelease];
    [q9 setQuestionId:5];
    [q9 setDifficulty:99];
    Question *q10 = [[[Question alloc] init] autorelease];
    [q10 setQuestionId:10];
    [q10 setDifficulty:99];

    questions = [[NSMutableArray alloc] initWithCapacity:8];
    [questions addObject:q1];
    [questions addObject:q2];
    [questions addObject:q3];
    [questions addObject:q4];
    [questions addObject:q5];
    [questions addObject:q6];
    [questions addObject:q7];
    [questions addObject:q8];

    inBetweeners = [[NSMutableArray alloc] initWithCapacity:2];
    [inBetweeners addObject:q9];
    [inBetweeners addObject:q10];
}

- (void)tearDown {
    [questions release];
    [inBetweeners release];
}

- (void)testShuffle {
    NSArray *shuffled = [QuestionsShuffler shuffle:questions inBetweeners:inBetweeners];
    for (NSUInteger i = 0; i < [shuffled count]; i++) {
        Question *question = [shuffled objectAtIndex:i];
        if (i == 4 || i == 9) continue;
        [questions removeObject:question];
    }
    STAssertNil([questions lastObject], @"Wrong shuffle for multi answer questions");
    STAssertEquals(5, [[shuffled objectAtIndex:4] questionId], @"Wrong in betweener");
    STAssertEquals(10, [[shuffled objectAtIndex:9] questionId], @"Wrong in betweener");
}

- (void)testShuffleOrdersQuestionsByDifficulty {
    NSArray *shuffled = [QuestionsShuffler shuffle:questions inBetweeners:inBetweeners];
    [self assertOrdered:shuffled indexAt:0 isSmallThanIndexAt:1];
    [self assertOrdered:shuffled indexAt:1 isSmallThanIndexAt:2];
    [self assertOrdered:shuffled indexAt:2 isSmallThanIndexAt:3];
    [self assertOrdered:shuffled indexAt:3 isSmallThanIndexAt:5];
    [self assertOrdered:shuffled indexAt:5 isSmallThanIndexAt:6];
    [self assertOrdered:shuffled indexAt:6 isSmallThanIndexAt:7];
    [self assertOrdered:shuffled indexAt:7 isSmallThanIndexAt:8];
}

- (void)testSetQuestionIndexOnShuffle {
    NSArray *shuffled = [QuestionsShuffler shuffle:questions inBetweeners:inBetweeners];
    for (int i = 0; i < [shuffled count]; i++) {
        Question *question = [shuffled objectAtIndex:i];
        STAssertEquals(i, question.displayIndex, @"Wrong index");
    }
}

- (void)assertOrdered:(NSArray *)shuffled indexAt:(NSUInteger)index1 isSmallThanIndexAt:(NSUInteger)index2 {
    id q1 = [shuffled objectAtIndex:index1];
    id q2 = [shuffled objectAtIndex:index2];
    STAssertTrue([q1 difficulty] <= [q2 difficulty], @"Expected questions ordered by difficulty");
}

@end
