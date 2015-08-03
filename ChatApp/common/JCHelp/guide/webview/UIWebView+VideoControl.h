//
//  UIWebView+VideoControl.h
//  ChatApp
//
//  Created by joychuang on 15/3/31.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (VideoControl)

- (BOOL)hasVideo;
- (NSString *)getVideoTitle;
- (double)getVideoDuration;
- (double)getVideoCurrentTime;

- (int)play;
- (int)pause;
- (int)resume;
- (int)stop;

@end

