//
//  Achievement.h
//  CloseUp
//
//  Created by Federico Lopez Laborda on 3/22/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum achievement {
    THREE_IN_A_ROW, GAME_COMPLETED, PERFECT, ON_FIRE
} AchievementType;

@interface Achievement : NSObject {
    AchievementType achievementType;
}

@property(nonatomic) AchievementType achievementType;

+ (id)objectWithAchievementType:(AchievementType)anAchievementType;

+ (NSString *)badgeImageNameForType:(AchievementType)achievementType;

+ (NSString *)gameCenterIdForType:(AchievementType)achievementType;

@end
