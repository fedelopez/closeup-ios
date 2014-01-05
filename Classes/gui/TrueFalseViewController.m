//
//  TrueFalseViewController.m
//  CloseUp
//
//  Created by Fede on 10/04/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "TrueFalseViewController.h"

@implementation TrueFalseViewController

- (void)viewDidLoad {
    [self initButtons];
    [super viewDidLoad];
}

- (void)initButtons {
    UIImage *defaultImage = [UIImage imageNamed:@"true-unselected.png"];
    CGFloat width = defaultImage.size.width;
    CGFloat height = defaultImage.size.height;

    int yOffset = 8;
    CGSize size = [[UIScreen mainScreen] bounds].size;

    CGFloat halfWidth = size.width / 4;
    CGFloat xLeft = halfWidth - (width / 2);
    CGFloat yLeft = halfWidth * 3 - (width / 2);
    CGFloat yTop = size.height - yOffset - height;

    trueButton = [[UIButton alloc] initWithFrame:CGRectMake(xLeft, yTop, width, height)];
    [trueButton setBackgroundImage:defaultImage forState:UIControlStateNormal];
    [trueButton setBackgroundImage:[UIImage imageNamed:@"true-selected.png"] forState:UIControlStateHighlighted];
    [trueButton.titleLabel setText:@"TRUE"];

    falseButton = [[UIButton alloc] initWithFrame:CGRectMake(yLeft, yTop, width, height)];
    [falseButton setBackgroundImage:[UIImage imageNamed:@"false-unselected.png"] forState:UIControlStateNormal];
    [falseButton setBackgroundImage:[UIImage imageNamed:@"false-selected.png"] forState:UIControlStateHighlighted];
    [falseButton.titleLabel setText:@"FALSE"];

    for (UIButton *button in [self subViewElementsToAnimate]) {
        [button.titleLabel setTextColor:[UIColor clearColor]];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (NSMutableArray *)subViewElementsToAnimate {
    NSMutableArray *elements = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
    [elements addObject:trueButton];
    [elements addObject:falseButton];
    return elements;
}

- (void)dealloc {
    [trueButton release];
    [falseButton release];
    [super dealloc];
}


@end
