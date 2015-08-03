//
//  SLWebImageDownloader.m
//  Shanliao
//
//  Created by 徐涛 on 12/14/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "SLWebImageDownloader.h"
#import "SDWebImageDownloader.h"

@implementation SLWebImageDownloader

+ (SLWebImageDownloader *)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(SLWebImageDownloaderOptions)options
                                        progress:(SLWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SLWebImageDownloaderCompletedBlock)completedBlock {
    return [self downloadImageWithURL:url options:options progress:progressBlock completed:completedBlock useWebp:YES];
}

- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(SLWebImageDownloaderOptions)options
                                        progress:(SLWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SLWebImageDownloaderCompletedBlock)completedBlock
                                         useWebp:(BOOL)useWebp {
    NSURL *accessUrl;
    if (useWebp) {
        //如果是第一次请求jpg，就用webp格式替代请求。
        accessUrl = [JCViewUtil getWebpUrl:url];
    }else {
        accessUrl = url;
    }
    
    return [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:accessUrl options:(SDWebImageDownloaderOptions)options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progressBlock) progressBlock(receivedSize, expectedSize);
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (!image && error.code == 404) {
            //如果webp请求失败，则用.jpg取代
            if (useWebp) {
                [self downloadImageWithURL:url options:options progress:progressBlock completed:completedBlock useWebp:NO];
                return;
            }
        }
        if(completedBlock) {
            completedBlock(image, data, error, finished);
        }
    }];
}

@end
