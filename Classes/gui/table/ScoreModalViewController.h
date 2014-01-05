//
//  ScoreModalViewController.h
//  CloseUp
//
//  Created by Fede on 20/06/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import "Game.h"
#import "GameCenterUploaderViewController.h"
#import "BadgeViewController.h"

@class QuestionSummaryScrollViewController;
@class ScoreDAO;

@interface ScoreModalViewController : UIViewController <GameCenterUploaderViewControllerDelegate> {

    ScoreDAO *scoreDAO;

    int pointsIncrement;
    BOOL canLeaveView;
    BOOL isMaxScore;
    Score *score;
    QuestionSummaryScrollViewController *questionSummaryScrollVC;
    BadgeViewController *badgeViewController;
    UIImageView *tapToContinue;
}

@property(nonatomic, retain) Game *game;
@property(nonatomic, retain) NSString *points;
@property(nonatomic, retain) IBOutlet UIImageView *correctAnswers;
@property(nonatomic, retain) IBOutlet UIImageView *perfect;
@property(nonatomic, retain) IBOutlet UIImageView *newBest;
@property(nonatomic, retain) IBOutlet UIImageView *magnitudeOne;
@property(nonatomic, retain) IBOutlet UIImageView *magnitudeTenth;
@property(nonatomic, retain) IBOutlet UIImageView *magnitudeHundredth;
@property(nonatomic, retain) IBOutlet UIImageView *magnitudeThousandth;
@property(nonatomic, retain) IBOutlet UIButton *gameCenter;
@property(nonatomic, retain) IBOutlet UIButton *twitter;
@property(nonatomic, retain) IBOutlet UIButton *mainMenu;
@property(nonatomic, retain) IBOutlet UIView *questionSummaryScrollViewControllerPanel;
@property(nonatomic, retain) NSMutableArray *magnitudes;
@property(nonatomic, retain) ScoreDAO *scoreDAO;

- (id)initWithGame:(Game *)theGame;

- (void)computePointsIncrement;

- (void)updateAllViews:(NSTimer *)theTimer;

- (void)showPerfectScore:(NSTimer *)theTimer;

- (void)triggerPointsCounter:(NSTimer *)theTimer;

- (void)updatePointsCounter:(NSTimer *)theTimer;

- (void)showTapToContinue:(NSTimer *)theTimer;

- (IBAction)goToMainMenuRequested:(id)sender;

- (IBAction)shareOnGameCenterRequested:(id)sender;

- (IBAction)shareOnTwitterRequested:(id)sender;

@end
