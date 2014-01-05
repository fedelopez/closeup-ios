//
//  Effects.m
//  CloseUp
//
//  Created by Fede on 10/07/10.
//  Copyright 2010 FLL. All rights reserved.
//

#import "Effects.h"

@implementation Effects

+ (void)drawPointsInImageArray:(NSString *)points magnitudesWithImageViews:(NSArray *)theMagnitudes {
    int length = [points length] - 1;
    int magnitudesIndex = 0;
    for (int i = length; i >= 0; i--) {
        unichar charAt = [points characterAtIndex:i];
        UIImageView *magnitude = [theMagnitudes objectAtIndex:magnitudesIndex];
        [magnitude setImage:[UIImage imageNamed:[NSString stringWithFormat:@"number%c.png", charAt]]];
        [magnitude setHidden:FALSE];
        magnitudesIndex++;
    }
}

+ (UIColor *)tigerStripes {
    return [UIColor colorWithRed:(225 / 255.0) green:(247 / 255.0) blue:(250 / 255.0) alpha:1.0];
}

+ (void)applySpotLightOnTapToContinue:(UIImageView *)imageView {
    NSMutableArray *images = [[[NSMutableArray alloc] initWithCapacity:45] autorelease];
    for (int i = 1; i < 22; i++) {
        NSString *imageName = [@"tap-to-continue" stringByAppendingString:[NSString stringWithFormat:@"%d.png", i]];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    for (int i = 20; i > 1; i--) {
        NSString *imageName = [@"tap-to-continue" stringByAppendingString:[NSString stringWithFormat:@"%d.png", i]];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    [imageView setAnimationImages:images];
    [imageView setAnimationDuration:2.5];
    [imageView startAnimating];
}


#pragma mark - Image Reflection

CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh) {
    CGImageRef theCGImage = NULL;

    // gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

    // create the bitmap context
    CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh,
            8, 0, colorSpace, kCGImageAlphaNone);

    // define the start and end grayscale values (with the alpha, even though
    // our bitmap context doesn't support alpha the gradient requires it)
    CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};

    // create the CGGradient and then release the gray color space
    CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGColorSpaceRelease(colorSpace);

    // create the start and end points for the gradient vector (straight down)
    CGPoint gradientStartPoint = CGPointZero;
    CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);

    // draw the gradient into the gray bitmap context
    CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
            gradientEndPoint, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(grayScaleGradient);

    // convert the context into a CGImageRef and release the context
    theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
    CGContextRelease(gradientBitmapContext);

    // return the imageref containing the gradient
    return theCGImage;
}

CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    // create the bitmap context
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, 8,
            0, colorSpace,
            // this will give us an optimal BGRA format for the device:
            (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    CGColorSpaceRelease(colorSpace);

    return bitmapContext;
}

+ (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height {
    if (height == 0)
        return nil;

    // create a bitmap graphics context the size of the image
    CGContextRef mainViewContentContext = MyCreateBitmapContext(fromImage.bounds.size.width, height);

    // create a 2 bit CGImage containing a gradient that will be used for masking the
    // main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
    // function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
    CGImageRef gradientMaskImage = CreateGradientImage(1, height);

    // create an image by masking the bitmap of the mainView content with the gradient view
    // then release the  pre-masked content bitmap and the gradient bitmap
    CGContextClipToMask(mainViewContentContext, CGRectMake(0.0, 0.0, fromImage.bounds.size.width, height), gradientMaskImage);
    CGImageRelease(gradientMaskImage);

    // In order to grab the part of the image that we want to render, we move the context origin to the
    // height of the image that we want to capture, then we flip the context so that the image draws upside down.
    CGContextTranslateCTM(mainViewContentContext, 0.0, height);
    CGContextScaleCTM(mainViewContentContext, 1.0, -1.0);

    // draw the image into the bitmap context
    CGContextDrawImage(mainViewContentContext, fromImage.bounds, fromImage.image.CGImage);

    // create CGImageRef of the main view bitmap content, and then release that bitmap context
    CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);

    // convert the finished reflection image to a UIImage
    UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];

    // image is retained by the property setting above, so we can release the original
    CGImageRelease(reflectionImage);

    return theImage;
}

@end
