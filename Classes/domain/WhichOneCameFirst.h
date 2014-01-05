//
//  WhichOneCameFirst.h
//  CloseUp
//
//  Created by Fede on 9/01/11.
//  Copyright 2011 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface WhichOneCameFirst : Question {
	NSString *movieTitle1;
	NSString *movieTitle2;

	int movieTitleYear1;
	int movieTitleYear2;

	NSString *movieTitle1ImageName;
	NSString *movieTitle2ImageName;
}

@property (nonatomic, retain) NSString *movieTitle1;
@property (nonatomic, retain) NSString *movieTitle2;

@property (nonatomic) int movieTitleYear1;
@property (nonatomic) int movieTitleYear2;

@property (nonatomic, retain) NSString *movieTitle1ImageName;
@property (nonatomic, retain) NSString *movieTitle2ImageName;

- (NSString *) correctAnswerWithYear;
- (NSString *) wrongAnswerWithYear;

@end
