//
//  GameModeViewController.m
//  CloseUp
//
//  Created by Federico Lopez Laborda on 10/15/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import "GameModeViewController.h"

@implementation GameModeViewController

@synthesize gameModeScrollView;
@synthesize startButton;
@synthesize homeButton;
@synthesize pageControl;

- (id)init {
    self = [super initWithNibName:@"GameModeViewController" bundle:[NSBundle mainBundle]];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    GameModeTypeViewController *straight10 = [[GameModeTypeViewController alloc] init];
    [straight10 setGameMode:STRAIGHT_10];

    GameModeTypeViewController *beatTheClock = [[GameModeTypeViewController alloc] init];
    [beatTheClock setGameMode:BEAT_THE_CLOCK];

    GameModeTypeViewController *suddenDeath = [[GameModeTypeViewController alloc] init];
    [suddenDeath setGameMode:SUDDEN_DEATH];

    CGFloat width = straight10.view.frame.size.width;
    CGFloat height = straight10.view.frame.size.height;

    straight10.view.frame = CGRectMake(0, 0, width, height);
    beatTheClock.view.frame = CGRectMake(width, 0, width, height);
    suddenDeath.view.frame = CGRectMake(width * 2, 0, width, height);

    [gameModeScrollView setDelegate:self];
    [gameModeScrollView setContentSize:CGSizeMake(width * 3, height)];
    [gameModeScrollView addSubview:straight10.view];
    [gameModeScrollView addSubview:beatTheClock.view];
    [gameModeScrollView addSubview:suddenDeath.view];

    [straight10 release];
    [beatTheClock release];
    [suddenDeath release];
}

- (IBAction)startRequested:(id)sender {
    GameMode gameMode = (GameMode) pageControl.currentPage;
    [self.delegate startGameRequested:gameMode];
}

- (IBAction)homeRequested:(id)sender {
    [self.delegate startGameRequested:NO_GAME];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageNum = (int) (scrollView.contentOffset.x / scrollView.frame.size.width);
    [pageControl setCurrentPage:pageNum];
}

- (void)changePageRequested:(id)sender {
    NSInteger currentPage = [sender currentPage];
    CGRect scrollFrame = gameModeScrollView.frame;
    scrollFrame.origin.x = scrollFrame.size.width * currentPage;
    scrollFrame.origin.y = 0;
    [gameModeScrollView scrollRectToVisible:scrollFrame animated:YES];
}


- (void)dealloc {
    [startButton release];
    [homeButton release];
    [gameModeScrollView release];
    [pageControl release];
    [super dealloc];
}

@end
