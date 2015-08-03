//
//  UIImageView+SL.h
//  Shanliao
//
//  Created by 徐涛 on 12/14/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLWebImageManager.h"

@interface UIImageView (SL)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SLWebImageOptions)options;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SLWebImageOptions)options withRoundCrop:(BOOL)crop;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SLWebImageOptions)options completed:(SLWebImageCompletionBlock)completedBlock;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SLWebImageOptions)options progress:(SLWebImageDownloaderProgressBlock)progressBlock completed:(SLWebImageCompletionBlock)completedBlock;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SLWebImageOptions)options progress:(SLWebImageDownloaderProgressBlock)progressBlock completed:(SLWebImageCompletionBlock)completedBlock withRoundCrop:(BOOL)crop useWebP:(BOOL)useWebP;

- (void)cancelCurrentImageLoad;

@end
