//
//  AboutViewController.h
//  CloseUp
//
//  Created by Fede on 30/08/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>  {
	UITableView * table;
	UIView *header;
	UIView *footer;
	
	UITableViewCell * support;
	UITableViewCell * version;
	
	UITableViewCell * alamyCredits;
	UITableViewCell * developerCredits;
	UITableViewCell * designerCredits;
	
	UILabel *versionString;
}

@property (nonatomic, retain) IBOutlet UITableView * table;
@property (nonatomic, retain) IBOutlet UIView * header;
@property (nonatomic, retain) IBOutlet UIView * footer;
@property (nonatomic, retain) IBOutlet UITableViewCell * support;
@property (nonatomic, retain) IBOutlet UITableViewCell * version;
@property (nonatomic, retain) IBOutlet UITableViewCell * alamyCredits;
@property (nonatomic, retain) IBOutlet UITableViewCell * developerCredits;
@property (nonatomic, retain) IBOutlet UITableViewCell * designerCredits;
@property (nonatomic, retain) IBOutlet UILabel *versionString;

- (id) init;
- (IBAction) goToMainMenuRequested:(id)sender;

@end
