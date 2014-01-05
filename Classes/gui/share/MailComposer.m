//
//  MailComposer.m
//  CloseUp
//
//  Created by Fede on 1/09/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "MailComposer.h"


@implementation MailComposer

+ (NSString *) composeSupportEmailBody:(NSString *)propertyFileName; {
	NSString *model = [[UIDevice currentDevice] model];
	NSString *osVersion = [[UIDevice currentDevice] systemVersion];	
	NSString * appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
	return [NSString stringWithFormat:@"\n\n\n- %@ device\n- iPhone OS version %@\n- CloseUp version %@", model, osVersion, appVersion];
}

@end
