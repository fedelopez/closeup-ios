//
//  Created by fede on 6/6/13.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Game.h"

@interface GameProgressView : UIView {

}

@property(nonatomic, retain) Game *game;

- (id)initWithGame:(Game *)game;


@end