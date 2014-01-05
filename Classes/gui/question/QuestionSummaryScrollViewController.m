//
//  QuestionSummaryScrollViewController.m
//  CloseUp
//
//  Created by Federico Lopez Laborda on 12/18/11.
//  Copyright (c) 2011 FLL. All rights reserved.
//

#import "QuestionSummaryScrollViewController.h"
#import "QuestionSummaryViewController.h"

@implementation QuestionSummaryScrollViewController

@synthesize game;
@synthesize scroll;
@synthesize questionPageControl;

- (id)initQuestionSummaryScrollViewControllerWithGame:(Game *)theGame {
    self = [super initWithNibName:@"QuestionSummaryScrollView" bundle:[NSBundle mainBundle]];
    if (self) {
        [self setGame:theGame];
    }
    return self;
}

- (void)viewDidLoad {
    [self.view setBackgroundColor:[UIColor clearColor]];

    CGRect scrollFrame = scroll.frame;
    int capacity = [game numberOfQuestions] - [game numberOfUnansweredQuestions];
    scroll.contentSize = CGSizeMake(scrollFrame.size.width * capacity, scrollFrame.size.height);
    scroll.scrollsToTop = NO;
    [scroll setDelegate:self];

    for (Question *question in [game questions]) {
        if ([question appearedOnScreen]) {
            int index = [question displayIndex];
            QuestionSummaryViewController *questionSummaryVC = [[[QuestionSummaryViewController alloc] initWithQuestion:[game.questions objectAtIndex:index]] autorelease];
            CGRect frame = scroll.frame;
            frame.origin.x = frame.size.width * index;
            frame.origin.y = 0;
            questionSummaryVC.view.frame = frame;
            [scroll addSubview:questionSummaryVC.view];
        }
    }

    [questionPageControl setNumberOfPages:capacity];
    [questionPageControl setBackgroundColor:[UIColor clearColor]];
    [questionPageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];

    [super viewDidLoad];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = (int) (scrollView.contentOffset.x / scrollView.bounds.size.width);
    [questionPageControl setCurrentPage:index];
}

- (void)pageChanged:(UIPageControl *)thePageControl {
    NSInteger currentPage = [thePageControl currentPage];
    CGRect scrollFrame = scroll.frame;
    scrollFrame.origin.x = scrollFrame.size.width * currentPage;
    scrollFrame.origin.y = 0;
    [scroll scrollRectToVisible:scrollFrame animated:NO];
}


- (void)dealloc {
    [game release];
    [scroll release];
    [questionPageControl release];
    [super dealloc];
}

@end
