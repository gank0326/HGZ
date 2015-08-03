//
//  SLChatAudioDownloadManager.h
//  Shanliao
//
//  Created by gsw on 9/18/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLChatAudioDownloadManager : NSObject

+ (id)shared;

- (void)downloadAudio:(NSString *)url;

- (NSString *)getAudioCacheDictory;

- (void)downloadAudioAndPlay:(NSString *)url withIdentifer:(NSString *)uuid;

- (void) cacheLocalFile:(NSURL *)remoteUrl filePath:(NSString*)localFilepath;

@end
