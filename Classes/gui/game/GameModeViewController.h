//
//  GameModeViewController.h
//  CloseUp
//
//  Created by Federico Lopez Laborda on 10/15/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameManager.h"
#import "GameDAO.h"
#import "GameModeTypeViewController.h"

@protocol GameModeViewControllerDelegate <NSObject>

- (void)startGameRequested:(GameMode)selectedGameMode;

@end


@interface GameModeViewController : UIViewController <UIScrollViewDelegate> {
}

@property(nonatomic, assign) id <GameModeViewControllerDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIButton *startButton;
@property(nonatomic, retain) IBOutlet UIButton *homeButton;
@property(nonatomic, retain) IBOutlet UIScrollView *gameModeScrollView;
@property(nonatomic, retain) IBOutlet UIPageControl *pageControl;


- (IBAction)startRequested:(id)sender;

- (IBAction)homeRequested:(id)sender;

- (IBAction)changePageRequested:(id)sender;

@end
