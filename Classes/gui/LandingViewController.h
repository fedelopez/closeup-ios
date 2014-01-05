//
//  LandingViewController.h
//  CloseUp
//
//  Created by Fede on 9/03/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "GameManager.h"
#import "GameDAO.h"
#import "ScoreDAO.h"
#import "LandingViewController.h"
#import "GameModeViewController.h"

@interface LandingViewController : UIViewController <GameModeViewControllerDelegate> {

    BOOL gameCenterScoresLoaded;
    int gameCenterScoresLoadAttempts;
    UIImageView *v2Image;
}

@property(nonatomic, retain) GameManager *gameManager;
@property(nonatomic, retain) IBOutlet UIButton *startButton;
@property(nonatomic, retain) IBOutlet UIButton *resumeButton;
@property(nonatomic, retain) IBOutlet UIButton *highScoresButton;
@property(nonatomic, retain) IBOutlet UIButton *aboutButton;
@property(nonatomic, retain) GameDAO *gameDAO;
@property(nonatomic, retain) ScoreDAO *scoreDAO;
@property(nonatomic, retain) NSMutableDictionary *gameCenterScores;
@property(nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (IBAction)startNewGameRequested:(id)sender;

- (IBAction)resumeGameRequested:(id)sender;

- (void)resumeGame;

- (IBAction)highScoresRequested:(id)sender;

- (void)highScores;

- (IBAction)aboutRequested:(id)sender;

- (void)startActivityIndicator;

@end
