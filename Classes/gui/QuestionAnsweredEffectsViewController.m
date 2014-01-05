//
//  Created by fede on 11/16/11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QuestionAnsweredEffectsViewController.h"


@implementation QuestionAnsweredEffectsViewController

@synthesize delegate;


- (id)initWithOutcome:(QuestionOutcome)questionOutcome {
    self = [super init];
    if (self) {
        kQuestionOutcome = questionOutcome;
        outcomeView = [[UIImageView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    CGRect frameSize = [[UIScreen mainScreen] bounds];
    outcomeView.frame = CGRectMake(frameSize.size.width / 2, frameSize.size.height / 2, 0, 0);
    [self.view addSubview:outcomeView];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)animate {
    NSString *imageName = nil;
    switch (kQuestionOutcome) {
        case kIsCorrect:
            imageName = @"is-correct.png";
            break;
        case kIsWrong:
            imageName = @"is-wrong.png";
            break;
        case kTimedUp:
            imageName = @"timesup.png";
            break;
    }
    UIImage *image = [UIImage imageNamed:imageName];
    [outcomeView setImage:image];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(outcomeAnimationEnded:)];
    CGRect frameSize = [[UIScreen mainScreen] bounds];
    CGSize imageSize = image.size;
    CGFloat x = (frameSize.size.width - imageSize.width) / 2;
    CGFloat y = (frameSize.size.height - imageSize.height) / 2;
    outcomeView.frame = CGRectMake(x, y, imageSize.width, imageSize.height);
    [UIView commitAnimations];

}

- (void)outcomeAnimationEnded:(id)outcomeAnimationEnded {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(animationStopped:finished:context:)];
    outcomeView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)animationStopped:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [delegate questionAnsweredEffectsAnimationEnded:self];
}


- (void)dealloc {
    [outcomeView release];
    [super dealloc];
}

@end