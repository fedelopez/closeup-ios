//
//  CloseUpAppDelegate.m
//  CloseUp
//
//  Created by Fede on 9/01/10.
//  Copyright FLL 2010. All rights reserved.
//

#import "CloseUpAppDelegate.h"
#import "GameStore.h"

@implementation CloseUpAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize gameDAO;
@synthesize scoreDAO;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self gameCenterAuthenticate];
    return true;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    NSString *documentsDirectory = [self documentsDirectory];
    NSLog(@"Documents directory: %@", documentsDirectory);

    NSString *databaseFilePath = [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
    gameDAO = [[GameDAO alloc] initWithDbFileName:databaseFilePath];
    scoreDAO = [[ScoreDAO alloc] initWithDbFileName:databaseFilePath];

    BOOL databaseExists = [self databaseExistsInDocumentsDirectory];
    if (!databaseExists || [self isLegacyDatabase]) {
        [self copyDatabaseToDocumentsDirectory];
    }

    GameManager *gameManager = [[[GameManager alloc] initGameManager:navigationController] autorelease];
    [gameManager setGameDAO:gameDAO];

    LandingViewController *landingViewController = (LandingViewController *) [navigationController topViewController];
    [landingViewController setGameDAO:gameDAO];
    [landingViewController setScoreDAO:scoreDAO];
    [landingViewController setGameManager:gameManager];

    [navigationController setNavigationBarHidden:YES animated:NO];
    [navigationController setToolbarHidden:YES animated:NO];
    [navigationController setNeedsStatusBarAppearanceUpdate];
    navigationController.edgesForExtendedLayout = UIRectEdgeNone;

    [self.window setRootViewController:landingViewController];
    [self.window addSubview:[navigationController view]];
    [self.window makeKeyAndVisible];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    Game *game = [GameStore getSharedInstance];
    if (game && ![game finished]) {
        [game setSuspended:true];//the app was suspended while playing the game (otherwise game variable would have been set to null)
        [gameDAO saveGame:game];
        [GameStore setSharedInstance:nil];
    }
}

- (BOOL)isLegacyDatabase {
    BOOL isLegacy = [[gameDAO databaseVersion] isEqualToString:LEGACY_DB_VERSION];
    if (isLegacy) {
        NSLog(@"Legacy DB detected, about to be replaced.");
    }
    return isLegacy;
}

- (void)copyDatabaseToDocumentsDirectory {
    NSLog(@"Copying DB...");
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    NSString *source = [thisBundle pathForResource:DATABASE_NAME ofType:nil];
    NSString *destination = [[self documentsDirectory] stringByAppendingPathComponent:DATABASE_NAME];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtPath:destination error:nil];
    [fileManager copyItemAtPath:source toPath:destination error:NULL];
    [fileManager release];
}

- (BOOL)databaseExistsInDocumentsDirectory {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *databaseFilePath = [[self documentsDirectory] stringByAppendingPathComponent:DATABASE_NAME];
    BOOL exists = [fileManager fileExistsAtPath:databaseFilePath];
    [fileManager release];
    if (exists) {
        NSLog(@"Database exists on documents dir: %@", databaseFilePath);
    }
    return exists;
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (void)gameCenterAuthenticate {
    if (![[GKLocalPlayer localPlayer] isAuthenticated]) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Could not authenticate player to Game Center: %@", [error localizedDescription]);
            } else {
                NSLog(@"Player authenticated on Game Center");
            }
        }];
    }
}

- (void)dealloc {
    [navigationController release];
    [window release];
    [gameDAO release];
    [scoreDAO release];
    [super dealloc];
}

@end
