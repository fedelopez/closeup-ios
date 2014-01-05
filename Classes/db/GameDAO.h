//
//  QuestionsLoader.h
//  CloseUp
//
//  Created by Fede on 5/04/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "Game.h"
#import "Question.h"
#import "MultiAnswerQuestion.h"
#import "TrueFalseQuestion.h"
#import "WhichOneCameFirst.h"
#import "Score.h"
#import "Stats.h"
#import "AbstractDAO.h"

static NSString *const LEGACY_DB_VERSION = @"1.0";
static int const TOTAL_QUESTIONS_PER_GAME = 10;

@interface GameDAO : AbstractDAO {

}

- (NSMutableArray *)loadLessUsedQuestionIds:(NSString *)questionTable maxNumToLoad:(int)maxNumToLoad;

- (void)fillQuestionIdArray:(NSString *)questionTable questionIds:(NSMutableArray *)questionIds numberOfApperances:(int)numberOfApperances numToLoad:(int)numToLoad;

- (int)numberOfQuestionsForSavedGame;

- (Game *)loadNewGame:(GameMode)mode;

- (Game *)loadSavedGame;

- (NSArray *)loadMultiAnswerQuestions:(NSArray *)multiAnswerQuestions;

- (NSArray *)loadTrueFalseQuestions:(NSArray *)trueFalseQuestions;

- (WhichOneCameFirst *)loadWhichOneCameFirstQuestion;

- (void)saveGame:(Game *)game;

- (void)deleteSavedGameTables;

- (void)updateNumberOfAppearancesForGameQuestions:(Game *)game;

- (NSString *)databaseVersion;

@end
