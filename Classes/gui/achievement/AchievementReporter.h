//
//  AchievementReporter.h
//  CloseUp
//
//  Created by Federico Lopez Laborda on 9/5/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Achievement.h"

@class Achievement;

@interface AchievementReporter : NSObject

+ (void)reportAchievement:(Achievement *)achievement;

@end
