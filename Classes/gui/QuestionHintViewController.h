//
//  QuestionHintViewController.h
//  CloseUp
//
//  Created by Fede on 30/06/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@class QuestionHintViewController;

@protocol QuestionHintViewControllerDelegate <NSObject>
- (void)questionHintAnimationEnded;
@end

@interface QuestionHintViewController : UIViewController {
    Question *question;
    UIImageView *questionIndexTitle;
    id <QuestionHintViewControllerDelegate> delegate;
    NSString *questionTitleImage;
}

@property(nonatomic, retain) Question *question;
@property(nonatomic, retain) IBOutlet UIImageView *questionIndexTitle;
@property(nonatomic, assign) id <QuestionHintViewControllerDelegate> delegate;

- (id)initWithQuestion:(Question *)theQuestion;

- (void)animateQuestionHint;

- (void)hideQuestionHintStartAnimation:(NSTimer *)timer;

@end
