//
//  AppDelegate.h
//  ChatApp
//
//  Created by howard on 14/11/18.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    Reachability *hostReach;
}

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isConnectionAvailabel;
- (BOOL)isBackgroundMode;

@end

