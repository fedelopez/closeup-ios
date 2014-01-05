//
//  Game.h
//  CloseUp
//
//  Created by Fede on 28/02/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "Score.h"
#import "Achievement.h"

extern int const NumberOfLivesStraight10;
extern int const NumberOfLivesBeatTheClock;
extern int const NumberOfLivesSuddenDeath;

extern NSTimeInterval const DefaultNumberOfSecondsToAnswer;

typedef enum gameMode {
    STRAIGHT_10, BEAT_THE_CLOCK, SUDDEN_DEATH, NO_GAME
} GameMode;

@interface Game : NSObject {
}

@property(nonatomic, readonly) GameMode gameMode;
@property(nonatomic, retain) NSArray *questions;
@property(nonatomic, readonly) NSMutableArray *achievements;
@property(nonatomic) int currentQuestionIndex;
@property(nonatomic, readonly) int totalLives;
@property(nonatomic) int remainingLives;
@property(nonatomic) NSTimeInterval remainingSeconds;
@property(nonatomic) BOOL finished;
@property(nonatomic) BOOL paused;
@property(nonatomic) BOOL suspended;

- (Game *)initWithQuestions:(NSArray *)theQuestions gameMode:(GameMode)theGameMode;

- (Question *)currentQuestion;

- (int)numberOfQuestions;

- (int)numberOfCorrectQuestions;

- (int)numberOfUnansweredQuestions;

- (void)decreaseLivesRemaining;

- (NSString *)unansweredQuestionsDisplayText;

- (void)applyCurrentQuestion:(Question *)theQuestion;

- (void)addAchievement:(Achievement *)achievement;

- (BOOL)isPerfect;

- (Score *)computeScore;

@end
