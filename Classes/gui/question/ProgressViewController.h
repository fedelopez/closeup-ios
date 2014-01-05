//
//  Created by fede on 6/2/13.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Game.h"


@protocol ProgressViewControllerDelegate <NSObject>
- (void)timesUp;
@end

@interface ProgressViewController : UIViewController {

@private
    NSTimer *timer;
    UILabel *numberOfSeconds;
}

@property(nonatomic, retain) Game *game;
@property(nonatomic, retain) IBOutlet UIImageView *numberOfLives;
@property(nonatomic, assign) id <ProgressViewControllerDelegate> delegate;

- (id)initProgressViewControllerWithGame:(Game *)theGame;

- (void)animateLivesRemaining;

- (void)start;

- (void)pause;


@end