//
//  HighScoresTable.m
//  CloseUp
//
//  Created by Fede on 4/06/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "HighScoresViewController.h"
#import "Effects.h"
#import "GameDAO.h"

@implementation HighScoresViewController

@synthesize scores, gameCenterScores, stats, table, scoreCell, averageLabel, accuracyLabel, trendImageView, switchPersonalBest, switchGameCenter;

- (id)initWithScores:(NSArray *)theScores theGameCenterScores:(NSMutableDictionary *)theGameCenterScores theStats:(Stats *)theStats {
    if ((self = [super initWithNibName:@"HighScoresViewController" bundle:[NSBundle mainBundle]])) {
        self.scores = theScores;
        self.gameCenterScores = theGameCenterScores;
        self.stats = theStats;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [switchGameCenter setSelected:[gameCenterScores count] > 0];
    [switchGameCenter setEnabled:[gameCenterScores count] > 0];
    [switchPersonalBest setSelected:![gameCenterScores count] > 0];

    [switchPersonalBest setImage:[UIImage imageNamed:@"scores-game-center-pb-pressed.png"] forState:UIControlStateHighlighted];
    [switchPersonalBest setImage:[UIImage imageNamed:@"scores-game-center-pb-unselected.png"] forState:UIControlStateNormal];
    [switchPersonalBest setImage:[UIImage imageNamed:@"scores-game-center-pb.png"] forState:UIControlStateSelected];

    [switchGameCenter setImage:[UIImage imageNamed:@"scores-game-center-top5-pressed.png"] forState:UIControlStateHighlighted];
    [switchGameCenter setImage:[UIImage imageNamed:@"scores-game-center-top5.png"] forState:UIControlStateSelected];
    [switchGameCenter setImage:[UIImage imageNamed:@"scores-game-center-top5-unselected.png"] forState:UIControlStateNormal];

    averageLabel.text = [NSString stringWithFormat:@"%d/%d", stats.average, TOTAL_QUESTIONS_PER_GAME];
    accuracyLabel.text = [[NSString stringWithFormat:@"%d", stats.accuracy] stringByAppendingString:@"%"];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"high-scores-background.png"]]];

    [self initTrend];
}

- (void)initTrend {
    if ([stats trend] == NONE) {
        [self.trendImageView setImage:nil];
    } else if ([stats trend] == UP) {
        [self.trendImageView setImage:[UIImage imageNamed:@"trend_up.png"]];
    } else if ([stats trend] == LEVEL) {
        [self.trendImageView setImage:[UIImage imageNamed:@"trend_level.png"]];
    } else {
        [self.trendImageView setImage:[UIImage imageNamed:@"trend_down.png"]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger size = [self tableSize];
    return size == 0 ? 1 : size;
}

- (NSInteger)tableSize {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreCell"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"HighScoresCell" owner:self options:nil];
        cell = scoreCell;
        scoreCell = nil;
    }
    NSString *noScoresAvailable = indexPath.row == 0 ? @"No available scores" : @"";
    if ([switchPersonalBest isSelected]) {
        if (indexPath.row >= [scores count]) {
            [self fillTableCell:indexPath cell:cell heroText:noScoresAvailable northText:@"" southText:@""];
        } else {
            Score *currentScore = [scores objectAtIndex:indexPath.row];
            ScoreCellDecorator *cellDecorator = [[[ScoreCellDecorator alloc] initWithScore:currentScore index:(indexPath.row + 1)] autorelease];
            [self fillTableCell:indexPath cell:cell heroText:[cellDecorator textForDateLabel] northText:[cellDecorator textForPointsLabel] southText:[cellDecorator textForTotalLabel]];
        }
    } else if ([switchGameCenter isSelected]) {
        NSArray *gameCenterPlayersOrdered = [self sortedScores];
        if (indexPath.row >= [gameCenterPlayersOrdered count]) {
            [self fillTableCell:indexPath cell:cell heroText:noScoresAvailable northText:@"" southText:@""];
        } else {
            NSString *player = [gameCenterPlayersOrdered objectAtIndex:indexPath.row];
            GKScore *gkScore = [gameCenterScores valueForKey:player];
            Score *score = [[[Score alloc] init] autorelease];
            [score setPoints:[gkScore value]];
            [score setDate:[gkScore date]];
            ScoreCellDecorator *cellDecorator = [[[ScoreCellDecorator alloc] initWithScore:score index:(indexPath.row + 1)] autorelease];
            [self fillTableCell:indexPath cell:cell heroText:[self playerName:player score:gkScore] northText:[cellDecorator textForPointsLabel] southText:[cellDecorator textForDateLabel]];
        }
    }
    return cell;
}

- (NSString *)playerName:(NSString *)player score:(GKScore *)gkScore {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if ([localPlayer isAuthenticated] && [[localPlayer playerID] isEqualToString:[gkScore playerID]]) {
        return @"You :-)";
    }
    return player;
}

- (void)fillTableCell:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell heroText:(NSString *)heroText northText:(NSString *)northText southText:(NSString *)southText {

    UILabel *heroLabel = (UILabel *) [cell viewWithTag:10];
    UILabel *northLabel = (UILabel *) [cell viewWithTag:20];
    UILabel *southLabel = (UILabel *) [cell viewWithTag:30];

    if ([self tableSize] == 0) {
        [heroLabel setTextColor:[UIColor grayColor]];
    } else {
        [heroLabel setTextColor:[UIColor blackColor]];
    }
    [heroLabel setText:heroText];
    [northLabel setText:northText];
    [southLabel setText:southText];
    if ((indexPath.row % 2) != 0) {
        [cell setBackgroundColor:[Effects tigerStripes]];
    } else {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
}

- (NSArray *)sortedScores {
    return [gameCenterScores keysSortedByValueUsingComparator:^(id obj1, id obj2) {
        if ([obj1 rank] > [obj2 rank]) {
            return (NSComparisonResult) NSOrderedDescending;
        }
        if ([obj1 rank] < [obj2 rank]) {
            return (NSComparisonResult) NSOrderedAscending;
        }
        return (NSComparisonResult) NSOrderedSame;
    }];
}

- (IBAction)showGameCenterScoresRequested:(id)sender {
    GKLeaderboardViewController *leaderBoardController = [[[GKLeaderboardViewController alloc] init] autorelease];
    if (leaderBoardController != nil) {
        leaderBoardController.leaderboardDelegate = self;
        [self presentViewController:leaderBoardController animated:YES completion:nil];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goToMainMenuRequested:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)gameCenterTop5Requested:(id)sender {
    if ([switchGameCenter isSelected]) {
        return;
    }
    [switchGameCenter setSelected:YES];
    [switchPersonalBest setSelected:NO];
    [table reloadData];

}

- (IBAction)personalBestRequested:(id)sender {
    if ([switchPersonalBest isSelected]) {
        return;
    }
    [switchGameCenter setSelected:NO];
    [switchPersonalBest setSelected:YES];
    [table reloadData];
}


- (void)dealloc {
    [switchPersonalBest release];
    [switchGameCenter release];
    [scores release];
    [gameCenterScores release];
    [stats release];
    [table release];
    [scoreCell release];
    [averageLabel release];
    [accuracyLabel release];
    [trendImageView release];
    [super dealloc];
}

@end

