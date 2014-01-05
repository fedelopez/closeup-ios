//
//  Created by fede on 7/5/12.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <sqlite3.h>
#import "AbstractDAO.h"

@implementation AbstractDAO

@synthesize dbFileName;

- (id)initWithDbFileName:(NSString *)theDbFileName {
    self = [super init];
    if (self) {
        dbFileName = [theDbFileName retain];
    }
    return self;
}

- (int)intResultForSql:(NSString *)sqlStatement {
    int count = 0;
    sqlite3 *database;
    if (sqlite3_open_v2([dbFileName UTF8String], &database, SQLITE_OPEN_READONLY, nil) == SQLITE_OK) {
        int size = [sqlStatement length] + 1;
        char countSql[size];
        [sqlStatement getCString:countSql maxLength:size encoding:NSASCIIStringEncoding];
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, countSql, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                count = sqlite3_column_int(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    return count;
}

- (NSString *)stringResultForSql:(NSString *)sqlStatement {
    NSString *result = nil;
    sqlite3 *database;
    if (sqlite3_open_v2([dbFileName UTF8String], &database, SQLITE_OPEN_READONLY, nil) == SQLITE_OK) {
        int size = [sqlStatement length] + 1;
        char countSql[size];
        [sqlStatement getCString:countSql maxLength:size encoding:NSASCIIStringEncoding];
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, countSql, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                result = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    return result;
}

- (void)executeStatement:(NSString *)sqlStatement {
    sqlite3 *database;
    if (sqlite3_open([dbFileName UTF8String], &database) == SQLITE_OK) {
        int size = [sqlStatement length] + 1;
        char statementChar[size];
        [sqlStatement getCString:statementChar maxLength:size encoding:NSASCIIStringEncoding];
        sqlite3_stmt *compiledStatement;
        sqlite3_prepare_v2(database, statementChar, -1, &compiledStatement, NULL);
        if (SQLITE_DONE != sqlite3_step(compiledStatement)) {
            NSAssert1(0, @"Error while executing SQL: '%s'", sqlite3_errmsg(database));
        } else {
            NSLog(@"Successful SQL: '%s'", statementChar);
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}

@end