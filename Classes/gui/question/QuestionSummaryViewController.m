//
//  QuestionSummaryViewController.m
//  CloseUp
//
//  Created by Federico Lopez Laborda on 12/18/11.
//  Copyright (c) 2011 FLL. All rights reserved.
//

#import "QuestionSummaryViewController.h"

@implementation QuestionSummaryViewController

@synthesize question;
@synthesize questionLabel;
@synthesize correctAnswerTitleLabel;
@synthesize correctAnswer;
@synthesize userAnswer;
@synthesize pointsImage;
@synthesize resultImage;
@synthesize thumbnail;

- (id)initWithQuestion:(Question *)theQuestion {
    self = [super initWithNibName:@"QuestionSummaryView" bundle:[NSBundle mainBundle]];
    if (self) {
        [self setQuestion:theQuestion];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *thumbnailImage = [UIImage imageNamed:[question thumbImageName]];
    [thumbnail setImage:thumbnailImage];

    [questionLabel setText:[question questionWithIndexForDisplay]];
    [userAnswer setText:[question userAnswerForDisplay]];

    if ([question isCorrect]) {
        [pointsImage setHidden:FALSE];
        [pointsImage setImage:[UIImage imageNamed:[question pointsImageName]]];
        [resultImage setImage:[UIImage imageNamed:@"correct.png"]];
        [correctAnswer setHidden:TRUE];
        [correctAnswerTitleLabel setHidden:TRUE];
    } else {
        [pointsImage setHidden:TRUE];
        [resultImage setImage:[UIImage imageNamed:@"wrong.png"]];
        [correctAnswer setHidden:FALSE];
        [correctAnswerTitleLabel setHidden:FALSE];
        [correctAnswer setText:[question correctAnswerForDisplay]];
    }
}

- (void)dealloc {
    [questionLabel release];
    [correctAnswerTitleLabel release];
    [correctAnswer release];
    [userAnswer release];
    [pointsImage release];
    [resultImage release];
    [thumbnail release];
    [question release];
    [super dealloc];
}

@end
