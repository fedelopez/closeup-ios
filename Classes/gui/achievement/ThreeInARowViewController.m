//
//  ThreeInARowViewController.m
//  CloseUp
//
//  Created by Federico Lopez Laborda on 3/28/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import "ThreeInARowViewController.h"

@implementation ThreeInARowViewController

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        imageToAnimate = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"achievement-3-in-a-row.png"]];
    }
    return self;
}

- (CGRect)createInitialImageFrame {
    CGRect imageFrame = imageToAnimate.frame;
    imageFrame.origin.x = [[UIScreen mainScreen] bounds].size.width;
    imageFrame.origin.y = [[UIScreen mainScreen] bounds].size.height / 6;
    return imageFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:imageToAnimate];

    imageToAnimate.frame = [self createInitialImageFrame];

    void *animation = ^void() {
        CGRect newFrame = imageToAnimate.frame;
        newFrame.origin.x = 0;
        imageToAnimate.frame = newFrame;
    };

    void *completionHandler = ^void(BOOL finished) {
        [self.view removeFromSuperview];
        [self.delegate threeInARowAchievementAnimationEnded];
    };

    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:animation completion:completionHandler];
}

- (void)dealloc {
    [imageToAnimate release];
    [super dealloc];
}


@end
