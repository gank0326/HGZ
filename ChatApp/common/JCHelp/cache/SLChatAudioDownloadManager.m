//
//  SLChatAudioDownloadManager.m
//  Shanliao
//
//  Created by gsw on 9/18/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "SLChatAudioDownloadManager.h"
#import "SLAudioDownloader.h"
#import "EventBus.h"
#import "NSString+TM.h"

@interface SLChatAudioDownloadManager()<SLAudioDownloaderDeletage>
{
    NSString* cacheDirectory;
    NSMutableArray *downloaders;
}

@end

@implementation SLChatAudioDownloadManager

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
    self = [super init];
    if (self) {
        cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/ChatAudio/"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        downloaders = [NSMutableArray array];
    }
    return self;
}

- (NSString *)getAudioCacheDictory
{
    return cacheDirectory;
}

- (void)downloadAudio:(NSString *)url
{
    SLAudioDownloader *downloader = [[SLAudioDownloader alloc] init];
    downloader.delegate = self;
    [downloaders addObject:downloader];
    [downloader downloadAudio:url];
}

- (void)downloadAudioAndPlay:(NSString *)url withIdentifer:(NSString *)uuid
{
    if (![self needDownload:url]) {
        return;
    }
    SLAudioDownloader *downloader = [[SLAudioDownloader alloc] init];
    downloader.delegate = self;
    downloader.autoPlay = YES;
    downloader.uuid = uuid;
    [downloaders addObject:downloader];
    [downloader downloadAudio:url];
}

- (BOOL)needDownload:(NSString *)url{
    for (int i = 0; i < [downloaders count]; i++) {
        SLAudioDownloader *item = [downloaders objectAtIndex:i];
        if ([item.url isEqualToString:url]) {
            return NO;
        }
    }
    return YES;
}

-(void)didDownloadAudio:(SLAudioDownloader *)downloader withLocalPath:(NSString *)localPath forUrl:(NSString *)url
{
    if ([downloaders indexOfObject:downloader] != NSNotFound) {
        if (downloader.autoPlay) {
            [[EventBus shared] emit:@selector(chatRoomDownloadUrlSuccessAndAutoPlay::) withArguments:[[NSArray alloc] initWithObjects:url, downloader.uuid, nil]];
        }
        else
        {
            [[EventBus shared] emit:@selector(chatRoomDownloadUrlSuccess:) withArguments:[[NSArray alloc] initWithObjects:url, nil]];
        }
        [self removeDownloader:downloader];
    }
}

-(void)didDownloadAudioFail:(SLAudioDownloader *)downloader forUrl:(NSString *)url
{
    [self removeDownloader:downloader];
    [[EventBus shared] emit:@selector(chatRoomDownloadAudioFail:) withArguments:[[NSArray alloc] initWithObjects:url, nil]];
}

- (void)removeDownloader:(SLAudioDownloader *)downloader{
    [downloaders removeObject:downloader];
    downloader.delegate = nil;
}

- (void) cacheLocalFile:(NSURL *)remoteUrl filePath:(NSString*)localFilepath {
    NSString *filename = [[remoteUrl absoluteString] md5Hash];
	NSString *readyFilename = [cacheDirectory stringByAppendingString:filename];
	NSError *err = nil;
	if ([[NSFileManager defaultManager] fileExistsAtPath:readyFilename]) {
		[[NSFileManager defaultManager] removeItemAtPath:readyFilename error:&err];
		[[NSFileManager defaultManager] moveItemAtPath:localFilepath toPath:readyFilename error:&err];
	}
}

@end
