//
//  BackgroundImageViewController.m
//  CloseUp
//
//  Created by Fede on 14/02/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "BackgroundImageViewController.h"


@implementation BackgroundImageViewController

@synthesize question;
@synthesize homeButton;
@synthesize resumeButton;
@synthesize delegate;


- (id)initBackgroundImageViewController {
    self = [super initWithNibName:@"BackgroundImageViewController" bundle:[NSBundle bundleForClass:BackgroundImageViewController.class]];
    return self;
}

- (IBAction)endGameRequested:(id)sender {
    [delegate endGameRequested];
}

- (IBAction)resumeGameRequested:(id)sender {
    [delegate resumeGame];
}

- (void)dealloc {
    [question release];
    [homeButton release];
    [resumeButton release];
    [super dealloc];
}

@end
