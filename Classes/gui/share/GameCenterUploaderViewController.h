//
//  GameCenterUploaderViewController.h
//  CloseUp
//
//  Created by Fede on 12/02/11.
//  Copyright 2011 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#import "Score.h"
#import "WaitingViewController.h"

@class GameCenterUploaderViewController;

@protocol GameCenterUploaderViewControllerDelegate
- (void)uploadScoreOnGameCenterDidFinish:(BOOL)successful;
@end

extern NSString *const GameCenterCategoryId;

@interface GameCenterUploaderViewController : UIViewController <UIAlertViewDelegate> {
    Score *score;
    CGRect frameForWaitingView;
@private WaitingViewController *waitingViewController;
@private BOOL wasSuccessful;
    id <GameCenterUploaderViewControllerDelegate> delegate;
}

@property(nonatomic, retain) Score *score;
@property(nonatomic) CGRect frameForWaitingView;
@property(nonatomic, assign) id <GameCenterUploaderViewControllerDelegate> delegate;

- (id)initWithScore:(Score *)theScore initialFrame:(CGRect)theFrameForWaitingView;

- (void)showAlert:(BOOL)successful aDescription:(NSString *)description;

@end
