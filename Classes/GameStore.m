//
//  Created by fede on 10/20/12.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import "GameStore.h"

static Game *sharedInstance = nil;

@implementation GameStore {

}
+ (Game *)getSharedInstance {
    return sharedInstance;
}

+ (void)setSharedInstance:(Game *)game {
    sharedInstance = game;
}


@end