//
//  SLImageFetcher.m
//  Shanliao
//
//  Created by gsw on 11/2/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "SLImageCacheFetcher.h"
#import "SDImageCache.h"
#import "SLAyncHttpImageCache.h"


@interface SLImageCacheFetcher()
{
  
}

@end

@implementation SLImageCacheFetcher

+ (id)shared
{
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
    }
    return self;
}

- (UIImage *)fetcherImage:(NSURL *)imageURL fromMemory:(BOOL)fromMemory {
    UIImage *cachedImage = nil;
    if (fromMemory) {
        cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[imageURL absoluteString]];
    }
    if (cachedImage == nil) {
        cachedImage = [[SDImageCache sharedImageCache] queryFromDiskDirectly:[imageURL absoluteString]];
    }
    if (!cachedImage) {
        cachedImage = [[SLAyncHttpImageCache shared] fetcherImage:imageURL];
    }
    return cachedImage;
}


@end
