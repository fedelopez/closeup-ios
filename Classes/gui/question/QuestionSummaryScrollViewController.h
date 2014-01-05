//
//  QuestionSummaryScrollViewController.h
//  CloseUp
//
//  Created by Federico Lopez Laborda on 12/18/11.
//  Copyright (c) 2011 FLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface QuestionSummaryScrollViewController : UIViewController <UIScrollViewDelegate> {

    Game *game;

    UIScrollView *scroll;
    UIPageControl *questionPageControl;
}

@property(nonatomic, retain) IBOutlet UIScrollView *scroll;
@property(nonatomic, retain) IBOutlet UIPageControl *questionPageControl;
@property(nonatomic, retain) Game *game;

- (id)initQuestionSummaryScrollViewControllerWithGame:(Game *)theGame;

@end
