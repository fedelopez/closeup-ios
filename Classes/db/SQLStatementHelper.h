//
//  SQLStatementHelper.h
//  CloseUp
//
//  Created by Fede on 11/05/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"
#import "Question.h"
#import "Score.h"

@interface SQLStatementHelper : NSObject {

}

+ (NSString *) insertGameSQL:(Game *)game; 
+ (NSString *) insertQuestionSQL:(Question *)question; 

+ (NSString *) selectMultiAnswerQuestionsSQL:(NSArray *)questionIds; 
+ (NSString *) selectTrueFalseQuestionsSQL:(NSArray *)questionIds; 
+ (NSString *) selectWhichOneCameFirstQuestionSQL:(NSString *)questionId; 

+ (NSString *) updateNumberOfAppearancesSQL:(NSArray *)questionIds; 
+ (NSString *) insertHighScoreSQL:(Score *)score; 
+ (NSString *) minNumberOfAppearancesForQuestionTableSQL:(NSString *)questionTableName minNumAppearances:(int)minNumAppearances;
+ (NSString *) countNumberOfQuestionsWithNumberOfAppearancesSQL:(NSString *)questionTable numAppearances:(int)numAppearances;
+ (NSString *) selectRandomQuestionsSQL:(NSString *)questionTable numAppearances:(int)numAppearances limit:(int)limit;

@end