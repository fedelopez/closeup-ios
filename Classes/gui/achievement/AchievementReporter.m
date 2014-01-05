//
//  AchievementReporter.m
//  CloseUp
//
//  Created by Federico Lopez Laborda on 9/5/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "AchievementReporter.h"

@implementation AchievementReporter

+ (void)reportAchievement:(Achievement *)achievement {
    if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
        NSString *identifier = [Achievement gameCenterIdForType:achievement.achievementType];
        GKAchievement *gkAchievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
        [gkAchievement setPercentComplete:100];
        void *handler = ^void(NSError *error) {
            if (error != nil) {
                NSLog(@"Error reporting achievement: %@", [error description]);
            } else {
                NSLog(@"Achievement '%@' reported to Game Center", identifier);
            }
        };
        [gkAchievement reportAchievementWithCompletionHandler:handler];
    } else {
        NSLog(@"Could not report achievement since user is not authenticated.");
    }
}


@end
