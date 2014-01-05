//
//  Created by fede on 6/6/13.
//
//  Copyright 2011 Kowari SARL. All rights reserved.
//

#import "GameProgressView.h"
#import "GameDAO.h"


@implementation GameProgressView {

}

- (id)initWithGame:(Game *)game {
    self = [super initWithFrame:CGRectMake(112, 10, 187, 34)];
    if (self) {
        self.game = game;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self setBackgroundColor:[UIColor clearColor]];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawHorizontalBar:ctx];

    float steps = self.frame.size.width / TOTAL_QUESTIONS_PER_GAME;
    float offset = steps / 2;
    float radius = offset / 1.4;
    float radiusBig = offset / 1.1;

    for (int i = 0; i < TOTAL_QUESTIONS_PER_GAME; i++) {
        float circleRadius = radius;
        Question *question = [_game currentQuestion];
        BOOL currentQuestion = [question displayIndex] == i;
        if (currentQuestion) {
            circleRadius = radiusBig;
        }
        [self drawProgressCircle:ctx offset:offset radius:circleRadius color:[[UIColor lightGrayColor] CGColor]];
        [self drawProgressCircle:ctx offset:offset radius:circleRadius / 1.3 color:[[self resultColor:i] CGColor]];
        if (currentQuestion) {
            [self drawQuestionNumber:ctx offset:offset questionIndex:question.displayIndex + 1];
        }
        offset += steps;
    }
}

- (void)drawQuestionNumber:(CGContextRef)ctx  offset:(float)offset questionIndex:(int)index {
    CGContextSetTextMatrix(ctx, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));

    NSString *string = [NSString stringWithFormat:@"%d", index];
    char const *encoding = [string cStringUsingEncoding:NSASCIIStringEncoding];

    int fontSize = 14;
    CGContextSelectFont(ctx, "Arial-BoldMT", fontSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetRGBFillColor(ctx, 255, 255, 255, 1);

    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
    CGSize fontDimension = [string sizeWithFont:font];

    CGPoint center = CGPointMake(offset - (fontDimension.width / 2), (self.frame.size.height / 2) + (fontSize / 2) - 2);

    CGContextShowTextAtPoint(ctx, center.x, center.y, encoding, strlen(encoding));
}

- (UIColor *)resultColor:(int)questionIndex {
    Question *question = [[_game questions] objectAtIndex:questionIndex];
    if (![question isAnswered]) {
        return [UIColor lightGrayColor];
    } else if ([question isCorrectNoErrors]) {
        return [UIColor greenColor];
    } else if ([question isCorrect]) {
        return [UIColor orangeColor];
    }
    return [UIColor redColor];
}

- (void)drawProgressCircle:(CGContextRef)ctx offset:(float)offset radius:(float)radius color:(CGColorRef)color {
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, 1);
    CGPoint center = CGPointMake(offset, self.frame.size.height / 2.0);
    CGContextAddArc(ctx, center.x, center.y, radius, 0, 2 * M_PI, 0);
    CGContextSetFillColorWithColor(ctx, color);
    CGContextFillPath(ctx);
}

- (void)drawHorizontalBar:(CGContextRef)ctx {
    int offsetY = 1;
    CGFloat halfY = (self.frame.size.height / 2) - offsetY;
    CGContextSetFillColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
    CGRect cgRect = CGRectMake(10, halfY, self.frame.size.width - 20, offsetY * 2);
    CGContextAddRect(ctx, cgRect);
    CGContextFillRect(ctx, cgRect);
    CGContextStrokePath(ctx);
}

- (void)dealloc {
    [_game release];
    [super dealloc];
}


@end