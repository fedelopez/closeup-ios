//
//  FacebookStoryComposer.m
//  CloseUp
//
//  Created by Fede on 17/07/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "TwitterStoryComposer.h"

NSString *const TwitterAddress = @"@closeuptheapp";

@implementation TwitterStoryComposer

@synthesize score;

- (id)initWithScore:(Score *)theScore {
    self = [super init];
    [self setScore:theScore];
    return self;
}

- (NSString *)templateStory {
    return [NSString stringWithFormat:@"My CloseUp score: %d points! %@", [score points], TwitterAddress];
}

- (NSString *)templateStoryForPerfect {
    return [NSString stringWithFormat:@"My CloseUp score: %d points and all questions correctly answered! %@", [score points], TwitterAddress];
}

- (NSString *)templateStoryForZeroPoints {
    return [NSString stringWithFormat:@"My CloseUp score: no points today, but I'll be back!! %@", TwitterAddress];
}

- (NSString *)compose {
    if ([score perfect]) {
        return [self templateStoryForPerfect];
    } else if ([score correctQuestions] == 0) {
        return [self templateStoryForZeroPoints];
    } else {
        return [self templateStory];
    }
}


- (void)dealloc {
    [score release];
    [super dealloc];
}

@end
