//
//  SLImageDownloaderManager.m
//  Shanliao
//
//  Created by gsw on 4/30/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "SLImageDownloaderManager.h"
#import "SLWebImageManager.h"
#import "Reachability.h"
#import "EventBus.h"
#import "CMSignals.h"
#import "UIImage+TM.h"
#import "SLImageCacheFetcher.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"

@interface SLImageDownloaderManager ()
{
	NSMutableArray *queue;
}

@end

@implementation SLImageDownloaderManager

+ (id)shared {
	static SLImageDownloaderManager *__singletion;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    __singletion = [[self alloc] init];
	});
	return __singletion;
}

- (id)init {
	self = [super init];
	if (self) {
		queue = [NSMutableArray array];
		[self connect:@selector(wifiDidConnected) from:[EventBus shared] with:@selector(getFirstToUpload)];
	}
	return self;
}

- (void)downloadImage:(NSString *)url {
	[queue addObject:url];
	[self getFirstToUpload];
}

- (void)getFirstToUpload {
	if ([JCViewUtil isWifiConnected]) {
		if ([queue count] > 0) {
			NSString *url = [queue objectAtIndex:0];
			[queue removeObjectAtIndex:0];
			UIImage *cachedImage = [[SLImageCacheFetcher shared] fetcherImage:[NSURL URLWithString:url] fromMemory:YES];
			if (!cachedImage) {
                
                SLWebImageManager *manager = [SLWebImageManager sharedManager];
                [manager downloadWithURL:[NSURL URLWithString:url]  options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image && finished) {
				        [self getFirstToUpload];
					}
                }];
			}
			else {
				[self getFirstToUpload];
			}
		}
	}
}

@end
