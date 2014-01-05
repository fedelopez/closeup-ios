//
//  GameModeTypeViewController.m
//  CloseUp
//
//  Created by Federico Lopez Laborda on 10/19/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import "GameModeTypeViewController.h"

@implementation GameModeTypeViewController

@synthesize gameMode;
@synthesize heroView;
@synthesize heroLabel;

- (id)init {
    self = [super initWithNibName:@"GameModeTypeViewController" bundle:[NSBundle mainBundle]];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    switch (gameMode) {
        case STRAIGHT_10:
            [heroView setImage:[UIImage imageNamed:@"game-mode-straight-10.png"]];
            [heroLabel setText:@"You have to answer 10 questions with 3 lives to complete the game"];
            break;
        case BEAT_THE_CLOCK:
            [heroView setImage:[UIImage imageNamed:@"game-mode-beat-the-clock.png"]];
            [heroLabel setText:@"You have to answer as many questions as possible in a minute"];
            break;
        case SUDDEN_DEATH:
            [heroView setImage:[UIImage imageNamed:@"game-mode-sudden-death.png"]];
            [heroLabel setText:@"If you miss a kick... you lose"];
            break;
    }
}

- (void)dealloc {
    [heroLabel release];
    [heroView release];
    [heroImage release];
    [heroText release];
    [super dealloc];
}

@end
