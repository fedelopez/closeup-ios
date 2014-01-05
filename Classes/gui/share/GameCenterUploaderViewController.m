//
//  GameCenterViewController.m
//  CloseUp
//
//  Created by Fede on 12/02/11.
//  Copyright 2011 FLL. All rights reserved.
//

#import "GameCenterUploaderViewController.h"

NSString *const GameCenterCategoryId = @"HighScoresId";
static NSString *scoreNotUploaded = @"Score not uploaded";
static NSString *scoreUploaded = @"Score uploaded";

@implementation GameCenterUploaderViewController

@synthesize score, frameForWaitingView, delegate;

- (id)initWithScore:(Score *)theScore initialFrame:(CGRect)theFrameForWaitingView {
    self = [super init];
    if (self) {
        [self setScore:theScore];
        [self setFrameForWaitingView:theFrameForWaitingView];
        waitingViewController = [[WaitingViewController alloc] initWithMessageImageName:@"connecting.png"];
    }
    return self;
}

- (void)loadView {
    [waitingViewController.view setFrame:frameForWaitingView];
    self.view = waitingViewController.view;

    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
        if (error == nil) {
            [waitingViewController replaceMessageImageNameWith:@"uploading.png"];
            int64_t points = [score points];
            GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:GameCenterCategoryId] autorelease];
            scoreReporter.value = points;
            [scoreReporter reportScoreWithCompletionHandler:^(NSError *errorWhileReporting) {
                [waitingViewController.view removeFromSuperview];
                if (errorWhileReporting != nil) {
                    [self showAlert:FALSE aDescription:[error localizedDescription]];
                }
            }];
        } else {
            [waitingViewController.view removeFromSuperview];
            [self showAlert:FALSE aDescription:@"Player authentication failed."];
        }
    }];
}

- (void)showAlert:(BOOL)successful aDescription:(NSString *)description {
    NSString *title = successful ? scoreUploaded : scoreNotUploaded;
    wasSuccessful = successful;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [delegate uploadScoreOnGameCenterDidFinish:wasSuccessful];
}

- (void)dealloc {
    [score release];
    [waitingViewController release];
    [super dealloc];
}
@end
