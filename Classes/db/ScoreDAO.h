//
//  Created by fede on 7/5/12.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Score.h"
#import "Stats.h"
#import "AbstractDAO.h"

@interface ScoreDAO : AbstractDAO {

}

- (void)saveScore:(Score *)score;

- (NSArray *)loadHighScores;

- (BOOL)isHighScore:(Score *)score;

- (Stats *)loadStats;


@end