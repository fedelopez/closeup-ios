//
//  QuestionViewController.m
//  CloseUp
//
//  Created by Fede on 27/01/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "QuestionViewController.h"

@implementation QuestionViewController

@synthesize backgroundImageView;
@synthesize questionLabel, questionLabelImageView, questionFrame;
@synthesize question;
@synthesize questionHintVC;
@synthesize delegate;
@synthesize progressViewController;

- (id)initWithQuestion:(Question *)theQuestion {
    self = [super init];
    if (self) {
        [self setQuestion:theQuestion];
        questionHintVC = [[QuestionHintViewController alloc] initWithQuestion:question];
    }
    return self;
}

- (void)startQuestionOutcomeAnimation:(QuestionOutcome)outcome {
    QuestionAnsweredEffectsViewController *questionAnsweredEffectsViewController = [[QuestionAnsweredEffectsViewController alloc] initWithOutcome:outcome];
    questionAnsweredEffectsViewController.delegate = self;
    [self.view addSubview:questionAnsweredEffectsViewController.view];
    [questionAnsweredEffectsViewController animate];
    [questionAnsweredEffectsViewController release];
}

- (void)questionAnsweredEffectsAnimationEnded:(id)viewController {
    [self.view setUserInteractionEnabled:true];
    QuestionAnsweredEffectsViewController *questionAnsweredEffectsViewController = viewController;
    [questionAnsweredEffectsViewController.view removeFromSuperview];
    if (![question timedUp] && ![question isCorrect]) {
        [progressViewController animateLivesRemaining];
    }
    [delegate questionAnswered:question];
}

- (void)decorateWithOutcomeTag:(UIButton *)button answered:(NSString *)answered {
    CGRect position = button.frame;
    UIImage *outcomeTag = [answered isEqualToString:[question correctAnswer]] ? [UIImage imageNamed:@"tick.png"] : [UIImage imageNamed:@"cross.png"];
    UIImageView *outcomeTagView = [[[UIImageView alloc] initWithImage:outcomeTag] autorelease];
    CGRect outcomeTagPosition = CGRectMake(position.origin.x + 2 * (position.size.width / 3), position.origin.y - (outcomeTag.size.height / 3), outcomeTag.size.width, outcomeTag.size.height);
    outcomeTagView.frame = outcomeTagPosition;

    [circleView removeFromSuperview];
    [self.view addSubview:outcomeTagView];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    NSArray *buttons = [self subViewElementsToAnimate];
    for (UIButton *button in buttons) {
        NSArray *array = [question userAnswers];
        for (NSString *answered in array) {
            if ([answered isEqualToString:[button.titleLabel text]]) {
                [self decorateWithOutcomeTag:button answered:answered];
            }
        }
    }
    QuestionOutcome outcome = [question isCorrect] ? kIsCorrect : kIsWrong;
    [self startQuestionOutcomeAnimation:outcome];
}

- (void)animateButtonWithOval:(UIButton *)button {
    CAKeyframeAnimation *roundRectAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    roundRectAnimation.duration = 2;
    roundRectAnimation.repeatCount = 3;
    roundRectAnimation.calculationMode = kCAAnimationPaced;
    roundRectAnimation.speed = 1.8;
    roundRectAnimation.delegate = self;
    CGRect rect = button.frame;
    roundRectAnimation.path = [UIBezierPath bezierPathWithOvalInRect:rect].CGPath;
    [circleView.layer addAnimation:roundRectAnimation forKey:@"animateButton"];
}

- (IBAction)answer:(id)sender {
    [progressViewController pause];
    [self.view setUserInteractionEnabled:false];

    UIButton *button = (UIButton *) sender;
    [button setEnabled:false];
    [question answer:[button titleLabel].text];

    UIImage *circleImg = [UIImage imageNamed:@"circle.png"];
    circleView = [[UIImageView alloc] initWithImage:circleImg];
    [circleView setAlpha:0.8];

    CGRect frame = CGRectMake(button.frame.origin.x + 2 * (button.frame.size.width / 3), button.frame.origin.y - (circleImg.size.height / 2) + 3, circleImg.size.width, circleImg.size.height);
    circleView.frame = frame;
    [self.view addSubview:circleView];

    [self animateButtonWithOval:button];
}

- (NSMutableArray *)subViewElementsToAnimate {
    return nil;
}

- (void)animateQuestionHint {
    questionHintVC.delegate = self;
    [self.view insertSubview:questionHintVC.view atIndex:[self.view.subviews count]];
    [questionHintVC animateQuestionHint];
}

- (void)questionHintAnimationEnded {
    [questionHintVC.view removeFromSuperview];
    [UIView beginAnimations:@"AnimateQuestionFrame" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(animateQuestionLabel)];
    questionFrame.alpha = 0.3;
    [UIView commitAnimations];
}

- (void)animateQuestionLabel {
    [UIView beginAnimations:@"AnimateQuestionTitle" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(animateSubViews)];
    questionLabel.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)animateSubViews {
    if ([animatedSubViews count] == 0) {
        return;
    }
    NSTimeInterval delay = 2;
    if (animatedSubViewsInitialSize != [animatedSubViews count]) {
        delay = 1;
    }
    UIView *nextSubView = [animatedSubViews objectAtIndex:0];
    [animatedSubViews removeObjectAtIndex:0];
    [UIView beginAnimations:@"AnimateSubView" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(animateSubViews)];
    nextSubView.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)viewDidLoad {
    int viewIndex = 0;

    UIImage *imageFrame = [UIImage imageNamed:@"picture-background.png"];
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    backgroundImageFrameView = [[UIImageView alloc] initWithFrame:applicationFrame];
    backgroundImageFrameView.image = imageFrame;
    [self.view insertSubview:backgroundImageFrameView atIndex:viewIndex++];

    int xOffset = 7;
    int yOffset = 8;
    CGRect enclosingRect = backgroundImageFrameView.frame;
    CGSize size = CGSizeMake(enclosingRect.size.width - (2 * xOffset), enclosingRect.size.height - (2 * yOffset));
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, enclosingRect.origin.y + yOffset, size.width, size.height)];
    backgroundImageView.image = [UIImage imageNamed:[question imageName]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    [self.view insertSubview:backgroundImageView atIndex:viewIndex++];

    CGRect rect = progressViewController.view.frame;
    rect = CGRectMake(rect.origin.x, applicationFrame.origin.y + yOffset, rect.size.width, rect.size.height);
    progressViewController.view.frame = rect;
    [self.view insertSubview:progressViewController.view atIndex:viewIndex];

    int y = [self questionFrameYPosition:size];
    questionFrame = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset - 1, y, 306, 91)];
    questionFrame.alpha = 0.3;
    questionFrame.image = [UIImage imageNamed:@"question-overlay.png"];
    [self.view addSubview:questionFrame];

    questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + 2, y + 4, 301, 82)];
    questionLabel.text = [question question];
    int fontSize = [[question question] length] > 80 ? 12 : 14;
    questionLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:fontSize];
    questionLabel.textColor = [UIColor whiteColor];
    questionLabel.textAlignment = NSTextAlignmentCenter;
    questionLabel.backgroundColor = [UIColor clearColor];
    questionLabel.numberOfLines = 4;
    [self.view addSubview:questionLabel];

    if (![question appearedOnScreen]) {
        [self prepareViewsForQuestionTitleAnimation];
        [self animateQuestionHint];
    }
}

- (int)questionFrameYPosition:(CGSize)size {
    return (int) (size.height * (size.height == 568 ? 0.63 : 0.56));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [question setAppearedOnScreen:TRUE];
    [self.view bringSubviewToFront:progressViewController.view];
    [progressViewController start];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [progressViewController pause];
    [delegate pauseGame:question];
}

- (void)prepareViewsForQuestionTitleAnimation {
    questionLabel.alpha = 0.0;
    questionFrame.alpha = 0.0;
    animatedSubViews = [[self subViewElementsToAnimate] retain];
    animatedSubViewsInitialSize = [animatedSubViews count];
    for (UIView *element in animatedSubViews) {
        element.alpha = 0;
    }
}

- (void)resumeTimeIndicator {
    [progressViewController start];
}

- (void)timesUp {
    [question setTimedUp:TRUE];
    [self.view setUserInteractionEnabled:false];
    [self startQuestionOutcomeAnimation:kTimedUp];
}

- (void)dealloc {
    [questionHintVC release];
    [animatedSubViews release];
    [backgroundImageView release];
    [questionLabel release];
    [questionLabelImageView release];
    [question release];
    [questionFrame release];
    [backgroundImageFrameView release];
    [delegate release];
    [progressViewController release];
    [super dealloc];
}

@end
