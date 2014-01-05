//
//  Effects.h
//  CloseUp
//
//  Created by Fede on 10/07/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Effects : NSObject {
}

+ (void)drawPointsInImageArray:(NSString *)points magnitudesWithImageViews:(NSArray *)theMagnitudes;

+ (UIColor *)tigerStripes;

+ (void)applySpotLightOnTapToContinue:(UIImageView *)imageView;

+ (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height;

@end