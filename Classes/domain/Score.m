//
//  Score.m
//  CloseUp
//
//  Created by Fede on 2/06/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "Score.h"


@implementation Score

@synthesize points;
@synthesize perfect;
@synthesize totalQuestions;
@synthesize correctQuestions;
@synthesize date;

- (void)dealloc {
    [date release];
    [super dealloc];
}

@end
