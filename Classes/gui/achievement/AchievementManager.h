//
//  Created by fede on 2/1/13.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"
#import "Question.h"
#import "ThreeInARowViewController.h"
#import "Achievement.h"
#import "OnFireViewController.h"

@protocol AchievementManagerDelegate <NSObject>
- (void)achievementAnimationEnded;
@end

@interface AchievementManager : NSObject <ThreeInARowViewControllerDelegate, OnFireViewControllerDelegate> {

    id <AchievementManagerDelegate> delegate;

@private
    int correctQuestionCount;
    int achievementsEarnedForCurrentQuestion;

}

@property(nonatomic, assign) id <AchievementManagerDelegate> delegate;

- (void)trackQuestionAnswered:(Question *)question;

- (BOOL)hasAchievementsToReport;

- (void)reportAchievementsWithAnimationsOnTopOf:(UIView *)visibleQuestion;

- (void)reset;


@end