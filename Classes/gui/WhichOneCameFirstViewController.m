//
//  WhichOneCameFirstViewController.m
//  CloseUp
//
//  Created by Fede on 9/01/11.
//  Copyright 2011 FLL. All rights reserved.
//

#import "WhichOneCameFirstViewController.h"
#import "WhichOneCameFirst.h"

@implementation WhichOneCameFirstViewController

- (void)viewDidLoad {
    [self initImageFrames];
    [self initButtons];

    WhichOneCameFirst *whichOneCameFirst = (WhichOneCameFirst *) [self question];

    [movieTitle1Button setTitle:[whichOneCameFirst movieTitle1] forState:UIControlStateNormal];
    [movieTitle2Button setTitle:[whichOneCameFirst movieTitle2] forState:UIControlStateNormal];

    [movieTitle1Button setTitle:[whichOneCameFirst movieTitle1] forState:UIControlStateSelected];
    [movieTitle2Button setTitle:[whichOneCameFirst movieTitle2] forState:UIControlStateSelected];

    [movie1Image setImage:[UIImage imageNamed:[whichOneCameFirst movieTitle1ImageName]]];
    [movie2Image setImage:[UIImage imageNamed:[whichOneCameFirst movieTitle2ImageName]]];

    [super viewDidLoad];
}

- (void)initImageFrames {
    UIImageView *movie2Frame = [[UIImageView alloc] initWithFrame:CGRectMake(128, 68, 180, 265)];
    [movie2Frame setImage:[UIImage imageNamed:@"which-one-came-first.png"]];
    [self.view addSubview:movie2Frame];
    [movie2Frame release];

    movie2Image = [[UIImageView alloc] initWithFrame:CGRectMake(133, 73, 170, 255)];
    [self.view addSubview:movie2Image];

    UIImageView *movie1Frame = [[UIImageView alloc] initWithFrame:CGRectMake(12, 166, 180, 265)];
    [movie1Frame setImage:[UIImage imageNamed:@"which-one-came-first.png"]];
    [self.view addSubview:movie1Frame];
    [movie1Frame release];

    movie1Image = [[UIImageView alloc] initWithFrame:CGRectMake(17, 171, 170, 255)];
    [self.view addSubview:movie1Image];
}

- (void)initButtons {
    UIImage *defaultImage = [UIImage imageNamed:@"button-default.png"];
    CGFloat width = defaultImage.size.width;
    CGFloat height = defaultImage.size.height;

    int yOffset = 8;
    CGSize size = [[UIScreen mainScreen] bounds].size;

    CGFloat halfWidth = size.width / 2;
    CGFloat xLeft = halfWidth - width;
    CGFloat yTop = size.height - yOffset - height;
    movieTitle1Button = [[UIButton alloc] initWithFrame:CGRectMake(xLeft, yTop, width, height)];
    movieTitle2Button = [[UIButton alloc] initWithFrame:CGRectMake(halfWidth, yTop, width, height)];

    for (UIButton *button in [self subViewElementsToAnimate]) {
        [button setBackgroundImage:defaultImage forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button-tapped.png"] forState:UIControlStateHighlighted];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button.titleLabel setNumberOfLines:0];
        [button.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        UIFont *font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
        button.titleLabel.font = font;
        [self.view addSubview:button];
        [button addTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (NSMutableArray *)subViewElementsToAnimate {
    NSMutableArray *elements = [[NSMutableArray alloc] initWithCapacity:2];
    [elements addObject:movieTitle1Button];
    [elements addObject:movieTitle2Button];
    return elements;
}

- (void)dealloc {
    [movieTitle1Button release];
    [movieTitle2Button release];
    [movie1Image release];
    [movie2Image release];
    [super dealloc];
}


@end
