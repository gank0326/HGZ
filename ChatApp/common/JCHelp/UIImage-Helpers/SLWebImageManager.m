//
//  SLWebImageManager.m
//  Shanliao
//
//  Created by 徐涛 on 12/14/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "SLWebImageManager.h"
#import "SDWebImageManager.h"

@implementation SLWebImageManager

+ (SLWebImageManager *)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}

- (id<SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                   options:(SLWebImageOptions)options
                                  progress:(SLWebImageDownloaderProgressBlock)progressBlock
                                 completed:(SLWebImageCompletionWithFinishedBlock)completedBlock {
    return [self downloadWithURL:url options:options progress:progressBlock completed:completedBlock useWebp:YES];
}

- (id<SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                   options:(SLWebImageOptions)options
                                  progress:(SLWebImageDownloaderProgressBlock)progressBlock
                                 completed:(SLWebImageCompletionWithFinishedBlock)completedBlock
                                   useWebp:(BOOL)useWebp {
    NSURL *accessUrl;
    if (useWebp) {
        //如果是第一次请求jpg，就用webp格式替代请求。
        accessUrl = [JCViewUtil getWebpUrl:url];
    }else {
        accessUrl = url;
    }
    return [[SDWebImageManager sharedManager] downloadImageWithURL:accessUrl options:(SDWebImageOptions)options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if(progressBlock) progressBlock(receivedSize, expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!image && error.code == 404) {
            //如果webp请求失败，则用.jpg取代
            if (useWebp) {
                [self downloadWithURL:url options:options progress:progressBlock completed:completedBlock useWebp:NO];
                return;
            }
        }
        if(completedBlock) {
            completedBlock(image, error, cacheType, finished, imageURL);
        }
    }];
}




@end
