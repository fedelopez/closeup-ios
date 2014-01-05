//
//  ThreeInARowViewController.h
//  CloseUp
//
//  Created by Federico Lopez Laborda on 3/28/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThreeInARowViewControllerDelegate <NSObject>
- (void)threeInARowAchievementAnimationEnded;
@end

@interface ThreeInARowViewController : UIViewController {
    id <ThreeInARowViewControllerDelegate> delegate;
@private
    UIImageView *imageToAnimate;
}

@property(nonatomic, assign) id <ThreeInARowViewControllerDelegate> delegate;

@end
