//
//  Created by fede on 2/2/13.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//


#import <SenTestingKit/SenTestingKit.h>
#import "Question.h"
#import "AchievementManager.h"

@interface AchievementManagerTests : SenTestCase {
    Question *question;
    AchievementManager *achievementManager;
}
@end

@implementation AchievementManagerTests

- (void)setUp {
    question = [[Question alloc] init];
    [question setQuestion:@"Where are the Warner Bros studios?"];
    [question setCorrectAnswer:@"Burbank, LA"];
    [question setDisplayIndex:8];

    achievementManager = [[AchievementManager alloc] init];
}

- (void)tearDown {
    [question release];
    [achievementManager release];
}

- (void)testTrackQuestionAnsweredWhenThreeInARow {
    STAssertFalse([achievementManager hasAchievementsToReport], @"No achievements yet");

    [question answer:@"Burbank, LA"];

    [achievementManager trackQuestionAnswered:question];
    STAssertFalse([achievementManager hasAchievementsToReport], @"No achievements yet");

    [achievementManager trackQuestionAnswered:question];
    STAssertFalse([achievementManager hasAchievementsToReport], @"No achievements yet");

    [achievementManager trackQuestionAnswered:question];
    STAssertTrue([achievementManager hasAchievementsToReport], @"Expected three in a row");
}

- (void)testTrackQuestionAnsweredWhenIncorrect {
    STAssertFalse([achievementManager hasAchievementsToReport], @"No achievements yet");

    [question answer:@"Hollywood, LA"];
    [achievementManager trackQuestionAnswered:question];
    STAssertFalse([achievementManager hasAchievementsToReport], @"No achievements yet");

    [question answer:@"Sydney, NSW"];
    [achievementManager trackQuestionAnswered:question];
    STAssertFalse([achievementManager hasAchievementsToReport], @"No achievements yet");

    [question answer:@"Burbank, LA"];
    [achievementManager trackQuestionAnswered:question];
    STAssertFalse([achievementManager hasAchievementsToReport], @"No achievements yet");
}

- (void)testTrackQuestionAnsweredResets {
    [question answer:@"Burbank, LA"];

    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    STAssertFalse([achievementManager hasAchievementsToReport], @"Expected reset after achievements got");
}

- (void)testTrackQuestionAnsweredWhenOnFire {
    [question answer:@"Burbank, LA"];

    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    STAssertTrue([achievementManager hasAchievementsToReport], @"Expected on fire");
}

- (void)testTrackQuestionAnsweredWhenTwoConsecutiveThreeInARow {
    [question answer:@"Burbank, LA"];

    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    STAssertTrue([achievementManager hasAchievementsToReport], @"Expected another three in a row");
}

- (void)testReset {
    [question answer:@"Burbank, LA"];

    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    [achievementManager trackQuestionAnswered:question];
    STAssertTrue([achievementManager hasAchievementsToReport], @"Expected another three in a row");
    [achievementManager reset];
    STAssertFalse([achievementManager hasAchievementsToReport], @"Expected reset");
}


@end