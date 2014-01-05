//
//  Score.h
//  CloseUp
//
//  Created by Fede on 2/06/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Score : NSObject {
    int points;
    int totalQuestions;
    int correctQuestions;
    BOOL perfect;
    NSDate *date;
}

@property(nonatomic) int points;
@property(nonatomic) BOOL perfect;
@property(nonatomic) int totalQuestions;
@property(nonatomic) int correctQuestions;
@property(nonatomic, retain) NSDate *date;

@end
