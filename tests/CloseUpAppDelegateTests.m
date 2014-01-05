//
//  GameTests.m
//  CloseUp
//
//  Created by Fede on 25/03/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CloseUpAppDelegate.h"
#import "OCMockObject.h"
#import "DBHelper.h"
#import "GameStore.h"

@interface CloseUpAppDelegateTests : SenTestCase {
    CloseUpAppDelegate *appDelegate;
    NSFileManager *fileManager;
    NSString *dbDirectoryPath;
    NSString *dbFileNamePath;
}
@end

@implementation CloseUpAppDelegateTests

- (void)setUp {
    appDelegate = [[CloseUpAppDelegate alloc] init];
    fileManager = [[NSFileManager alloc] init];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    dbDirectoryPath = [paths objectAtIndex:0];
    dbFileNamePath = [dbDirectoryPath stringByAppendingPathComponent:@"closeup.sqlite"];
}

- (void)tearDown {
    [fileManager removeItemAtPath:dbFileNamePath error:NULL];
    [appDelegate release];
    [fileManager release];
}


- (void)testCopyDatabaseToDocumentsDirectory {
    BOOL fileExists = [fileManager fileExistsAtPath:dbFileNamePath];
    STAssertFalse(fileExists, @"CloseUp DB expected not to exist.");

    [appDelegate copyDatabaseToDocumentsDirectory];

    fileExists = [fileManager fileExistsAtPath:dbFileNamePath];
    STAssertTrue(fileExists, @"CloseUp DB expected to exist.");
}

- (void)testDatabaseExistsInDocumentsDirectory {
    STAssertFalse([appDelegate databaseExistsInDocumentsDirectory], @"CloseUp DB expected not to exist.");

    [appDelegate copyDatabaseToDocumentsDirectory];

    STAssertTrue([appDelegate databaseExistsInDocumentsDirectory], @"CloseUp DB expected not to exist.");
}

- (void)testSaveGameWhenApplicationDidEnterBackground {
    Game *game = [[[Game alloc] init] autorelease];
    [GameStore setSharedInstance:game];

    id dbManager = [OCMockObject mockForClass:[GameDAO class]];
    [appDelegate setGameDAO:dbManager];

    STAssertFalse([game suspended], @"Expected game not suspended");

    [[dbManager expect] saveGame:game];

    [appDelegate applicationDidEnterBackground:nil];

    [dbManager verify];
    STAssertTrue([game suspended], @"Expected game suspended");
}

- (void)testDoNotSaveFinishedGameWhenApplicationDidEnterBackground {
    Game *game = [[[Game alloc] init] autorelease];
    [game setFinished:true];
    [GameStore setSharedInstance:game];

    id dbManager = [OCMockObject mockForClass:[GameDAO class]];
    [appDelegate setGameDAO:dbManager];

    STAssertFalse([game suspended], @"Expected game not suspended");

    [appDelegate applicationDidEnterBackground:nil];

    [dbManager verify];
    STAssertFalse([game suspended], @"Expected game suspended");
}

- (void)testReplaceDBWhenUpdatedFromVersion_1_0 {
    NSString *name = @"closeup_1_0.sqlite";
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:nil];

    [fileManager removeItemAtPath:dbFileNamePath error:nil];//remove the file just added by the setup method.
    [fileManager copyItemAtPath:path toPath:dbFileNamePath error:nil];

    UIApplication *application = [OCMockObject mockForClass:[UIApplication class]];
    [appDelegate applicationDidFinishLaunching:application];

    NSString *const aboutTable = @"about";
    STAssertEquals(1, [DBHelper countRowsOnTable:dbFileNamePath tableName:aboutTable], @"Database not updated to new version");
    STAssertEqualObjects(@"2.0", [DBHelper stringColumnValueOnFirstRowForTable:dbFileNamePath tableName:aboutTable columnName:@"db_version"], @"Database not updated to new version");
}


@end
