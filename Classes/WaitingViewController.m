//
//  WaitingViewController.m
//  CloseUp
//
//  Created by Fede on 12/02/11.
//  Copyright 2011 FLL. All rights reserved.
//

#import "WaitingViewController.h"

@implementation WaitingViewController

@synthesize messageImageName;

- (id)initWithMessageImageName:(NSString *)theMessageImageName {
    self = [super init];
    [self setMessageImageName:theMessageImageName];
    return self;
}

- (void)loadView {
    UIImage *waitingImage = [UIImage imageNamed:@"waiting-frame.png"];
    backgroundImageView = [[UIImageView alloc] initWithImage:waitingImage];
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    UIImage *messageImage = [UIImage imageNamed:messageImageName];
    messageImageView = [[UIImageView alloc] initWithImage:messageImage];

    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [self.view addSubview:backgroundImageView];
    [self.view addSubview:activityIndicatorView];
    [self.view addSubview:messageImageView];

    CGRect viewFrame = messageImageView.frame;
    viewFrame.origin.y = 85;
    viewFrame.origin.x = 75 - (viewFrame.size.width / 2);
    [messageImageView setFrame:viewFrame];

    viewFrame = activityIndicatorView.frame;
    viewFrame.origin.y = 40;
    viewFrame.origin.x = 75 - (viewFrame.size.width / 2);
    [activityIndicatorView setFrame:viewFrame];

    [activityIndicatorView setHidden:NO];
    [activityIndicatorView startAnimating];
}

- (void)replaceMessageImageNameWith:(NSString *)newMessageImageName {
    [self setMessageImageName:newMessageImageName];
    UIImage *messageImage = [UIImage imageNamed:newMessageImageName];
    UIImageView *newMessageImageView = [[UIImageView alloc] initWithImage:messageImage];
    [messageImageView removeFromSuperview];
    [messageImageView release];
    messageImageView = nil;

    [self.view addSubview:newMessageImageView];
    messageImageView = newMessageImageView;

    CGRect viewFrame = messageImageView.frame;
    viewFrame.origin.y = 85;
    viewFrame.origin.x = 75 - (viewFrame.size.width / 2);
    [newMessageImageView setFrame:viewFrame];
}

- (void)dealloc {
    [activityIndicatorView release];
    [backgroundImageView release];
    [messageImageView release];
    [super dealloc];
}

@end
