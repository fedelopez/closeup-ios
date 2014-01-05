//
//  BadgeViewController.h
//  CloseUp
//
//  Created by Federico Lopez Laborda on 9/1/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeViewController : UIViewController {
    UIScrollView *scroll;
    NSArray *achievements;
}

@property(nonatomic, retain) UIScrollView *scroll;
@property(nonatomic, readonly) NSArray *achievements;

- (id)initWithAchievements:(NSArray *)achievementsEarned;


@end
