//
//  MultiAnswerQuestion.h
//  CloseUp
//
//  Created by Fede on 28/02/10.
//  Copyright 2010 Kowari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface MultiAnswerQuestion : Question {
    NSArray *possibleAnswers;
}

@property(nonatomic, retain) NSArray *possibleAnswers;

@end
