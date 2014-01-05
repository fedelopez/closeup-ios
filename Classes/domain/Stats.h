//
//  Stats.h
//  CloseUp
//
//  Created by Fede on 7/06/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum trendType {
    UP, LEVEL, DOWN, NONE
} Trend;

@interface Stats : NSObject {
    int accuracy;
    int average;
    Trend trend;
}

@property(nonatomic) int accuracy;
@property(nonatomic) int average;
@property(nonatomic) Trend trend;

@end
