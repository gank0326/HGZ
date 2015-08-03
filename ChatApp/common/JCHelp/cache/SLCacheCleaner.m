//
//  SLDBCacheCleaner.m
//  Shanliao
//
//  Created by gsw on 8/30/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "SLCacheCleaner.h"
#import "SLChatAudioDownloadManager.h"

@implementation SLCacheCleaner

static bool historyArrived = false;

+ (void)historyMessageArrived {
    historyArrived = true;
}

+ (void)clearCache {
    
}

@end
