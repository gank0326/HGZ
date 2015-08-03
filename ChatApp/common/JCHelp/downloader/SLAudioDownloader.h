//
//  SLAudioDownloader.h
//  Shanliao
//
//  Created by gsw on 9/18/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SLAudioDownloader;

@protocol SLAudioDownloaderDeletage <NSObject>

- (void)didDownloadAudio:(SLAudioDownloader *)downloader withLocalPath:(NSString *)localPath forUrl:(NSString *)url;
- (void)didDownloadAudioFail:(SLAudioDownloader *)downloader forUrl:(NSString *)url;

@end

@interface SLAudioDownloader : NSObject

@property (nonatomic, assign) id <SLAudioDownloaderDeletage> delegate;

@property (nonatomic, strong) NSString *url;

@property (nonatomic) BOOL autoPlay;

@property (nonatomic) NSString *uuid;

- (void)downloadAudio:(NSString *)url;

@end
