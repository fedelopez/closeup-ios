//
//  HighScoresTable.h
//  CloseUp
//
//  Created by Fede on 4/06/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import "Score.h"
#import "Stats.h"
#import "ScoreCellDecorator.h"

@interface HighScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, GKLeaderboardViewControllerDelegate> {
    NSArray *scores;
    NSMutableDictionary *gameCenterScores;
    Stats *stats;
    UITableView *table;
    UITableViewCell *scoreCell;

    UIButton *switchGameCenter;
    UIButton *switchPersonalBest;

    UILabel *averageLabel;
    UILabel *accuracyLabel;
    UIImageView *trendImageView;
}

@property(nonatomic, retain) NSArray *scores;
@property(nonatomic, retain) NSMutableDictionary *gameCenterScores;
@property(nonatomic, retain) Stats *stats;

@property(nonatomic, retain) IBOutlet UIButton *switchGameCenter;
@property(nonatomic, retain) IBOutlet UIButton *switchPersonalBest;

@property(nonatomic, retain) IBOutlet UITableView *table;
@property(nonatomic, retain) IBOutlet UITableViewCell *scoreCell;
@property(nonatomic, retain) IBOutlet UILabel *averageLabel;
@property(nonatomic, retain) IBOutlet UILabel *accuracyLabel;
@property(nonatomic, retain) IBOutlet UIImageView *trendImageView;

- (id)initWithScores:(NSArray *)theScores theGameCenterScores:(NSMutableDictionary *)theGameCenterScores theStats:(Stats *)theStats;

- (IBAction)showGameCenterScoresRequested:(id)sender;

- (IBAction)goToMainMenuRequested:(id)sender;

- (IBAction)gameCenterTop5Requested:(id)sender;

- (IBAction)personalBestRequested:(id)sender;

@end
