//
//  TwitterStoryComposer.h
//  CloseUp
//
//  Created by Fede on 17/04/12.
//  Copyright 2012 FLL. All rights reserved.
//

#import "Score.h"

extern NSString *const TwitterAddress;

@interface TwitterStoryComposer : NSObject {
    Score *score;
}


@property(nonatomic, retain) Score *score;

- (id)initWithScore:(Score *)theScore;

- (NSString *)compose;

@end
