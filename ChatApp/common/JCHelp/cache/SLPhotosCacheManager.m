//
//  SLPhotosCacheManager.m
//  Shanliao
//
//  Created by gsw on 6/3/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "SLPhotosCacheManager.h"
#import "SLWebImageDownloader.h"

#define CHAT_CACHE_SPACE @"album_image_cache"

@interface SLPhotosCacheManager()
{
    SDImageCache *phtotosCache;
}

@end

@implementation SLPhotosCacheManager

+ (id)shared {
    static id instance;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[[self class] alloc] init];
	});
	
	return instance;
}

- (id)init
{
    if (self = [super init]) {
        phtotosCache = [[SDImageCache alloc] initWithNamespace:CHAT_CACHE_SPACE];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:CHAT_CACHE_SPACE]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CHAT_CACHE_SPACE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [phtotosCache clearDisk];
        }
    }
    return self;
}


- (SDImageCache *)defaultCache {
    return phtotosCache;
}

- (void)cacheImage:(UIImage*) image withURL:(NSURL *)url {
    [[self defaultCache] storeImage:image forKey:[url absoluteString]];
}

- (UIImage *)fetcherImage:(NSURL *)imageURL {
    UIImage *cachedImage = [phtotosCache imageFromMemoryCacheForKey:[imageURL absoluteString]];
    if (cachedImage == nil) {
        cachedImage = [phtotosCache imageFromDiskCacheForKey:[imageURL absoluteString]];
    }
    return cachedImage;
}

@end
