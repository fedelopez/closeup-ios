//
//  Created by fede on 7/5/12.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DATABASE_NAME = @"closeup.sqlite";

@interface AbstractDAO : NSObject {
    NSString *dbFileName;
}

@property(nonatomic, assign) NSString *dbFileName;

- (id)initWithDbFileName:(NSString *)theDbFileName;

- (int)intResultForSql:(NSString *)sqlStatement;

- (NSString *)stringResultForSql:(NSString *)sqlStatement;

- (void)executeStatement:(NSString *)sqlStatement;

@end