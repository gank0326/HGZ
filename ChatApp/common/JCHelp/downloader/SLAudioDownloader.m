//
//  SLAudioDownloader.m
//  Shanliao
//
//  Created by gsw on 9/18/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "SLAudioDownloader.h"
#import "ASIHTTPRequest.h"
#import "SLChatAudioDownloadManager.h"
#import "NSString+TM.h"

@interface SLAudioDownloader ()
{
	ASIHTTPRequest *asirequest;
	NSString *dicUrl;
}

@end

@implementation SLAudioDownloader

@synthesize autoPlay;
@synthesize uuid;
@synthesize url = _url;

- (void)downloadAudio:(NSString *)url {
	self.url = url;
	asirequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	[asirequest setTimeOutSeconds:120];
	NSString *destDec = [[SLChatAudioDownloadManager shared] getAudioCacheDictory];
	dicUrl = [destDec stringByAppendingString:[url md5Hash]];
	[asirequest setDownloadDestinationPath:dicUrl];
	[asirequest setDidFinishSelector:@selector(requestFinished:)];
	[asirequest setDidFailSelector:@selector(requestFailed:)];
	asirequest.delegate = self;
	[asirequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	if (self.delegate && [self.delegate respondsToSelector:@selector(didDownloadAudio:withLocalPath:forUrl:)]) {
		[self.delegate didDownloadAudio:self withLocalPath:dicUrl forUrl:self.url];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	if (self.delegate && [self.delegate respondsToSelector:@selector(didDownloadAudioFail:forUrl:)]) {
		[self.delegate didDownloadAudioFail:self forUrl:self.url];
	}
}

@end
