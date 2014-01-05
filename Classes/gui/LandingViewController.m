//
//  LandingViewController.m
//  CloseUp
//
//  Created by Fede on 9/03/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "LandingViewController.h"
#import "HighScoresViewController.h"
#import "AboutViewController.h"
#import "GameStore.h"

@implementation LandingViewController

@synthesize gameManager;
@synthesize startButton;
@synthesize resumeButton;
@synthesize highScoresButton;
@synthesize aboutButton;
@synthesize gameDAO;
@synthesize scoreDAO;
@synthesize gameCenterScores;
@synthesize loadingLabel;
@synthesize loadingIndicator;

- (IBAction)startNewGameRequested:(id)sender {
    GameModeViewController *gameModeViewController = [[GameModeViewController alloc] init];
    [gameModeViewController setDelegate:self];
    [self.navigationController pushViewController:gameModeViewController animated:NO];
    [gameModeViewController release];
}

- (IBAction)resumeGameRequested:(id)sender {
    [self hideButtons:@selector(resumeGame)];
}

- (IBAction)highScoresRequested:(id)sender {
    [self hideButtons:@selector(highScores)];
}

- (IBAction)aboutRequested:(id)sender {
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    [aboutVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:aboutVC animated:YES completion:nil];
    [aboutVC release];
}

- (void)resumeGame {
    Game *game = [gameDAO loadSavedGame];
    [GameStore setSharedInstance:game];
    [gameManager setGame:game];
    [gameManager start];
    [gameDAO deleteSavedGameTables];
}

- (void)startGameRequested:(GameMode)selectedGameMode {
    if (selectedGameMode == NO_GAME) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    } else {
        Game *game = [gameDAO loadNewGame:selectedGameMode];
        [GameStore setSharedInstance:game];
        [gameManager setGame:game];
        [gameManager start];
        [gameDAO deleteSavedGameTables];
    }
}


- (void)highScores {
    [self retrieveTopTenGameCenterScores];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(presentHighScoresViewController:) userInfo:nil repeats:YES];
}

- (void)presentHighScoresViewController:(id)presentHighScoresViewController {
    if (!gameCenterScoresLoaded && gameCenterScoresLoadAttempts < 8) {
        gameCenterScoresLoadAttempts++;
        return;
    } else {
        [presentHighScoresViewController invalidate];
    }

    NSArray *highScores = [scoreDAO loadHighScores];
    Stats *stats = [scoreDAO loadStats];

    HighScoresViewController *highScoresVC = [[HighScoresViewController alloc] initWithScores:highScores theGameCenterScores:gameCenterScores theStats:stats];
    [self presentViewController:highScoresVC animated:YES completion:nil];
    [highScoresVC release];
}

- (void)hideButtons:(SEL)targetMethod {
    [self startActivityIndicator];
    [UIView beginAnimations:@"HideButtons" context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:targetMethod];
    startButton.alpha = 0;
    resumeButton.alpha = 0;
    highScoresButton.alpha = 0;
    aboutButton.alpha = 0;
    [UIView commitAnimations];
}

- (void)startActivityIndicator {
    [loadingLabel setHidden:FALSE];
    [loadingIndicator startAnimating];
}


- (void)viewWillAppear:(BOOL)animated {
    startButton.alpha = 1.0;
    resumeButton.alpha = 1.0;
    highScoresButton.alpha = 1.0;
    aboutButton.alpha = 1.0;
    [loadingLabel setHidden:true];
    [loadingIndicator stopAnimating];
    gameCenterScoresLoadAttempts = 0;
    gameCenterScoresLoaded = false;

    [self startAnimations];

    BOOL resumeEnabled = false;

    Game *previousGame = [GameStore getSharedInstance];
    if (previousGame) {
        if ([previousGame finished]) {
            [gameDAO deleteSavedGameTables];
        } else {
            [previousGame setSuspended:false];
            [gameDAO saveGame:previousGame];
            resumeEnabled = true;
        }
        [GameStore setSharedInstance:nil];
    } else {
        Game *savedGame = [gameDAO loadSavedGame];
        resumeEnabled = savedGame != nil;
        if (savedGame && [savedGame suspended]) {
            [GameStore setSharedInstance:savedGame];
            [self resumeGame];
        }
    }
    [resumeButton setEnabled:resumeEnabled];

}

- (void)startAnimations {
    if (!v2Image) {
        v2Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu-v2.png"]];
        void (^animations)() = ^{
            [self animateV2ImageView];
        };
        [UIView animateWithDuration:1.5 delay:1 options:nil animations:animations completion:nil];
    }
}


- (void)presentGameMenus {
    void (^animations)() = ^{
        [self animateV2ImageView];
    };
    [UIView animateWithDuration:1.5 delay:1 options:nil animations:animations completion:nil];
}

- (void)animateV2ImageView {
    CGFloat width = v2Image.frame.size.width;
    CGFloat height = v2Image.frame.size.height;
    CGRect startPosition = CGRectMake(185, 70, 0, 0);
    v2Image.frame = startPosition;

    CGRect endPosition = CGRectMake(startPosition.origin.x, startPosition.origin.y, width, height);
    [self.view addSubview:v2Image];
    void (^animations)() = ^{
        v2Image.frame = endPosition;
    };
    void (^completion)(BOOL) = ^(BOOL b) {
        [self rotateV2ImageView];
    };
    [UIView animateWithDuration:1 animations:animations completion:completion];
}

- (void)rotateV2ImageView {
    void (^animations)() = ^{
        float angle = (float) M_PI_4 / 6;
        v2Image.layer.transform = CATransform3DMakeRotation(-angle, 0, 0.0, 1.0);
    };
    [UIView animateWithDuration:0.5 animations:animations];
}

- (void)retrieveTopTenGameCenterScores {
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    if (leaderboardRequest != nil) {
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardRequest.category = @"HighScoresId";
        leaderboardRequest.range = NSMakeRange(1, 5);
        NSLog(@"About to load Game Center scores...");
        [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *gkScores, NSError *error) {
            if (error != nil) {
                NSLog(@"Error loading scores: %@", error);
            } else {
                [self fillGameCenterScores:gkScores];
            }
        }];
    } else {
        NSLog(@"Could not create leaderboardRequest.");
    }
    [leaderboardRequest release];
}

- (void)fillGameCenterScores:(NSArray *)gkScores {
    NSMutableArray *players = [[[NSMutableArray alloc] initWithCapacity:[gkScores count]] autorelease];
    NSMutableDictionary *playerScore = [[[NSMutableDictionary alloc] init] autorelease];
    if (gkScores != nil) {
        for (GKScore *score in gkScores) {
            [players addObject:score.playerID];
            [playerScore setValue:score forKey:score.playerID];
        }
    }
    void (^handler)(NSArray *, NSError *) = ^(NSArray *array, NSError *error) {
        if (error == nil) {
            gameCenterScores = [[NSMutableDictionary alloc] initWithCapacity:array.count];
            for (int i = 0; i < array.count; i++) {
                GKPlayer *player = [array objectAtIndex:i];
                GKScore *score = [playerScore objectForKey:player.playerID];
                [gameCenterScores setObject:score forKey:player.alias];
            }
            gameCenterScoresLoaded = true;
        }

    };
    [GKPlayer loadPlayersForIdentifiers:players withCompletionHandler:handler];
}

- (void)dealloc {
    if (v2Image) {
        [v2Image release];
    }
    [startButton release];
    [resumeButton release];
    [highScoresButton release];
    [aboutButton release];
    [loadingLabel release];
    [loadingIndicator release];
    [gameManager release];
    [gameDAO release];
    [scoreDAO release];
    if (gameCenterScores) {
        [gameCenterScores release];
    }
    [super dealloc];
}

@end
