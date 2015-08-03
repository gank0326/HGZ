//
//  UIImage+Utilities.m
//  FoodFlow
//
//  Created by Kishikawa Katsumi on 11/09/05.
//  Copyright (c) 2011 Kishikawa Katsumi. All rights reserved.
//

#import "UIImage+Utilities.h"

@implementation UIImage (Utilities)

- (CGRect)convertCropRect:(CGRect)cropRect {
	UIImage *originalImage = self;

	CGSize size = originalImage.size;
	CGFloat x = cropRect.origin.x;
	CGFloat y = cropRect.origin.y;
	CGFloat width = cropRect.size.width;
	CGFloat height = cropRect.size.height;
	UIImageOrientation imageOrientation = originalImage.imageOrientation;
	if (imageOrientation == UIImageOrientationRight || imageOrientation == UIImageOrientationRightMirrored) {
		cropRect.origin.x = y;
		cropRect.origin.y = size.width - cropRect.size.width - x;
		cropRect.size.width = height;
		cropRect.size.height = width;
	}
	else if (imageOrientation == UIImageOrientationLeft || imageOrientation == UIImageOrientationLeftMirrored) {
		cropRect.origin.x = size.height - cropRect.size.height - y;
		cropRect.origin.y = x;
		cropRect.size.width = height;
		cropRect.size.height = width;
	}
	else if (imageOrientation == UIImageOrientationDown || imageOrientation == UIImageOrientationDownMirrored) {
		cropRect.origin.x = size.width - cropRect.size.width - x;
		cropRect.origin.y = size.height - cropRect.size.height - y;
	}

	return cropRect;
}

- (UIImage *)croppedImage:(CGRect)cropRect {
	CGImageRef croppedCGImage = CGImageCreateWithImageInRect(self.CGImage, cropRect);
	UIImage *croppedImage = [UIImage imageWithCGImage:croppedCGImage scale:1.0f orientation:self.imageOrientation];
	CGImageRelease(croppedCGImage);

	return croppedImage;
}

- (UIImage *)resizedImage:(CGSize)size imageOrientation:(UIImageOrientation)imageOrientation {
	CGSize imageSize = self.size;
	CGFloat horizontalRatio = size.width / imageSize.width;
	CGFloat verticalRatio = size.height / imageSize.height;
	CGFloat ratio = MIN(horizontalRatio, verticalRatio);
	CGSize targetSize = CGSizeMake(imageSize.width * ratio, imageSize.height * ratio);

	UIGraphicsBeginImageContextWithOptions(size, YES, 1.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextScaleCTM(context, 1.0f, -1.0f);
	CGContextTranslateCTM(context, 0.0f, -size.height);

	CGAffineTransform transform = CGAffineTransformIdentity;
	if (imageOrientation == UIImageOrientationRight || imageOrientation == UIImageOrientationRightMirrored) {
		transform = CGAffineTransformTranslate(transform, 0.0f, size.height);
		transform = CGAffineTransformRotate(transform, -M_PI_2);
	}
	else if (imageOrientation == UIImageOrientationLeft || imageOrientation == UIImageOrientationLeftMirrored) {
		transform = CGAffineTransformTranslate(transform, size.width, 0.0f);
		transform = CGAffineTransformRotate(transform, M_PI_2);
	}
	else if (imageOrientation == UIImageOrientationDown || imageOrientation == UIImageOrientationDownMirrored) {
		transform = CGAffineTransformTranslate(transform, size.width, size.height);
		transform = CGAffineTransformRotate(transform, M_PI);
	}
	CGContextConcatCTM(context, transform);

	CGContextDrawImage(context, CGRectMake((size.width - targetSize.width) / 2, (size.height - targetSize.height) / 2, targetSize.width, targetSize.height), self.CGImage);

	UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return resizedImage;
}

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize {
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;

		if (widthFactor > heightFactor)
			scaleFactor = widthFactor; // scale to fit height
		else
			scaleFactor = heightFactor; // scale to fit width
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;

		// center the image
		if (widthFactor > heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
		else if (widthFactor < heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}

	UIGraphicsBeginImageContext(targetSize); // this will crop

	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;

	[sourceImage drawInRect:thumbnailRect];

	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if (newImage == nil)
		NSLog(@"could not scale image");

	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}

@end
