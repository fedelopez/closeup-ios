//
//  Created by fede on 10/20/12.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "Game.h"
#import "GameStore.h"

@interface GameStoreTests : SenTestCase {
    Game *game;
}
@end

@implementation GameStoreTests

- (void)setUp {
    Question *question = [[[Question alloc] init] autorelease];
    [question setQuestionId:1];
    [question setCorrectAnswer:@"Burbank, LA"];

    NSArray *questions = [[NSArray alloc] initWithObjects:question, nil];
    game = [[Game alloc] initWithQuestions:questions gameMode:STRAIGHT_10];
    [questions release];
}

- (void)tearDown {
    [game release];
    [GameStore setSharedInstance:nil];
}

- (void)testGetSharedInstanceInitialisedNil {
    Game *instance = [GameStore getSharedInstance];
    STAssertNil(instance, @"Game stored");
}

- (void)testGetSharedInstance {
    [GameStore setSharedInstance:game];
    Game *instance = [GameStore getSharedInstance];
    STAssertEqualObjects(game, instance, @"Game stored");
}

- (void)testGetSharedInstanceNotRetained {
    NSUInteger one = 1;
    STAssertEquals(one, [game retainCount], @"Wrong reqtain count");
    [GameStore setSharedInstance:game];
    STAssertEquals(one, [game retainCount], @"Wrong reqtain count");
}

- (void)testSetNullSharedInstance {
    [GameStore setSharedInstance:nil];
    STAssertNil([GameStore getSharedInstance], @"Game not null");
}

@end