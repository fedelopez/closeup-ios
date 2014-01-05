//
//  AchievementTests.m
//  CloseUp
//
//  Created by Federico Lopez Laborda on 9/2/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

#import "Achievement.h"

@interface AchievementTests : SenTestCase {
    Achievement *achievement;
}
@end

@implementation AchievementTests

- (void)setUp {
    achievement = [[Achievement alloc] init];
}

- (void)tearDown {
    [achievement release];
}

- (void)testBadgeImageNameWhenGameCompleted {
    NSString *actual = [Achievement badgeImageNameForType:GAME_COMPLETED];
    STAssertEqualObjects(@"badge-game-completed.png", actual, @"Wrong image name produced");
}

- (void)testBadgeImageNameWhenThreeInARow {
    NSString *actual = [Achievement badgeImageNameForType:THREE_IN_A_ROW];
    STAssertEqualObjects(@"badge-three-in-a-row.png", actual, @"Wrong image name produced");
}

- (void)testBadgeImageNameWhenPerfect {
    NSString *actual = [Achievement badgeImageNameForType:PERFECT];
    STAssertEqualObjects(@"badge-perfect.png", actual, @"Wrong image name produced");
}

- (void)testBadgeImageNameWhenOnFire {
    NSString *actual = [Achievement badgeImageNameForType:ON_FIRE];
    STAssertEqualObjects(@"badge-on-fire.png", actual, @"Wrong image name produced");
}

- (void)testGameCenterIdWhenGameCompleted {
    NSString *actual = [Achievement gameCenterIdForType:GAME_COMPLETED];
    STAssertEqualObjects(@"CloseUp_V2_GameCompleted", actual, @"Wrong game center id");
}

- (void)testGameCenterIdWhenThreeInARow {
    NSString *actual = [Achievement gameCenterIdForType:THREE_IN_A_ROW];
    STAssertEqualObjects(@"CloseUp_V2_ThreeInARow", actual, @"Wrong game center id");
}

- (void)testGameCenterIdWhenPerfect {
    NSString *actual = [Achievement gameCenterIdForType:PERFECT];
    STAssertEqualObjects(@"CloseUp_V2_Perfect", actual, @"Wrong game center id");
}

- (void)testGameCenterIdWhenOnFire {
    NSString *actual = [Achievement gameCenterIdForType:ON_FIRE];
    STAssertEqualObjects(@"CloseUp_V2_OnFire", actual, @"Wrong game center id");
}

@end
