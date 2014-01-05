//
//  Question.h
//  CloseUp
//
//  Created by Fede on 28/02/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QuestionViewController;

extern NSUInteger const NumberOfTries;

@interface Question : NSObject {
    NSMutableArray *userAnswers;
}

@property(nonatomic) int questionId;
@property(nonatomic, copy) NSString *question;
@property(nonatomic, copy) NSString *correctAnswer;
@property(nonatomic, copy) NSString *imageName;
@property(nonatomic) int difficulty;
@property(nonatomic) BOOL appearedOnScreen;
@property(nonatomic) int displayIndex;
@property(nonatomic) int numberOfTries;
@property(nonatomic) BOOL timedUp;

- (BOOL)isAnswered;

- (BOOL)isCorrect;

- (BOOL)isCorrectNoErrors;

- (void)answer:(NSString *)userAnswer;

- (NSArray *)userAnswers;

- (NSString *)thumbImageName;

- (NSString *)pointsImageName;

- (NSString *)questionWithIndexForDisplay;

- (NSString *)userAnswerForDisplay;

- (NSString *)correctAnswerForDisplay;

- (void)clearLastAnswer;

- (int)initialNumberOfTries;

- (QuestionViewController *)toViewController;

@end
