//
//  ScoreModalViewController.m
//  CloseUp
//
//  Created by Fede on 20/06/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "ScoreModalViewController.h"
#import "Effects.h"
#import "QuestionSummaryScrollViewController.h"
#import "TwitterStoryComposer.h"
#import "ScoreDAO.h"

@implementation ScoreModalViewController

@synthesize game;
@synthesize correctAnswers;
@synthesize points;
@synthesize perfect;
@synthesize newBest;
@synthesize magnitudes;
@synthesize magnitudeOne;
@synthesize magnitudeTenth;
@synthesize magnitudeHundredth;
@synthesize magnitudeThousandth;
@synthesize twitter;
@synthesize gameCenter;
@synthesize mainMenu;
@synthesize questionSummaryScrollViewControllerPanel;
@synthesize scoreDAO;

- (id)initWithGame:(Game *)theGame {
    self = [super initWithNibName:@"ScoreModalViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        canLeaveView = FALSE;
        [self setGame:theGame];
        score = [theGame computeScore];
        [self computePointsIncrement];
        [self setPoints:@"0"];
        scoreDAO = [[ScoreDAO alloc] initWithDbFileName:[[self documentsDirectory] stringByAppendingPathComponent:DATABASE_NAME]];
        questionSummaryScrollVC = [[QuestionSummaryScrollViewController alloc] initQuestionSummaryScrollViewControllerWithGame:game];
        badgeViewController = [[BadgeViewController alloc] initWithAchievements:game.achievements];
    }
    return self;
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (void)computePointsIncrement {
    pointsIncrement = 0;
    if (score.points <= 150) {
        pointsIncrement = 5;
    }
    else if (score.points <= 1000) {
        pointsIncrement = 10;
    }
    else {
        pointsIncrement = 40;
    }
}

- (void)tryToUploadScoreSilently {
    if (![[GKLocalPlayer localPlayer] isAuthenticated]) {
        return;
    }
    int64_t pointsToUpload = [score points];
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:GameCenterCategoryId] autorelease];
    scoreReporter.value = pointsToUpload;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *errorWhileReporting) {
        if (errorWhileReporting != nil) {
            NSLog(@"Could not upload the score to Game Center: %@", [errorWhileReporting localizedDescription]);
        }
    }];
}

- (void)viewDidLoad {
    [gameCenter setHidden:true];
    [twitter setHidden:true];
    [mainMenu setHidden:true];
    magnitudes = [[NSMutableArray alloc] initWithObjects:magnitudeOne, magnitudeTenth, magnitudeHundredth, magnitudeThousandth, nil];
    [magnitudeTenth setHidden:TRUE];
    [magnitudeHundredth setHidden:TRUE];
    [magnitudeThousandth setHidden:TRUE];
    [newBest setHidden:TRUE];
    [questionSummaryScrollViewControllerPanel setBackgroundColor:[UIColor clearColor]];
    isMaxScore = [scoreDAO isHighScore:score];

    UIImage *tapToContinueImage = [UIImage imageNamed:@"tap-to-continue1.png"];
    UIScreen *screen = [UIScreen mainScreen];
    CGSize screenSize = screen.bounds.size;
    CGRect tapToContinueFrame = CGRectMake((screenSize.width - tapToContinueImage.size.width) / 2, screenSize.height, tapToContinueImage.size.width, tapToContinueImage.size.height);
    tapToContinue = [[UIImageView alloc] initWithFrame:tapToContinueFrame];
    tapToContinue.image = tapToContinueImage;
    [self.view addSubview:tapToContinue];
}


- (void)viewWillAppear:(BOOL)animated {
    [self tryToUploadScoreSilently];
    [scoreDAO saveScore:score];
}

- (void)viewDidAppear:(BOOL)animated {
    if (score.correctQuestions > 0) {
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(updateAllViews:) userInfo:nil repeats:NO];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(showTapToContinue:) userInfo:nil repeats:NO];
    }
}

- (void)updateAllViews:(NSTimer *)theTimer {
    [correctAnswers setImage:[UIImage imageNamed:[NSString stringWithFormat:@"number%d.png", [score correctQuestions]]]];
    if ([score perfect]) {
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showPerfectScore:) userInfo:nil repeats:NO];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(triggerPointsCounter:) userInfo:nil repeats:NO];
    }
}

- (void)showPerfectScore:(NSTimer *)theTimer {
    perfect.hidden = FALSE;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hidePerfectScore:)];
    [UIView setAnimationBeginsFromCurrentState:YES];
    perfect.frame = CGRectMake(19, 245, 277, 54);
    [UIView commitAnimations];
}

- (void)hidePerfectScore:(NSTimer *)theTimer {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(triggerPointsCounter:)];
    perfect.alpha = 0;
    [UIView commitAnimations];
}

- (void)triggerPointsCounter:(NSTimer *)theTimer {
    [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(updatePointsCounter:) userInfo:nil repeats:YES];
}

- (void)updatePointsCounter:(NSTimer *)theTimer {
    int pointsInt = [points intValue] + pointsIncrement;
    if (pointsInt >= score.points) {
        [theTimer invalidate];
        pointsInt = score.points;
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(showTapToContinue:) userInfo:nil repeats:NO];
    }
    NSString *pointsString = [NSString stringWithFormat:@"%d", pointsInt];
    [self setPoints:pointsString];
    [Effects drawPointsInImageArray:pointsString magnitudesWithImageViews:magnitudes];
}

- (void)applySpotLightOnTapToContinue {
    canLeaveView = TRUE;
    [Effects applySpotLightOnTapToContinue:tapToContinue];
}

- (void)showTapToContinue:(NSTimer *)theTimer {
    newBest.hidden = !isMaxScore;
    if (isMaxScore) {
        void (^animations)() = ^{
            CGRect newBestFrame = newBest.frame;
            newBestFrame.origin.y = newBestFrame.origin.y - 4;
            newBest.frame = newBestFrame;
            [UIView setAnimationRepeatCount:HUGE_VALF];
        };
        [UIView animateWithDuration:0.4 delay:0 options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse) animations:animations completion:nil];
    }

    void (^tapToContinueAnimations)() = ^{
        CGRect tapFrame = tapToContinue.frame;
        UIScreen *screen = [UIScreen mainScreen];
        CGSize screenSize = screen.bounds.size;
        tapFrame.origin.y = screenSize.height - (tapFrame.size.height * 1.5);
        tapToContinue.frame = tapFrame;
    };
    void (^tapToContinueCompletion)(BOOL) = ^(BOOL b2) {
        [self applySpotLightOnTapToContinue];
    };
    [UIView animateWithDuration:0.4 delay:1.0 options:(UIViewAnimationOptionCurveEaseOut) animations:tapToContinueAnimations completion:tapToContinueCompletion];

    if (game.achievements.count > 0) {
        [self.view addSubview:badgeViewController.view];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (canLeaveView) {
        [tapToContinue setHidden:TRUE];
        [gameCenter setHidden:[[GKLocalPlayer localPlayer] isAuthenticated]];
        [twitter setHidden:FALSE];
        [mainMenu setHidden:FALSE];
        if (game.achievements.count > 0) {
            [badgeViewController.view removeFromSuperview];
        }
        [questionSummaryScrollViewControllerPanel addSubview:questionSummaryScrollVC.view];
    }
}

- (IBAction)goToMainMenuRequested:(id)sender {
    [self dismissModalViewControllerAnimated:TRUE];
}

- (IBAction)shareOnGameCenterRequested:(id)sender {
    [gameCenter setEnabled:FALSE];
    [twitter setEnabled:FALSE];
    [mainMenu setEnabled:FALSE];

    CGRect parentViewFrame = [self.view frame];
    CGRect rect = CGRectMake((parentViewFrame.size.width / 2) - 75, (parentViewFrame.size.height / 2) - 75, 150, 150);

    GameCenterUploaderViewController *gameCenterUploaderViewController = [[[GameCenterUploaderViewController alloc] initWithScore:score initialFrame:rect] autorelease];
    gameCenterUploaderViewController.delegate = self;
    [self.view addSubview:gameCenterUploaderViewController.view];
}

- (IBAction)shareOnTwitterRequested:(id)sender {
    TWTweetComposeViewController *twitterComposeViewController = [[[TWTweetComposeViewController alloc] init] autorelease];
    TwitterStoryComposer *composer = [[[TwitterStoryComposer alloc] initWithScore:score] autorelease];
    [twitterComposeViewController setInitialText:[composer compose]];
    [self presentViewController:twitterComposeViewController animated:YES completion:nil];
}

- (void)uploadScoreOnGameCenterDidFinish:(BOOL)successful {
    [gameCenter setEnabled:!successful];
    [twitter setEnabled:true];
    [mainMenu setEnabled:true];
}

- (void)dealloc {
    [correctAnswers release];
    [tapToContinue release];
    [game release];
    [score release];
    [newBest release];
    [magnitudeOne release];
    [magnitudeTenth release];
    [magnitudeHundredth release];
    [magnitudeThousandth release];
    [magnitudes release];
    [twitter release];
    [gameCenter release];
    [mainMenu release];
    [questionSummaryScrollViewControllerPanel release];
    [questionSummaryScrollVC release];
    [scoreDAO release];
    [badgeViewController release];
    [super dealloc];
}

@end
