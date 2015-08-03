//
//  SLAyncHttpImageCache.m
//  Shanliao
//
//  Created by gsw on 11/14/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "SLAyncHttpImageCache.h"
#import "SDImageCache.h"

#define HTTP_ASYN_CACHE_SPACE @"http_asyn_cache_space"

@interface SLAyncHttpImageCache ()
{
	SDImageCache *asyncImageCache;
}

@end

@implementation SLAyncHttpImageCache

+ (id)shared {
	static id instance;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    instance = [[[self class] alloc] init];
	});

	return instance;
}

- (SDImageCache *)defaultCache {
	return asyncImageCache;
}

- (id)init {
	if (self = [super init]) {
		asyncImageCache = [[SDImageCache alloc] initWithNamespace:HTTP_ASYN_CACHE_SPACE];
	}
	return self;
}

//- (void)cacheImage:(UIImage *)image withURL:(NSURL *)url {
//    asyncImageCache sto
//	[asyncImageCache storeImageSync:image forKey:[url absoluteString]];
//}

- (UIImage *)fetcherImage:(NSURL *)imageURL {
	UIImage *cachedImage = [asyncImageCache imageFromMemoryCacheForKey:[imageURL absoluteString]];
	if (cachedImage == nil) {
		cachedImage = [asyncImageCache imageFromDiskCacheForKey:[imageURL absoluteString]];
	}
	return cachedImage;
}

- (void)removeImage:(NSURL *)imageURL {
	[asyncImageCache removeImageForKey:[imageURL absoluteString]];
}

@end
