//
//  ScoreCellDecoratorTests.m
//  CloseUp
//
//  Created by Fede on 5/06/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>

#import "Score.h"
#import "ScoreCellDecorator.h"

@interface ScoreCellDecoratorTests : SenTestCase {
	Score *score;
	UILabel *label;
	ScoreCellDecorator *cellDecorator;
}
@end

@implementation ScoreCellDecoratorTests

- (void) setUp {
	score = [[Score alloc] init];
	[score setDate:[NSDate date]];
	[score setPoints:345];
	[score setTotalQuestions:10];
	[score setCorrectQuestions:6];	

	cellDecorator = [[ScoreCellDecorator alloc] initWithScore:score index:3];
}

- (void) tearDown {
	[cellDecorator release];
}

- (void) testTextForTotalLabel {
	STAssertEqualObjects(@"(6/10)", [cellDecorator textForTotalLabel], @"Wrong text");
}

- (void) testTextForPointsLabel {
	STAssertEqualObjects(@"345 points", [cellDecorator textForPointsLabel], @"Wrong text");
}

- (void) testTextForDateLabelToday {
	STAssertEqualObjects(@"Today", [cellDecorator textForDateLabel], @"Wrong text");
}

- (void) testTextForDateLabelYesterday {
	NSDate *today = [NSDate date];
		
	NSDateComponents *comps = [[NSDateComponents alloc] init];	
	[comps setDay:-1];
	
	NSCalendar * cal = [NSCalendar currentCalendar]; 
	NSDate *yesterday = [cal dateByAddingComponents:comps toDate:today  options:0];
	
	[score setDate:yesterday];
	STAssertEqualObjects(@"Yesterday", [cellDecorator textForDateLabel], @"Wrong text");
}

- (void) testTextForDateLabelOther {
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"d MMM yy"];
	NSDate * anotherDay = [dateFormatter dateFromString:@"3 Mar 09"];
	
	[score setDate:anotherDay];
	STAssertEqualObjects(@"3 Mar 09", [cellDecorator textForDateLabel], @"Wrong text");
}


@end
