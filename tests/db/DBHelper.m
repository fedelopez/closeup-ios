//
//  DBHelper.m
//  CloseUp
//
//  Created by Fede on 24/05/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "DBHelper.h"

@implementation DBHelper

+ (int)countNumberOfAppearances:(NSString *)databasePath questionId:(int)questionId {
    sqlite3 *database;
    int numberAppearances = -1;
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sqlStatement = "select number_appearances from question where question_id = ?";
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_bind_int(compiledStatement, 1, questionId) != SQLITE_OK) {
                NSAssert1(0, @"Could not bind int %d", questionId);
            }
            if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                numberAppearances = sqlite3_column_int(compiledStatement, 0);
            }
            sqlite3_finalize(compiledStatement);
        }
    } else {
        NSAssert1(0, @"Could not open database: '%@'", databasePath);
    }
    sqlite3_close(database);
    return numberAppearances;
}

+ (void)addRecordToSavedGameTable:(NSString *)databasePath {
    sqlite3 *database;
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        const char *insertParentTable = "insert into saved_game (saved_game_id, selected_question_index, remaining_lives, paused, remaining_seconds, game_mode, suspended) values ('TEST', 0, 0, 0, 1, 0, 0)";
        if (sqlite3_prepare_v2(database, insertParentTable, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSAssert1(0, @"Could not insert record in  saved_game table.", sqlite3_errmsg(database));
            }
            sqlite3_reset(compiledStatement);
        }
        const char *insertChildTable = "insert into saved_game_question (saved_game_id, question_id, user_answer, question_index, appeared_on_screen) values ('TEST', 2, 'hi there', 0, 0)";
        if (sqlite3_prepare_v2(database, insertChildTable, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSAssert1(0, @"Could not insert record in  saved_game_question table.", sqlite3_errmsg(database));
            }
            sqlite3_finalize(compiledStatement);
        }

    } else {
        NSAssert1(0, @"Could not open database: '%@'", databasePath);
    }
    sqlite3_close(database);
}

+ (int)countRowsOnTable:(NSString *)databasePath tableName:(NSString *)tableName {
    sqlite3 *database;
    int count = 0;
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *countSQL = [@"select count(1) from " stringByAppendingString:tableName];
        NSUInteger length = [countSQL length] + 1;
        char countSQLChar[length];
        [countSQL getCString:countSQLChar maxLength:length encoding:NSASCIIStringEncoding];
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, countSQLChar, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                count = sqlite3_column_int(compiledStatement, 0);
            }
            sqlite3_finalize(compiledStatement);
        }
    } else {
        NSAssert1(0, @"Could not open database: '%@'", databasePath);
    }
    sqlite3_close(database);
    return count;
}

+ (NSString *)stringColumnValueOnFirstRowForTable:(NSString *)databasePath tableName:(NSString *)tableName columnName:(NSString *)columnName {
    sqlite3 *database;
    NSString *result = nil;
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *selectSQL = [NSString stringWithFormat:@"select %@ from %@ limit 1", columnName, tableName];
        NSUInteger length = [selectSQL length] + 1;
        char countSQLChar[length];
        [selectSQL getCString:countSQLChar maxLength:length encoding:NSASCIIStringEncoding];
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2(database, countSQLChar, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                result = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)];
            }
            sqlite3_finalize(compiledStatement);
        }
    } else {
        NSAssert1(0, @"Could not open database: '%@'", databasePath);
    }
    sqlite3_close(database);
    return result;
}

@end
