//
//  Created by fede on 2/2/13.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import "OnFireViewController.h"


@implementation OnFireViewController

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        imageToAnimate = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"achievement-on-fire.png"]];
    }
    return self;
}

- (CGRect)createInitialImageFrame {
    CGRect imageFrame = imageToAnimate.frame;
    CGRect screen = [[UIScreen mainScreen] bounds];
    imageFrame.origin.x = screen.size.width / 2;
    imageFrame.origin.y = screen.size.height / 2;
    imageFrame.size.width = 0;
    imageFrame.size.height = 0;
    return imageFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:imageToAnimate];

    CGRect originalFrame = imageToAnimate.frame;
    CGRect screen = [[UIScreen mainScreen] bounds];
    imageToAnimate.frame = [self createInitialImageFrame];

    void *animation = ^void() {
        CGRect newFrame = imageToAnimate.frame;
        newFrame.origin.x = screen.size.width / 2 - (originalFrame.size.width / 2);
        newFrame.origin.y = screen.size.height / 2 - (originalFrame.size.height / 2);
        newFrame.size.width = originalFrame.size.width;
        newFrame.size.height = originalFrame.size.height;
        imageToAnimate.frame = newFrame;
    };

    void *completionHandler = ^void(BOOL finished) {
        [self.view removeFromSuperview];
        [self.delegate onFireAnimationEnded];
    };

    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:animation completion:completionHandler];
}

- (void)dealloc {
    [imageToAnimate release];
    [super dealloc];
}


@end
