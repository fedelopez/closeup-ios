//
//  ScrollViewController.m
//  CloseUp
//
//  Created by Fede on 8/03/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "GameManager.h"
#import "ScoreModalViewController.h"
#import "AchievementReporter.h"

@implementation GameManager

@synthesize game;
@synthesize achievementManager;
@synthesize gameDAO;
@synthesize navigationController;

- (id)initGameManager:(UINavigationController *)theNavigationController {
    self = [super init];
    if (self) {
        self.navigationController = theNavigationController;
        achievementManager = [[AchievementManager alloc] init];
        [achievementManager setDelegate:self];
    }
    return self;
}

- (void)start {
    [achievementManager reset];
    [self displayQuestion:[game currentQuestionIndex]];
}

- (void)pauseGame:(Question *)question {
    [game setPaused:TRUE];

    BackgroundImageViewController *pauseImageViewController = [[BackgroundImageViewController alloc] initBackgroundImageViewController];
    pauseImageViewController.delegate = self;
    [pauseImageViewController setQuestion:question];

    [navigationController pushViewController:pauseImageViewController animated:NO];
    [pauseImageViewController release];
}

- (void)resumeGame {
    [game setPaused:FALSE];
    [navigationController popViewControllerAnimated:NO];
}

- (void)endGameRequested {
    [navigationController popToRootViewControllerAnimated:YES];
}

- (void)gameOver {
    GameOverViewController *gameOverViewController = [[[GameOverViewController alloc] init] autorelease];
    [gameOverViewController setDelegate:self];
    UIViewController *viewController = [navigationController visibleViewController];
    [viewController.view addSubview:gameOverViewController.view];
}

- (void)gameOverAppearedOnScreen {
    [self displayScore];
}

- (void)displayScore {
    [game setFinished:TRUE];
    [gameDAO updateNumberOfAppearancesForGameQuestions:game];

    ScoreModalViewController *scoreModalVC = [[ScoreModalViewController alloc] initWithGame:game];
    [scoreModalVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];

    void *completion = ^void() {
        [self endGameRequested];
    };

    [navigationController presentViewController:scoreModalVC animated:YES completion:completion];
    [scoreModalVC release];
}


- (void)questionAnswered:(Question *)question {
    NSLog(@"Question %d answered. Correct %d, Difficulty: %d", [question displayIndex], [question isCorrect], [question difficulty]);
    [achievementManager trackQuestionAnswered:question];

    int nextQuestionIndex = [question displayIndex] + 1;
    if ([question isCorrect]) {
        if ([achievementManager hasAchievementsToReport]) {
            UIViewController *viewController = [navigationController visibleViewController];
            UIView *view = viewController.view;
            [achievementManager reportAchievementsWithAnimationsOnTopOf:view];
        } else {
            [self displayQuestion:nextQuestionIndex];
        }
    } else {
        [game decreaseLivesRemaining];
        if ([game remainingLives] == 0 || [question timedUp]) {
            [self gameOver];
        } else if ([question numberOfTries] == 0) {
            [self displayQuestion:nextQuestionIndex];
        } else if ([game gameMode] == BEAT_THE_CLOCK) {
            QuestionViewController *questionViewController = (QuestionViewController *) [navigationController visibleViewController];
            [questionViewController resumeTimeIndicator];
        }
    }
}

- (void)achievementAnimationEnded {
    int nextQuestionIndex = [game currentQuestionIndex] + 1;
    [game setCurrentQuestionIndex:nextQuestionIndex];
    [self displayQuestion:nextQuestionIndex];
}

- (void)displayQuestion:(int)questionIndex {
    [game setCurrentQuestionIndex:questionIndex];
    if (questionIndex == [game numberOfQuestions]) {
        [self reportGameCompletedAchievement];
        [self maybeReportPerfectAchievement];
        [self displayScore];
    } else {
        Question *question = [game.questions objectAtIndex:questionIndex];
        QuestionViewController *currentQuestionVC = [question toViewController];
        [currentQuestionVC setDelegate:self];
        ProgressViewController *progressViewController = [[ProgressViewController alloc] initProgressViewControllerWithGame:game];
        [currentQuestionVC setProgressViewController:progressViewController];
        [progressViewController release];

        if (BEAT_THE_CLOCK == [game gameMode]) {
            [progressViewController setDelegate:self];
            [currentQuestionVC setProgressViewController:progressViewController];
        }

        [navigationController pushViewController:currentQuestionVC animated:NO];
        if ([game paused]) {
            [self pauseGame:question];
        }
    }
}

- (void)remainingSeconds:(NSTimeInterval)remainingSeconds {
    [game setRemainingSeconds:remainingSeconds];
}

- (void)timesUp {
    QuestionViewController *questionViewController = (QuestionViewController *) [navigationController visibleViewController];
    [questionViewController timesUp];
}

- (void)maybeReportPerfectAchievement {
    for (Question *question in game.questions) {
        if (![question isCorrectNoErrors]) {
            return;
        }
    }
    Achievement *perfect = [[[Achievement alloc] init] autorelease];
    [perfect setAchievementType:PERFECT];
    [game addAchievement:perfect];
    [AchievementReporter reportAchievement:perfect];
}

- (void)reportGameCompletedAchievement {
    Achievement *gameCompleted = [[[Achievement alloc] init] autorelease];
    [gameCompleted setAchievementType:GAME_COMPLETED];
    [game addAchievement:gameCompleted];
    [AchievementReporter reportAchievement:gameCompleted];
}


- (void)dealloc {
    [game release];
    [gameDAO release];
    [navigationController release];
    [achievementManager release];
    [super dealloc];
}

@end
