//
//  AboutViewController.m
//  CloseUp
//
//  Created by Fede on 30/08/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "AboutViewController.h"
#import "MailComposer.h"

@implementation AboutViewController

@synthesize table, header, footer, support, version, alamyCredits, developerCredits, designerCredits, versionString;

- (id)init {
    self = [super initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
    return self;
}

- (void)viewDidLoad {
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.header setBackgroundColor:[UIColor clearColor]];
    [self.footer setBackgroundColor:[UIColor clearColor]];
    [self.versionString setText:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-background.png"]];
    [self.table setBackgroundView:backgroundView];
    [backgroundView release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return support;
            case 1:
                return version;
            default:
                return nil;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                return alamyCredits;
            case 1:
                return developerCredits;
            case 2:
                return designerCredits;
            default:
                return nil;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return header;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 90;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (![MFMailComposeViewController canSendMail]) {
            return;
        }
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setSubject:@"CloseUp feedback or support"];
        NSArray *recipients = [[NSArray alloc] initWithObjects:@"support@closeuptheapp.com", nil];
        [controller setToRecipients:recipients];
        [controller setMessageBody:[MailComposer composeSupportEmailBody:@"CloseUp-Info.plist"] isHTML:NO];
        [controller setMailComposeDelegate:self];
        [self presentModalViewController:controller animated:YES];
        [recipients release];
        [controller release];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSURL *url = [NSURL URLWithString:@"http://www.alamy.com"];
            [[UIApplication sharedApplication] openURL:url];
        } else if (indexPath.row == 2) {
            NSURL *url = [NSURL URLWithString:@"http://kajdax.de"];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)goToMainMenuRequested:(id)sender {
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void)dealloc {
    [table release];
    [header release];
    [footer release];
    [support release];
    [version release];
    [alamyCredits release];
    [developerCredits release];
    [designerCredits release];
    [versionString release];
    [super dealloc];
}


@end
