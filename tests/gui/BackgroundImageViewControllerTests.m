//
//  BackgroundImageViewControllerTests.m
//  CloseUp
//
//  Created by Federico Lopez Laborda on 3/17/12.
//  Copyright (c) 2012 FLL. All rights reserved.
//

#import "BackgroundImageViewController.h"
#import "OCMockObject.h"

#import <SenTestingKit/SenTestingKit.h>

@interface BackgroundImageViewControllerTests : SenTestCase {
    BackgroundImageViewController *backgroundImageVC;
    id delegate;
}

@end


@implementation BackgroundImageViewControllerTests

- (void)setUp {
    backgroundImageVC = [[BackgroundImageViewController alloc] initBackgroundImageViewController];
    Question *question = [[[Question alloc] init] autorelease];
    [question setImageName:@"A0DHDN.jpg"];
    [backgroundImageVC setQuestion:question];

    delegate = [OCMockObject mockForProtocol:@protocol(BackgroundImageViewControllerDelegate)];
    [backgroundImageVC setDelegate:delegate];
}

- (void)tearDown {
    [backgroundImageVC release];
}

- (void)testTouchesEnded {
    [[delegate expect] resumeGame];

    [backgroundImageVC touchesEnded:nil withEvent:nil];

    [delegate verify];
}

- (void)testEndGameRequested {
    [[delegate expect] endGameRequested];

    [backgroundImageVC endGameRequested:nil];

    [delegate verify];
}


@end
