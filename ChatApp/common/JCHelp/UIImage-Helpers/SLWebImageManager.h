//
//  SLWebImageManager.h
//  Shanliao
//
//  Created by 徐涛 on 12/14/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageOperation.h"
#import "SLWebImageDownloader.h"
#import "SDImageCache.h"

typedef NS_OPTIONS(NSUInteger, SLWebImageOptions) {
    /**
     * By default, when a URL fail to be downloaded, the URL is blacklisted so the library won't keep trying.
     * This flag disable this blacklisting.
     */
    SLWebImageRetryFailed = 1 << 0,
    
    /**
     * By default, image downloads are started during UI interactions, this flags disable this feature,
     * leading to delayed download on UIScrollView deceleration for instance.
     */
    SLWebImageLowPriority = 1 << 1,
    
    /**
     * This flag disables on-disk caching
     */
    SLWebImageCacheMemoryOnly = 1 << 2,
    
    /**
     * This flag enables progressive download, the image is displayed progressively during download as a browser would do.
     * By default, the image is only displayed once completely downloaded.
     */
    SLWebImageProgressiveDownload = 1 << 3,
    
    /**
     * Even if the image is cached, respect the HTTP response cache control, and refresh the image from remote location if needed.
     * The disk caching will be handled by NSURLCache instead of SDWebImage leading to slight performance degradation.
     * This option helps deal with images changing behind the same request URL, e.g. Facebook graph api profile pics.
     * If a cached image is refreshed, the completion block is called once with the cached image and again with the final image.
     *
     * Use this flag only if you can't make your URLs static with embeded cache busting parameter.
     */
    SLWebImageRefreshCached = 1 << 4,
    
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     */
    SLWebImageContinueInBackground = 1 << 5,
    
    /**
     * Handles cookies stored in NSHTTPCookieStore by setting
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    SLWebImageHandleCookies = 1 << 6,
    
    /**
     * Enable to allow untrusted SSL ceriticates.
     * Useful for testing purposes. Use with caution in production.
     */
    SLWebImageAllowInvalidSSLCertificates = 1 << 7,
    
    /**
     * By default, image are loaded in the order they were queued. This flag move them to
     * the front of the queue and is loaded immediately instead of waiting for the current queue to be loaded (which
     * could take a while).
     */
    SLWebImageHighPriority = 1 << 8,
    
    /**
     * By default, placeholder images are loaded while the image is loading. This flag will delay the loading
     * of the placeholder image until after the image has finished loading.
     */
    SLWebImageDelayPlaceholder = 1 << 9,
    
    /**
     * We usually don't call transformDownloadedImage delegate method on animated images,
     * as most transformation code would mangle it.
     * Use this flag to transform them anyway.
     */
    SLWebImageTransformAnimatedImage = 1 << 10,
    
    //上面全部是 SDWebImageOptions 的copy实现，之所有给他重命名是为了将来切换框架
    
    SLWebImageCacheMemoryAlways = 0,
    
    SLWebImageCacheDiskOnly = 1213
};

typedef void(^SLWebImageCompletionBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);
typedef void(^SLWebImageCompletionWithFinishedBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL);

@interface SLWebImageManager : NSObject

+ (SLWebImageManager *)sharedManager;

- (id<SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                   options:(SLWebImageOptions)options
                                  progress:(SLWebImageDownloaderProgressBlock)progressBlock
                                 completed:(SLWebImageCompletionWithFinishedBlock)completedBlock;

@end
