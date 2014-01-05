//
//  DBHelper.h
//  CloseUp
//
//  Created by Fede on 24/05/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBHelper : NSObject {
}

+ (int)countNumberOfAppearances:(NSString *)databasePath questionId:(int)questionId;

+ (void)addRecordToSavedGameTable:(NSString *)databasePath;

+ (int)countRowsOnTable:(NSString *)databasePath tableName:(NSString *)tableName;

+ (NSString *)stringColumnValueOnFirstRowForTable:(NSString *)databasePath tableName:(NSString *)tableName columnName:(NSString *)columnName;


@end

