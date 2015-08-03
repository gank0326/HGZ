//
//  UIImage+TM.h
//  KChat
//
//  Created by gsw on 12-11-5.
//  Copyright (c) 2012年 gsw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TM)

- (UIImage *)imageWithTint:(UIColor *)tintColor;

- (UIImage *)overlayWithColor:(UIColor *)overlayColor;

- (UIImage *)imageWithOverlayColor:(UIColor *)color;

- (UIImage*) maskImage:(UIImage*)mask;

- (UIImage *) maskWithImage:(const UIImage *) maskImage;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

- (UIImage*)resizedImageToFitInSizeAutoCrop:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

- (UIImage *)resizedImage:(CGSize)size imageOrientation:(UIImageOrientation)imageOrientation;

- (UIImage *) renderAtSize:(const CGSize) size;

- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius;

- (UIImage *)imageWithBorder:(NSUInteger)thickness withColor:(UIColor *)color;

@end
