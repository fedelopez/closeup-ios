//
//  Created by fede on 2/1/13.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import "AchievementManager.h"
#import "AchievementReporter.h"
#import "GameStore.h"

@implementation AchievementManager

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        correctQuestionCount = 0;
        return self;
    }
    return nil;
}

- (void)trackQuestionAnswered:(Question *)question {
    if ([question isCorrect]) {
        correctQuestionCount++;
    } else {
        correctQuestionCount = 0;
    }
}

- (BOOL)hasAchievementsToReport {
    return [self hasThreeInARow] || [self hasOnFire];
}

- (BOOL)hasThreeInARow {
    return correctQuestionCount > 0 && correctQuestionCount % 3 == 0;
}

- (BOOL)hasOnFire {
    return correctQuestionCount > 0 && correctQuestionCount % 5 == 0;
}

- (void)reportAchievement:(enum achievement)achievementType {
    Game *game = [GameStore getSharedInstance];
    Achievement *achievement = [Achievement objectWithAchievementType:achievementType];
    achievementsEarnedForCurrentQuestion++;
    [game addAchievement:achievement];
    [AchievementReporter reportAchievement:achievement];
}

- (void)reportAchievementsWithAnimationsOnTopOf:(UIView *)visibleQuestion {
    if ([self hasThreeInARow]) {
        [self reportAchievement:THREE_IN_A_ROW];
        ThreeInARowViewController *viewController = [[[ThreeInARowViewController alloc] init] autorelease];
        [viewController setDelegate:self];
        [visibleQuestion addSubview:viewController.view];
    }
    if ([self hasOnFire]) {
        [self reportAchievement:ON_FIRE];
        OnFireViewController *viewController = [[[OnFireViewController alloc] init] autorelease];
        [viewController setDelegate:self];
        [visibleQuestion addSubview:viewController.view];
    }
}

- (void)reset {
    correctQuestionCount = 0;
}


- (void)threeInARowAchievementAnimationEnded {
    [self maybeReportToDelegate];
}

- (void)onFireAnimationEnded {
    [self maybeReportToDelegate];
}

- (void)maybeReportToDelegate {
    achievementsEarnedForCurrentQuestion--;
    if (achievementsEarnedForCurrentQuestion == 0) {
        [delegate achievementAnimationEnded];
    }
}

- (void)dealloc {
    [super dealloc];
}


@end