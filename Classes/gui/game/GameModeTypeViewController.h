//
//  GameModeTypeViewController.h
//  CloseUp
//
//  Created by Federico Lopez Laborda on 10/19/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface GameModeTypeViewController : UIViewController {

    UIImageView *heroView;
    UILabel *heroLabel;

    UIImage *heroImage;
    NSString *heroText;
}

@property(nonatomic, assign) GameMode gameMode;
@property(nonatomic, retain) IBOutlet UIImageView *heroView;
@property(nonatomic, retain) IBOutlet UILabel *heroLabel;

@end
