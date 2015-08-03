//
//  UIImageView+SL.m
//  Shanliao
//
//  Created by 徐涛 on 12/14/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "UIImageView+SL.h"
#import "UIImageView+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "UIImage+Tagged.h"

static char imageURLKey;

@implementation UIImageView (SL)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self setImageWithURL:url placeholderImage:placeholder options:(SLWebImageLowPriority) progress:nil completed:nil withRoundCrop:NO];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SLWebImageOptions)options {
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil withRoundCrop:NO];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SLWebImageOptions)options withRoundCrop:(BOOL)crop {
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil withRoundCrop:crop];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SLWebImageOptions)options completed:(SLWebImageCompletionBlock)completedBlock {
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock withRoundCrop:NO];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SLWebImageOptions)options progress:(SLWebImageDownloaderProgressBlock)progressBlock completed:(SLWebImageCompletionBlock)completedBlock {
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock withRoundCrop:NO];
}

/**
 *  UIImageView+WebCache.h 重写， 方便定制，这里需要定制的包括聊界面的缓存需要一直维持不能用NSCache，还有一个需要定制的是withRoundCrop这个参数，如果是YES，怎图片会裁剪位一个圆形
 *
 *  @param url            url description
 *  @param placeholder    placeholder description
 *  @param options        options description
 *  @param progressBlock  progressBlock description
 *  @param completedBlock completedBlock description
 *  @param crop           crop description
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SLWebImageOptions)options progress:(SLWebImageDownloaderProgressBlock)progressBlock completed:(SLWebImageCompletionBlock)completedBlock withRoundCrop:(BOOL)crop {
#ifdef SD_WEBP
    //如果是第一次请求jpg，就用webp格式替代请求。
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock withRoundCrop:crop useWebP:YES];
#else
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock withRoundCrop:crop useWebP:NO];
#endif
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SLWebImageOptions)options progress:(SLWebImageDownloaderProgressBlock)progressBlock completed:(SLWebImageCompletionBlock)completedBlock withRoundCrop:(BOOL)crop useWebP:(BOOL)useWebP {
    
    NSURL *accessUrl;
    if (useWebP) {
        //如果是第一次请求jpg，就用webp格式替代请求。
        accessUrl = [JCViewUtil getWebpUrl:url];
    }else {
        accessUrl = url;
    }
    
    [self sd_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    if (url) {
        __weak UIImageView *wself = self;
        
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:accessUrl options:(SDWebImageOptions)options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            if (!image && error.code == 404) {
                //如果webp请求失败，则用.jpg取代
                if (useWebP) {
                    [wself setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock withRoundCrop:crop useWebP:NO];
                    return;
                }
            }
            if (image) {
                if (crop) {
                    if ((cacheType == SDImageCacheTypeMemory || cacheType == SDImageCacheTypeAlwaysMemory) && [[image tag] isEqualToString:@"1"]) {
                        //continue
                    }else {
                        image = [wself imageWithRoundedCornersSizeUsingImage:image];
                        [image setTag:@"1"];
//                        SDImageCacheQueryType type = (options == SLWebImageCacheMemoryAlways)? SDImageCacheQueryTypeNSDictionary:SDImageCacheQueryTypeNSCache;
//                        [[SDImageCache sharedImageCache] refreshMemory:image key:imageURL.absoluteString options:(type)];
                    }
                }
            }
            dispatch_main_sync_safe(^{
                if (!wself) return;
                UIImage *processedImage = image;
                if (processedImage) {
                    wself.image = processedImage;
                    [wself setNeedsLayout];
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(processedImage, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

/**
 *  将图片剪裁成圆形
 *
 *  @param original
 *
 *  @return
 */
- (UIImage *)imageWithRoundedCornersSizeUsingImage:(UIImage *)original
{
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    CGSize size = original.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height)
                                cornerRadius:size.width/2] addClip];
    // Draw your image
    [original drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Get the image, here setting the UIImageView image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)cancelCurrentImageLoad {
    [self sd_cancelCurrentImageLoad];
}

@end
