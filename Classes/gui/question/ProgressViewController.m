//
//  Created by fede on 6/2/13.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import "ProgressViewController.h"
#import "GameProgressView.h"

@implementation ProgressViewController

@synthesize numberOfLives;
@synthesize game;
@synthesize delegate;

- (id)initProgressViewControllerWithGame:(Game *)theGame {
    self = [super initWithNibName:@"ProgressViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        [self setGame:theGame];
    }
    return self;
}

- (void)viewDidLoad {
    [numberOfLives setImage:[UIImage imageNamed:[NSString stringWithFormat:@"lives-%d.png", [game remainingLives]]]];
    GameProgressView *gameProgressView = [[GameProgressView alloc] initWithGame:game];
    [self.view addSubview:gameProgressView];
    [self.view bringSubviewToFront:gameProgressView];
    if ([game gameMode] == BEAT_THE_CLOCK) {
        numberOfSeconds = [[UILabel alloc] initWithFrame:CGRectMake(48, 28, 56, 17)];
        numberOfSeconds.textAlignment = NSTextAlignmentRight;
        numberOfSeconds.font = [UIFont fontWithName:@"MicrogrammaDEE-BoldExte" size:14];
        numberOfSeconds.text = [self remainingSecondsDisplayString];
        numberOfSeconds.backgroundColor = [UIColor clearColor];
        numberOfSeconds.textColor = [UIColor whiteColor];
        [self.view addSubview:numberOfSeconds];
    }
    [gameProgressView release];
}

- (NSString *)remainingSecondsDisplayString {
    if (game.remainingSeconds == DefaultNumberOfSecondsToAnswer) {
        return @"01:00";
    }
    NSString *format = @"00:%d";
    if ([game remainingSeconds] < 10) {
        format = @"00:0%d";
    }
    return [NSString stringWithFormat:format, (int) game.remainingSeconds];
}

- (void)animateLivesRemaining {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(updateLivesDisplay:)];
    numberOfLives.alpha = 0;
    [UIView commitAnimations];
}

- (void)updateLivesDisplay:(id)outcomeAnimationEnded {
    [numberOfLives setImage:[UIImage imageNamed:[NSString stringWithFormat:@"lives-%d.png", [game remainingLives]]]];
    numberOfLives.alpha = 1;
}

- (void)start {
    if ([game gameMode] == BEAT_THE_CLOCK) {
        int oneSecond = 1;
        timer = [[NSTimer scheduledTimerWithTimeInterval:oneSecond target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES] retain];
    }
}

- (void)pause {
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)timerTicked:(NSTimer *)aTimer {
    game.remainingSeconds--;
    numberOfSeconds.text = [self remainingSecondsDisplayString];
    if ([game remainingSeconds] < 1) {
        [aTimer invalidate];
        [delegate timesUp];
        return;
    }
}

- (void)dealloc {
    if (numberOfSeconds) {
        [numberOfSeconds release];
    }
    [game release];
    [numberOfLives release];
    [super dealloc];
}

@end