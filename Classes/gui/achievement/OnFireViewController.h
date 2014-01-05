//
//  Created by fede on 2/2/13.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OnFireViewControllerDelegate <NSObject>
- (void)onFireAnimationEnded;
@end

@interface OnFireViewController : UIViewController {
    id <OnFireViewControllerDelegate> delegate;

@private
    UIImageView *imageToAnimate;
}

@property(nonatomic, assign) id <OnFireViewControllerDelegate> delegate;

@end