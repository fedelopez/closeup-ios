//
//  ScoreCellDecorator.m
//  CloseUp
//
//  Created by Fede on 5/06/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "ScoreCellDecorator.h"


@implementation ScoreCellDecorator

@synthesize score, index, dateFormatter;

- (id) initWithScore:(Score *) theScore index:(int) scoreIndex {
	if (self = [super init]) {
		[self setScore:theScore];
		index = scoreIndex;
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"d MMM yy"];
	}
	return self;
}

- (NSString *) textForTotalLabel {
	NSString * pointsString = [[@"(" stringByAppendingFormat:@"%d", score.correctQuestions] stringByAppendingString:@"/"];
	pointsString = [pointsString stringByAppendingFormat:@"%d", score.totalQuestions];
	pointsString = [pointsString stringByAppendingString:@")"];
	return pointsString;
}

- (NSString *) textForPointsLabel {
	NSString * pointsString = [[@"" stringByAppendingFormat:@"%d", score.points] stringByAppendingString:@" points"];
	return pointsString;
}

- (NSString *) textForDateLabel {
	NSDate * todayDate = [NSDate date];
	NSString * today = [dateFormatter stringFromDate:todayDate];
	
	NSString * scoreDate = [dateFormatter stringFromDate:score.date];
	if ([scoreDate isEqualToString:today]) {
		return @"Today";
	}
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];	
	[comps setDay:-1];
	NSCalendar * cal = [NSCalendar currentCalendar]; 
	NSDate *yesterdayDate = [cal dateByAddingComponents:comps toDate:todayDate  options:0];
	NSString * yesterday = [dateFormatter stringFromDate:yesterdayDate];

	if ([scoreDate isEqualToString:yesterday]) {
		return @"Yesterday";
	}
	
	return scoreDate;
}

- (void)dealloc {
	[score release];
	[super dealloc];
}


@end
