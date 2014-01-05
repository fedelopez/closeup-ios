//
//  QuestionSummaryViewController.h
//  CloseUp
//
//  Created by Federico Lopez Laborda on 12/18/11.
//  Copyright (c) 2011 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface QuestionSummaryViewController : UIViewController {

    Question *question;

    UILabel *questionLabel;
    UILabel *userAnswer;
    UILabel *correctAnswerTitleLabel;
    UILabel *correctAnswer;

    UIImageView *resultImage;
    UIImageView *pointsImage;
    UIImageView *thumbnail;
}

- (id)initWithQuestion:(Question *)theQuestion;

@property(nonatomic, retain) Question *question;

@property(nonatomic, retain) IBOutlet UILabel *questionLabel;
@property(nonatomic, retain) IBOutlet UILabel *userAnswer;
@property(nonatomic, retain) IBOutlet UILabel *correctAnswer;
@property(nonatomic, retain) IBOutlet UILabel *correctAnswerTitleLabel;

@property(nonatomic, retain) IBOutlet UIImageView *resultImage;
@property(nonatomic, retain) IBOutlet UIImageView *pointsImage;
@property(nonatomic, retain) IBOutlet UIImageView *thumbnail;

@end