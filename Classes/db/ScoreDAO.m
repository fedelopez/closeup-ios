//
//  Created by fede on 7/5/12.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import <sqlite3.h>
#import "ScoreDAO.h"
#import "SQLStatementHelper.h"


@implementation ScoreDAO {

}

- (void)saveScore:(Score *)score {
    if ([score points] == 0) {
        return;
    }
    NSString *insertIntoSQL = [SQLStatementHelper insertHighScoreSQL:score];
    [self executeStatement:insertIntoSQL];
}

- (NSArray *)loadHighScores {
    NSMutableArray *highScores = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
    sqlite3 *database;
    char *selectStatement = "select total_questions, correct_questions, points, date_game from high_scores order by points desc limit 5";
    if (sqlite3_open([dbFileName UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, selectStatement, -1, &statement, NULL) == SQLITE_OK) {

            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];

            while (sqlite3_step(statement) == SQLITE_ROW) {
                int statementIndex = 0;
                int totalQuestions = sqlite3_column_int(statement, statementIndex++);
                int correctQuestions = sqlite3_column_int(statement, statementIndex++);
                int points = sqlite3_column_int(statement, statementIndex++);
                NSString *dateString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, statementIndex++)];

                Score *score = [[Score alloc] init];
                [score setTotalQuestions:totalQuestions];
                [score setCorrectQuestions:correctQuestions];
                [score setPoints:points];
                [score setDate:[dateFormatter dateFromString:dateString]];

                [highScores addObject:score];
                [score release];
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return highScores;
}

- (BOOL)isHighScore:(Score *)score {
    const int maxScore = [self intResultForSql:@"select max(points) from high_scores"];
    NSLog(@"Max score from database: %d, user score: %d", maxScore, [score points]);
    return [score points] > maxScore;
}

- (Stats *)loadStats {
    Stats *stats = [[[Stats alloc] init] autorelease];
    [stats setTrend:NONE];
    sqlite3 *database;
    if (sqlite3_open([dbFileName UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        const char *accuracySQL = "select round((sum(correct_questions)*1.0/sum(total_questions)) * 100, 0) FROM high_scores";
        if (sqlite3_prepare_v2(database, accuracySQL, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                int accuracy = sqlite3_column_int(compiledStatement, 0);
                [stats setAccuracy:accuracy];
            }
        }
        sqlite3_finalize(compiledStatement);

        const char *averageSQL = "select round(avg(correct_questions), 0) from high_scores";
        if (sqlite3_prepare_v2(database, averageSQL, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                [stats setAverage:sqlite3_column_int(compiledStatement, 0)];
            }
        }
        sqlite3_finalize(compiledStatement);

        const char *trendSQL = "select correct_questions from high_scores order by high_score_id desc limit 2";
        if (sqlite3_prepare_v2(database, trendSQL, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                int first = sqlite3_column_int(compiledStatement, 0);
                int second = first;
                if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    second = sqlite3_column_int(compiledStatement, 0);
                }
                if (first == second) {
                    [stats setTrend:LEVEL];
                } else if (first < second) {
                    [stats setTrend:DOWN];
                } else {
                    [stats setTrend:UP];
                }
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    return stats;
}


@end