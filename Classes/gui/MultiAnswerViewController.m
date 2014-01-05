//
//  MultiAnswerViewController.m
//  CloseUp
//
//  Created by Fede on 27/01/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "MultiAnswerViewController.h"
#import "MultiAnswerQuestion.h"

@implementation MultiAnswerViewController

- (void)viewDidLoad {
    [self initButtons];

    MultiAnswerQuestion *multiAnswerQuestion = (MultiAnswerQuestion *) [self question];
    NSMutableArray *buttons = [self subViewElementsToAnimate];
    NSUInteger index = 0;
    for (NSString *answer in [multiAnswerQuestion possibleAnswers]) {
        UIButton *button = [buttons objectAtIndex:index++];
        [button setTitle:answer forState:UIControlStateNormal];
        [button setTitle:answer forState:UIControlStateSelected];
        UIFont *font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
        if ([answer length] > 35) {
            font = [font fontWithSize:10];
        }
        button.titleLabel.font = font;
        if ([[multiAnswerQuestion userAnswers] containsObject:answer]) {
            [button setEnabled:false];
            [self decorateWithOutcomeTag:button answered:answer];
        }
    }
    [super viewDidLoad];
}

- (void)initButtons {
    UIImage *defaultImage = [UIImage imageNamed:@"button-default.png"];
    CGFloat width = defaultImage.size.width;
    CGFloat height = defaultImage.size.height;

    int yOffset = 8;
    CGSize size = [[UIScreen mainScreen] bounds].size;

    CGFloat halfWidth = size.width / 2;
    CGFloat xLeft = halfWidth - width;
    CGFloat yTop = size.height - yOffset - (height * 2);
    CGFloat yBottom = size.height - yOffset - height;
    answer1Button = [[UIButton alloc] initWithFrame:CGRectMake(xLeft, yTop, width, height)];
    answer2Button = [[UIButton alloc] initWithFrame:CGRectMake(halfWidth, yTop, width, height)];
    answer3Button = [[UIButton alloc] initWithFrame:CGRectMake(xLeft, yBottom, width, height)];
    answer4Button = [[UIButton alloc] initWithFrame:CGRectMake(halfWidth, yBottom, width, height)];

    for (UIButton *button in [self subViewElementsToAnimate]) {
        [button setBackgroundImage:defaultImage forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button-tapped.png"] forState:UIControlStateHighlighted];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button.titleLabel setNumberOfLines:0];
        [button.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (NSMutableArray *)subViewElementsToAnimate {
    NSMutableArray *elements = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
    [elements addObject:answer1Button];
    [elements addObject:answer2Button];
    [elements addObject:answer3Button];
    [elements addObject:answer4Button];
    return elements;
}

- (void)dealloc {
    [answer1Button release];
    [answer2Button release];
    [answer3Button release];
    [answer4Button release];
    [super dealloc];
}


@end
