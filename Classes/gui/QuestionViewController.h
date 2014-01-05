//
//  QuestionViewController.h
//  CloseUp
//
//  Created by Fede on 27/01/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionHintViewController.h"
#import "Question.h"
#import "QuestionAnsweredEffectsViewController.h"
#import "QuestionViewController.h"
#import "ProgressViewController.h"

@protocol QuestionViewControllerDelegate <NSObject>
- (void)pauseGame:(Question *)question;

- (void)questionAnswered:(Question *)question;
@end

@interface QuestionViewController : UIViewController <QuestionHintViewControllerDelegate, QuestionAnsweredEffectsViewControllerDelegate> {

    NSMutableArray *animatedSubViews;
    UIImageView *backgroundImageFrameView;
    int animatedSubViewsInitialSize;
    UIImageView *circleView;

}

@property(nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic, retain) UILabel *questionLabel;
@property(nonatomic, retain) IBOutlet UIImageView *questionLabelImageView;
@property(nonatomic, retain) UIImageView *questionFrame;
@property(nonatomic, retain) Question *question;
@property(nonatomic, retain) ProgressViewController *progressViewController;
@property(nonatomic, retain) IBOutlet QuestionHintViewController *questionHintVC;
@property(nonatomic, retain) id <QuestionViewControllerDelegate> delegate;

- (id)initWithQuestion:(Question *)theQuestion;

- (IBAction)answer:(id)sender;

- (void)startQuestionOutcomeAnimation:(QuestionOutcome)outcome;

- (void)decorateWithOutcomeTag:(UIButton *)button answered:(NSString *)answered;

- (NSMutableArray *)subViewElementsToAnimate;

- (void)animateQuestionHint;

- (void)animateQuestionLabel;

- (void)animateSubViews;

- (void)prepareViewsForQuestionTitleAnimation;

- (void)resumeTimeIndicator;

- (void)timesUp;

@end
