//
//  Achievement.m
//  CloseUp
//
//  Created by Federico Lopez Laborda on 3/22/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import "Achievement.h"

@implementation Achievement

@synthesize achievementType;

+ (id)objectWithAchievementType:(AchievementType)anAchievementType {
    Achievement *achievement = [[[Achievement alloc] init] autorelease];
    [achievement setAchievementType:anAchievementType];
    return achievement;
}


+ (NSString *)badgeImageNameForType:(AchievementType)formatType {
    NSString *result = nil;
    switch (formatType) {
        case THREE_IN_A_ROW:
            result = @"badge-three-in-a-row.png";
            break;
        case PERFECT:
            result = @"badge-perfect.png";
            break;
        case GAME_COMPLETED:
            result = @"badge-game-completed.png";
            break;
        case ON_FIRE:
            result = @"badge-on-fire.png";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected AchievementType."];
    }
    return result;
}

+ (NSString *)gameCenterIdForType:(AchievementType)formatType {
    NSString *result = nil;
    switch (formatType) {
        case THREE_IN_A_ROW:
            result = @"CloseUp_V2_ThreeInARow";
            break;
        case PERFECT:
            result = @"CloseUp_V2_Perfect";
            break;
        case GAME_COMPLETED:
            result = @"CloseUp_V2_GameCompleted";
            break;
        case ON_FIRE:
            result = @"CloseUp_V2_OnFire";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected AchievementType."];
    }
    return result;
}


@end
