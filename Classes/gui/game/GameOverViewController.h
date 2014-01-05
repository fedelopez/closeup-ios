//
//  Created by fede on 1/23/13.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol GameOverViewControllerDelegate <NSObject>
- (void)gameOverAppearedOnScreen;

@end

@interface GameOverViewController : UIViewController {

    UIImageView *gameOverView;
    UIImage *gameOver;
    id <GameOverViewControllerDelegate> delegate;

}

@property(nonatomic, retain) UIImageView *gameOverView;
@property(nonatomic, retain) UIImage *gameOver;
@property(nonatomic, retain) id <GameOverViewControllerDelegate> delegate;


@end