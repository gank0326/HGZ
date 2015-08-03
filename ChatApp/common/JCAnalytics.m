//
//  JCAnalytics.m
//  ChatApp
//
//  Created by joychuang on 15/3/24.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCAnalytics.h"
#import "MobClick.h"
#import "SDImageCache.h"
#import <sys/utsname.h>

static NSString *const UMAppKey  = @"55112d56fd98c5f89000074f";

static NSString *HasCleanImages = @"HasCleanImages";

@implementation JCAnalytics

+ (void)steupUMAnalytics {
    [MobClick startWithAppkey:UMAppKey];
    [MobClick setAppVersion:kCurrentVersion];
    [MobClick setCrashReportEnabled:NO];
}

NSString* machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

@end