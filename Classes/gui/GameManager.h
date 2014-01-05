//
//  ScrollViewController.h
//  CloseUp
//
//  Created by Fede on 8/03/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionViewController.h"
#import "BackgroundImageViewController.h"
#import "GameCenterUploaderViewController.h"
#import "Game.h"
#import "ThreeInARowViewController.h"
#import "GameDAO.h"
#import "GameOverViewController.h"
#import "AchievementManager.h"

@interface GameManager : NSObject <GameOverViewControllerDelegate, QuestionViewControllerDelegate, BackgroundImageViewControllerDelegate, ProgressViewControllerDelegate, AchievementManagerDelegate> {
}

@property(nonatomic, retain) Game *game;
@property(nonatomic, retain) GameDAO *gameDAO;
@property(nonatomic, retain) AchievementManager *achievementManager;
@property(nonatomic, retain) UINavigationController *navigationController;

- (id)initGameManager:(UINavigationController *)theNavigationController;

- (void)start;

- (void)displayQuestion:(int)questionIndex;

@end
