//
// Created by fede on 11/16/11.
//
// Copyright Kowari SARL 2011. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Question.h"

@protocol QuestionAnsweredEffectsViewControllerDelegate <NSObject>
- (void)questionAnsweredEffectsAnimationEnded:(id)viewController;
@end

typedef enum QuestionOutcome {
    kIsCorrect,
    kIsWrong,
    kTimedUp
} QuestionOutcome;

@interface QuestionAnsweredEffectsViewController : UIViewController {

@private
    QuestionOutcome kQuestionOutcome;
    UIImageView *outcomeView;
}

@property(nonatomic, assign) id <QuestionAnsweredEffectsViewControllerDelegate> delegate;

- (id)initWithOutcome:(QuestionOutcome)questionOutcome;

- (void)animate;

@end