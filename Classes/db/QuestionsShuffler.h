//
//  QuestionsShuffler.h
//  CloseUp
//
//  Created by Fede on 24/05/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface QuestionsShuffler : NSObject {

}

+ (NSArray *) shuffle:(NSArray *) questions inBetweeners:(NSArray *) inBetweeners;

@end
