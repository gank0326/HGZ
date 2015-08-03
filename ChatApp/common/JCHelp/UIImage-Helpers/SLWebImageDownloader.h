//
//  SLWebImageDownloader.h
//  Shanliao
//
//  Created by 徐涛 on 12/14/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, SLWebImageDownloaderOptions) {
    SLWebImageDownloaderLowPriority = 1 << 0,
    SLWebImageDownloaderProgressiveDownload = 1 << 1,
    
    /**
     * By default, request prevent the of NSURLCache. With this flag, NSURLCache
     * is used with default policies.
     */
    SLWebImageDownloaderUseNSURLCache = 1 << 2,
    
    /**
     * Call completion block with nil image/imageData if the image was read from NSURLCache
     * (to be combined with `SDWebImageDownloaderUseNSURLCache`).
     */
    
    SLWebImageDownloaderIgnoreCachedResponse = 1 << 3,
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     */
    
    SLWebImageDownloaderContinueInBackground = 1 << 4,
    
    /**
     * Handles cookies stored in NSHTTPCookieStore by setting
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    SLWebImageDownloaderHandleCookies = 1 << 5,
    
    /**
     * Enable to allow untrusted SSL ceriticates.
     * Useful for testing purposes. Use with caution in production.
     */
    SLWebImageDownloaderAllowInvalidSSLCertificates = 1 << 6,
    
    /**
     * Put the image in the high priority queue.
     */
    SLWebImageDownloaderHighPriority = 1 << 7,
    
    
    //上面全部是 SDWebImageDownloaderOptions 的copy实现，之所有给他重命名是为了将来切换框架
};

typedef void(^SLWebImageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);
typedef void(^SLWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

@interface SLWebImageDownloader : NSObject

+ (SLWebImageDownloader *)sharedDownloader;

- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(SLWebImageDownloaderOptions)options
                                        progress:(SLWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SLWebImageDownloaderCompletedBlock)completedBlock;

@end
