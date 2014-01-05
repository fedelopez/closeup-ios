//
//  BadgeViewController.m
//  CloseUp
//
//  Created by Federico Lopez Laborda on 9/1/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import "BadgeViewController.h"
#import "Achievement.h"

static int const BADGE_IMAGE_WIDTH = 100;
static int const BADGE_IMAGE_HEIGHT = 100;
static int const MARGIN = 4;

@implementation BadgeViewController

@synthesize achievements;
@synthesize scroll;

- (id)initWithAchievements:(NSArray *)achievementsEarned {
    self = [super init];
    if (self) {
        achievements = [[NSArray alloc] initWithArray:achievementsEarned];
    }
    return self;
}

- (void)loadView {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGRect frame = CGRectMake(0, 200, screenWidth, BADGE_IMAGE_HEIGHT);

    self.view = [[UIView alloc] initWithFrame:frame];

    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [scroll setContentSize:CGSizeMake([self screenWidth], BADGE_IMAGE_HEIGHT)];
    [scroll setBackgroundColor:[UIColor clearColor]];
    [scroll setScrollEnabled:YES];
    [scroll setPagingEnabled:YES];
    [scroll setScrollsToTop:NO];
    [scroll setShowsHorizontalScrollIndicator:NO];
    [scroll setShowsVerticalScrollIndicator:NO];

    [self.view addSubview:scroll];

    [self initImages];
}

- (void)initImages {

    CGFloat screenRatio = [self screenWidth] / [achievements count];
    CGFloat x = (screenRatio / 2) - (BADGE_IMAGE_WIDTH / 2);

    for (int i = 0; i < [achievements count]; i++) {
        Achievement *achievement = [achievements objectAtIndex:(NSUInteger) i];
        NSString *name = [Achievement badgeImageNameForType:[achievement achievementType]];
        UIImage *image = [UIImage imageNamed:name];
        CGRect bounds = CGRectMake(x, 0, BADGE_IMAGE_WIDTH, BADGE_IMAGE_HEIGHT);
        UIImageView *badgeView = [[[UIImageView alloc] initWithImage:image] autorelease];
        [badgeView setFrame:bounds];
        [scroll addSubview:badgeView];
        x += screenRatio;
    }

}

- (CGFloat)screenWidth {
    CGFloat visibleWidth = [[UIScreen mainScreen] bounds].size.width;
    int offset = [achievements count] * MARGIN;
    CGFloat size = ([achievements count] * BADGE_IMAGE_WIDTH) + offset;
    return MAX(size, visibleWidth);
}

- (void)dealloc {
    [achievements release];
    [scroll release];
    [super dealloc];
}


@end
