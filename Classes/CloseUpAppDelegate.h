//
//  CloseUpAppDelegate.h
//  CloseUp
//
//  Created by Fede on 9/01/10.
//  Copyright FLL 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LandingViewController.h"
#import "Game.h"
#import "GameDAO.h"
#import "ScoreDAO.h"

@class ScoreDAO;

@interface CloseUpAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
}

@property(nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property(nonatomic, retain) GameDAO *gameDAO;
@property(nonatomic, retain) ScoreDAO *scoreDAO;

- (void)copyDatabaseToDocumentsDirectory;

- (BOOL)databaseExistsInDocumentsDirectory;

- (NSString *)documentsDirectory;

@end

