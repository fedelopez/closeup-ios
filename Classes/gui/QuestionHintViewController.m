//
//  QuestionHintViewController.m
//  CloseUp
//
//  Created by Fede on 30/06/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "QuestionHintViewController.h"

@implementation QuestionHintViewController

@synthesize question;
@synthesize questionIndexTitle;
@synthesize delegate;

- (id)initWithQuestion:(Question *)theQuestion {
    self = self = [super init];
    if (self) {
        [self setQuestion:theQuestion];
    }
    return self;
}

- (void)viewDidLoad {
    [self.view setBackgroundColor:[UIColor clearColor]];
    questionTitleImage = [NSString stringWithFormat:@"question%d.png", question.displayIndex];
    questionIndexTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:questionTitleImage]];
    [self.view addSubview:questionIndexTitle];
    questionIndexTitle.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 3, 0, 0);
    [questionIndexTitle setHidden:YES];
}


- (void)animateQuestionHint {
    UIImage *image = [UIImage imageNamed:questionTitleImage];
    int x = (int) questionIndexTitle.frame.origin.x - (int) (image.size.width / 2);
    int y = (int) questionIndexTitle.frame.origin.y - (int) image.size.height;

    [questionIndexTitle setHidden:NO];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.9];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    questionIndexTitle.frame = CGRectMake(x, y, image.size.width, image.size.height);
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(hideQuestionHintStartAnimation:) userInfo:nil repeats:NO];
}

- (void)hideQuestionHintStartAnimation:(NSTimer *)timer {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(animationStopped:finished:context:)];
    questionIndexTitle.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)animationStopped:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [questionIndexTitle setHidden:TRUE];
    [delegate questionHintAnimationEnded];
}

- (void)dealloc {
    [question release];
    [questionIndexTitle release];
    [super dealloc];
}

@end
