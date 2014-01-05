//
//  SQLStatementHelper.m
//  CloseUp
//
//  Created by Fede on 11/05/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "SQLStatementHelper.h"


@implementation SQLStatementHelper

+ (NSString *)insertGameSQL:(Game *)game {
    NSString *sql = @"insert into saved_game(saved_game_id, selected_question_index, remaining_lives, paused, remaining_seconds, game_mode, suspended) values('RESUMED', ?1, ?2, ?3, ?4, ?5, ?6)";
    sql = [sql stringByReplacingOccurrencesOfString:@"?1" withString:[NSString stringWithFormat:@"%d", game.currentQuestionIndex]];
    sql = [sql stringByReplacingOccurrencesOfString:@"?2" withString:[NSString stringWithFormat:@"%d", game.remainingLives]];
    sql = [sql stringByReplacingOccurrencesOfString:@"?3" withString:[NSString stringWithFormat:@"%d", game.paused]];
    sql = [sql stringByReplacingOccurrencesOfString:@"?4" withString:[NSString stringWithFormat:@"%d", (int) game.remainingSeconds]];
    sql = [sql stringByReplacingOccurrencesOfString:@"?5" withString:[NSString stringWithFormat:@"%d", (int) game.gameMode]];
    sql = [sql stringByReplacingOccurrencesOfString:@"?6" withString:[NSString stringWithFormat:@"%d", (int) game.suspended]];
    return sql;
}

+ (NSString *)insertQuestionSQL:(Question *)question {
    NSString *sql = @"insert into saved_game_question(saved_game_id, question_id, user_answer, question_index, appeared_on_screen)";
    sql = [sql stringByAppendingString:@" values('RESUMED', ?1, \"?2\", ?3, ?4)"];
    sql = [sql stringByReplacingOccurrencesOfString:@"?1" withString:[NSString stringWithFormat:@"%d", question.questionId]];
    if (![question isAnswered]) {
        sql = [sql stringByReplacingOccurrencesOfString:@"\"?2\"" withString:@"null"];
    } else {
        NSMutableString *answers = [[[NSMutableString alloc] init] autorelease];
        NSArray *userAnswers = [question userAnswers];
        NSUInteger count = 0;
        for (NSString *answer in userAnswers) {
            [answers appendFormat:@"{%@}", answer];
            count++;
            if (count < [userAnswers count]) {
                [answers appendString:@","];
            }
        }
        sql = [sql stringByReplacingOccurrencesOfString:@"?2" withString:answers];
    }
    sql = [sql stringByReplacingOccurrencesOfString:@"?3" withString:[NSString stringWithFormat:@"%d", question.displayIndex]];
    sql = [sql stringByReplacingOccurrencesOfString:@"?4" withString:[NSString stringWithFormat:@"%d", question.appearedOnScreen]];
    return sql;
}

+ (NSString *)selectMultiAnswerQuestionsSQL:(NSArray *)questionIds {
    NSString *sql = @"select q.question_id, q.image_name, q.correct_answer, q.question_text, q.difficulty, ma.answer1, ma.answer2, ma.answer3, ma.answer4";
    sql = [sql stringByAppendingString:@" from question q inner join multi_answer_question ma on q.question_id = ma.question_id"];
    sql = [sql stringByAppendingString:@" where q.question_id in ("];
    for (int i = 0; i < [questionIds count]; i++) {
        NSNumber *questionId = [questionIds objectAtIndex:i];
        if (i > 0) {
            sql = [sql stringByAppendingString:@", "];
        }
        sql = [sql stringByAppendingString:[questionId stringValue]];
    }
    sql = [sql stringByAppendingString:@")"];
    return sql;
}

+ (NSString *)selectTrueFalseQuestionsSQL:(NSArray *)questionIds {
    NSString *sql = @"select q.question_id, q.image_name, q.correct_answer, q.question_text, q.difficulty, tf.answer_when_false";
    sql = [sql stringByAppendingString:@" from question q inner join true_false_question tf on q.question_id = tf.question_id"];
    sql = [sql stringByAppendingString:@" where q.question_id in ("];
    for (int i = 0; i < [questionIds count]; i++) {
        NSNumber *questionId = [questionIds objectAtIndex:i];
        if (i > 0) {
            sql = [sql stringByAppendingString:@", "];
        }
        sql = [sql stringByAppendingString:[questionId stringValue]];
    }
    sql = [sql stringByAppendingString:@")"];
    return sql;
}

+ (NSString *)selectWhichOneCameFirstQuestionSQL:(NSString *)questionId {
    NSString *sql = @"select q.question_id, q.image_name, q.correct_answer, q.question_text, q.difficulty, w.movie_title1, w.movie_title2, w.movie_title1_image, w.movie_title2_image, w.movie_title1_year, w.movie_title2_year from question q";
    sql = [sql stringByAppendingString:@" inner join which_one_came_first w on q.question_id = w.question_id where q.question_id = "];
    return [sql stringByAppendingString:questionId];
}

+ (NSString *)updateNumberOfAppearancesSQL:(NSArray *)questionIds {
    NSString *sql = @"update question set number_appearances = number_appearances + 1 where question_id in (";
    for (int i = 0; i < [questionIds count]; i++) {
        int questionId = [(Question *) [questionIds objectAtIndex:i] questionId];
        if (i > 0) {
            sql = [sql stringByAppendingString:@", "];
        }
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%d", questionId]];
    }
    sql = [sql stringByAppendingString:@")"];
    return sql;
}

+ (NSString *)insertHighScoreSQL:(Score *)score {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[score date]];

    NSString *sql = @"insert into high_scores(total_questions, correct_questions, points, date_game) values(";
    sql = [sql stringByAppendingFormat:@"%d", [score totalQuestions]];
    sql = [sql stringByAppendingString:@", "];
    sql = [sql stringByAppendingFormat:@"%d", [score correctQuestions]];
    sql = [sql stringByAppendingString:@", "];
    sql = [sql stringByAppendingFormat:@"%d", [score points]];
    sql = [sql stringByAppendingString:@", date('"];
    sql = [sql stringByAppendingString:dateString];
    sql = [sql stringByAppendingString:@"'))"];
    return sql;
}

+ (NSString *)minNumberOfAppearancesForQuestionTableSQL:(NSString *)questionTable minNumAppearances:(int)minNumAppearances {
    NSString *sql = @"select ifnull(min(number_appearances), -1) from question parent inner join ? child on parent.question_id = child.question_id where parent.number_appearances > ";
    sql = [sql stringByReplacingOccurrencesOfString:@"?" withString:questionTable];
    sql = [sql stringByAppendingFormat:@"%d", minNumAppearances];
    return sql;
}

+ (NSString *)countNumberOfQuestionsWithNumberOfAppearancesSQL:(NSString *)questionTable numAppearances:(int)numAppearances {
    NSString *sql = @"select count(1) from question parent inner join ? child on parent.question_id = child.question_id where parent.number_appearances = ";
    sql = [sql stringByReplacingOccurrencesOfString:@"?" withString:questionTable];
    sql = [sql stringByAppendingFormat:@"%d", numAppearances];
    return sql;
}

+ (NSString *)selectRandomQuestionsSQL:(NSString *)questionTable numAppearances:(int)numAppearances limit:(int)limit {
    NSString *sql = @"select distinct parent.question_id from question parent inner join ";
    sql = [sql stringByAppendingString:questionTable];
    sql = [sql stringByAppendingString:@" child on parent.question_id = child.question_id where parent.number_appearances = "];
    sql = [sql stringByAppendingFormat:@"%d", numAppearances];
    sql = [sql stringByAppendingString:@" order by random() limit "];
    sql = [sql stringByAppendingFormat:@"%d", limit];
    return sql;
}

@end
