//
//  Created by fede on 1/23/13.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import "GameOverViewController.h"


@implementation GameOverViewController

@synthesize gameOverView;
@synthesize gameOver;
@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        self.gameOver = [UIImage imageNamed:@"game-over.png"];
        self.gameOverView = [[[UIImageView alloc] initWithImage:gameOver] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat x = rect.size.width / 2;
    CGFloat y = rect.size.height / 2;
    CGRect frame = CGRectMake(x, y, 0, 0);
    [gameOverView setFrame:frame];

    [self.view addSubview:gameOverView];

    void (^completion)(BOOL) = ^(BOOL b) {
        [self gameOverDisplayed];
    };
    void (^animations)() = ^{
        [gameOverView setFrame:CGRectMake(x - (gameOver.size.width / 2), y - (gameOver.size.height / 2), gameOver.size.width, gameOver.size.height)];
    };
    [UIView animateWithDuration:2.5 animations:animations completion:completion];
}

- (void)gameOverDisplayed {
    [delegate gameOverAppearedOnScreen];
}


- (void)dealloc {
    [gameOverView release];
    [gameOver release];
    [delegate release];
    [super dealloc];
}


@end