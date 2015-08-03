//
//  SLWebViewMananger.m
//  Shanliao
//
//  Created by gsw on 9/13/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "JCWebViewMananger.h"
#import "NSString+TM.h"
#import "EventBus.h"
#import "ASIHTTPRequest.h"

@interface JCWebViewMananger()
{
    NSString *cacheDirectory;
}

@end

@implementation JCWebViewMananger

+ (id)shared {
	static JCWebViewMananger *__singletion;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    __singletion = [[self alloc] init];
	});
	return __singletion;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/HTMLCache/"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

- (NSString *)requestUrl:(NSString *)url {
    if (url) {
        NSString *path = [cacheDirectory stringByAppendingString:[url md5Hash]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSError *error;
            NSString *result = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            if (result) {
                return result;
            }
        }else {
            [self loadHtml:url];
        }
    }
    return nil;
}

- (void)loadHtml:(NSString *)url {
    NSString *path = [cacheDirectory stringByAppendingString:[url md5Hash]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(webPageFetchFailed:)];
    [request setDidFinishSelector:@selector(webPageFetchSucceeded:)];
    [request setDownloadDestinationPath:path];
    [request startAsynchronous];
}

- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest
{
    [[EventBus shared] emit:@selector(loadHtmlFailure:) withArguments:@[[theRequest.url absoluteString]]];
}

- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest
{
    NSString *response = [NSString stringWithContentsOfFile:
                          [theRequest downloadDestinationPath] encoding:[theRequest responseEncoding] error:nil];
    [[EventBus shared] emit:@selector(loadHtmlSuccess::) withArguments:@[[theRequest.url absoluteString], response]];
}

@end
