//
//  Game.m
//  CloseUp
//
//  Created by Fede on 28/02/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "Game.h"

@implementation Game

int const NumberOfLivesStraight10 = 3;
int const NumberOfLivesBeatTheClock = INT_MAX;
int const NumberOfLivesSuddenDeath = 1;

NSTimeInterval const DefaultNumberOfSecondsToAnswer = 60;

@synthesize gameMode, questions, currentQuestionIndex, remainingLives, remainingSeconds, finished, paused, suspended, achievements, totalLives;

- (Game *)initWithQuestions:(NSArray *)theQuestions gameMode:(GameMode)theGameMode {
    self = [super init];
    if (self) {
        questions = [theQuestions retain];
        currentQuestionIndex = 0;
        remainingSeconds = DefaultNumberOfSecondsToAnswer;
        achievements = [[NSMutableArray alloc] init];
        gameMode = theGameMode;
        switch (gameMode) {
            case STRAIGHT_10:
                remainingLives = NumberOfLivesStraight10;
                totalLives = NumberOfLivesStraight10;
                break;
            case BEAT_THE_CLOCK:
                remainingLives = NumberOfLivesBeatTheClock;
                totalLives = NumberOfLivesBeatTheClock;
                break;
            case SUDDEN_DEATH:
                remainingLives = NumberOfLivesSuddenDeath;
                totalLives = NumberOfLivesSuddenDeath;
                break;
        }
    }
    return self;
}

- (Question *)currentQuestion {
    Question *next = [questions objectAtIndex:currentQuestionIndex];
    return next;
}

- (int)numberOfQuestions {
    if (self.questions == nil) {
        return 0;
    }
    return [self.questions count];
}

- (int)numberOfCorrectQuestions {
    int correctQuestions = 0;
    for (Question *question in questions) {
        if ([question isCorrect]) {
            correctQuestions++;
        }
    }
    return correctQuestions;
}

- (int)numberOfUnansweredQuestions {
    int count = 0;
    for (Question *question in questions) {
        if ([question isAnswered] || [question timedUp]) {
            continue;
        }
        count++;
    }
    return count;
}

- (void)decreaseLivesRemaining {
    remainingLives--;
}

- (NSString *)unansweredQuestionsDisplayText {
    int count = [self numberOfUnansweredQuestions];
    if (count == 0) {
        return @"All questions are answered";
    } else if (count == 1) {
        return @"You have one unanswered question";
    } else {
        return [NSString stringWithFormat:@"You have %d unanswered questions", count];
    }
}

- (void)applyCurrentQuestion:(Question *)theQuestion {
    for (NSUInteger i = 0; i < [questions count]; i++) {
        Question *current = [questions objectAtIndex:i];
        if (theQuestion.questionId == current.questionId) {
            currentQuestionIndex = i;
            return;
        }
    }
}

- (void)addAchievement:(Achievement *)achievement {
    for (Achievement *current in achievements) {
        if (achievement.achievementType == current.achievementType) {
            return;
        }
    }
    [achievements addObject:achievement];
}

- (BOOL)isPerfect {
    if (![self finished]) {
        return NO;
    }
    for (Question *question in questions) {
        if (question.numberOfTries < question.initialNumberOfTries) {
            return NO;
        }
    }
    return YES;
}

- (Score *)computeScore {
    if (![self finished]) {
        return nil;
    }

    int points = 0;
    for (int i = 0; i < [questions count]; i++) {
        Question *current = [questions objectAtIndex:i];
        if ([current isCorrect]) {
            points += [current difficulty];
        }
    }

    if ([self numberOfQuestions] == [self numberOfCorrectQuestions]) {
        points *= 2;
    }

    Score *score = [[Score alloc] init];
    [score setPoints:points];
    [score setDate:[NSDate date]];
    [score setCorrectQuestions:[self numberOfCorrectQuestions]];
    [score setTotalQuestions:[self numberOfQuestions]];
    [score setPerfect:[self isPerfect]];

    return score;
}

- (void)dealloc {
    [questions release];
    [achievements release];
    [super dealloc];
}


@end
