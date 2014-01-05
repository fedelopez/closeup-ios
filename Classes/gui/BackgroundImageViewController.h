//
//  BackgroundImageViewController.h
//  CloseUp
//
//  Created by Fede on 14/02/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@protocol BackgroundImageViewControllerDelegate <NSObject>
- (void)resumeGame;

- (void)endGameRequested;
@end


@interface BackgroundImageViewController : UIViewController {
}

@property(nonatomic, retain) Question *question;
@property(nonatomic, retain) IBOutlet UIButton *homeButton;
@property(nonatomic, retain) IBOutlet UIButton *resumeButton;
@property(nonatomic, assign) id <BackgroundImageViewControllerDelegate> delegate;

- (id)initBackgroundImageViewController;

- (IBAction)endGameRequested:(id)sender;

- (IBAction)resumeGameRequested:(id)sender;


@end
