//
//  Created by fede on 10/20/12.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"


@interface GameStore : NSObject {
}

+ (Game *)getSharedInstance;

+ (void)setSharedInstance:(Game *)game;

@end