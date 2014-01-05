//
//  ScoreCellDecorator.h
//  CloseUp
//
//  Created by Fede on 5/06/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Score.h"

@interface ScoreCellDecorator : NSObject {
	Score *score;
	int index;
	NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain) Score *score;
@property (nonatomic) int index;
@property (nonatomic, readonly) NSDateFormatter * dateFormatter;

- (id) initWithScore:(Score *) theScore index:(int) scoreIndex;

- (NSString *) textForDateLabel;
- (NSString *) textForPointsLabel;
- (NSString *) textForTotalLabel;

@end
