//
//  JCXgPushService.m
//  ChatApp
//
//  Created by joychuang on 15/3/25.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCXgPushService.h"
#import "XGPush.h"
#import "XGSetting.h"

@implementation JCXgPushService

+ (id)shared {
    static JCXgPushService *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] init];
    });
    return __singletion;
}

- (void)registerPush
{
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (void)registerPushForIOS8
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    // Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    // Actions
    UIMutableUserNotificationAction* acceptAction =
    [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    // Categories
    UIMutableUserNotificationCategory* inviteCategory =
    [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[ acceptAction ]
                    forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[ acceptAction ]
                    forContext:UIUserNotificationActionContextMinimal];
    
    NSSet* categories = [NSSet setWithObjects:inviteCategory, nil];
    
    UIUserNotificationSettings* mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication]
     registerUserNotificationSettings:mySettings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerXgPush {
    //推送配置
    [XGPush startApp:kXGPushId appKey:kXGPushKey];
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void) {
        //如果变成需要注册状态
        if (![XGPush isUnRegisterStatus]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if (sysVer < 8) {
                [self registerPush];
            } else {
                [self registerPushForIOS8];
            }
#else
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
}

- (void)registerDevice:(NSData*)deviceToken {
    NSString* deviceTokenStr = [XGPush registerDevice:deviceToken];
    void (^successBlock)(void) = ^(void) {
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock ,deviceToken: %@", deviceTokenStr);
    };
    void (^errorBlock)(void) = ^(void) {
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    //注册设备
    [[XGSetting getInstance] setChannel:@"appstore"];
    [[XGSetting getInstance] setGameServer:@"巨神峰"];
    if (![CommonUtils isEmpty:[AppUtils getUserId]]) {
        [XGPush setAccount:[AppUtils getUserId]];
        [XGPush registerDevice:deviceToken
               successCallback:successBlock
                 errorCallback:errorBlock];
    }
    [UserDefaultsUtils saveValue:deviceToken forKey:@"device"];
    
    NSLog(@"deviceTokenStr is %@", deviceTokenStr);
}

- (void)unRegisterXgPush {
    [XGPush unRegisterDevice];
}

@end
