//
//  WaitingViewController.h
//  CloseUp
//
//  Created by Fede on 12/02/11.
//  Copyright 2011 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WaitingViewController : UIViewController {
	@private UIActivityIndicatorView * activityIndicatorView;
	@private UIImageView * backgroundImageView;
	@private UIImageView * messageImageView;
	NSString * messageImageName;
}

@property (nonatomic, retain) NSString *messageImageName;

-(id) initWithMessageImageName:(NSString *)theMessageImageName;
-(void) replaceMessageImageNameWith:(NSString *)newMessageImageName;

@end
