//
//  SLCahceImageCleaner.m
//  Shanliao
//
//  Created by gsw on 8/4/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "SLCacheImageCleaner.h"
#import "SLPhotosCacheManager.h"

@implementation SLCacheImageCleaner

+ (void)clearOld {
    NSString *fullNamespace1 = [@"com.6rooms." stringByAppendingString:@"CacheImages"];
    NSString *fullNamespace2 = [@"com.6rooms." stringByAppendingString:@"photos_image_cache"];
    NSString *fullNamespace3 = [@"com.6rooms." stringByAppendingString:@"chat_image_cache"];
    // Init the disk cache
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskCachePath1 = [paths[0] stringByAppendingPathComponent:fullNamespace1];
    NSString *diskCachePath2 = [paths[0] stringByAppendingPathComponent:fullNamespace2];
    NSString *diskCachePath3 = [paths[0] stringByAppendingPathComponent:fullNamespace3];
    dispatch_async(kGlobalQueue, ^
                   {
                       [[NSFileManager defaultManager] removeItemAtPath:diskCachePath1 error:nil];
                       [[NSFileManager defaultManager] removeItemAtPath:diskCachePath2 error:nil];
                       [[NSFileManager defaultManager] removeItemAtPath:diskCachePath3 error:nil];
                   });
    
    NSString *cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/com.6rooms.ChatTempSending"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory]) {
        [[NSFileManager defaultManager] removeItemAtPath:cacheDirectory error:nil];
    }
}

+ (void)cleanImages {
    [[[SLPhotosCacheManager shared] defaultCache] clearDisk];
    
    [[SDImageCache sharedImageCache] removeLargeImages];
}

@end
