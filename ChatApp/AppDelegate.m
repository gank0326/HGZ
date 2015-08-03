//
//  AppDelegate.m
//  ChatApp
//
//  Created by howard on 14/11/18.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import "AppDelegate.h"
#import "XGPush.h"
#import "XGSetting.h"
#import "GlobalContants.h"
#import "JCWeiXinLoginService.h"
#import "JCSkinManager.h"
#import "JCAccountService.h"
#import "JCLoginViewController.h"
#import "JCRedPointService.h"
#import "JCAnalytics.h"
#import "JCXgPushService.h"

#define _IPHONE80_ 80000

@interface AppDelegate ()
{
    BOOL backgroundMode;
}

@property (nonatomic, strong) Reachability* reachAbility;

@end

@implementation AppDelegate

- (Reachability*)reachAbility
{
    if (nil == _reachAbility) {
        _reachAbility = [Reachability
            reachabilityWithHostName:kCHReachabilityHost]; // 需要连接的hostName
    }
    return _reachAbility;
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    [self connect:@selector(sendlinkToWX:) from:[EventBus shared] with:@selector(sendlinkToWX:)];
    [JCAnalytics steupUMAnalytics]; // 友盟统计
    [WXApi registerApp:kWeiXinAppId withDescription:kAppDescription]; //注入微信
    [[JCAccountService shared] loadAppToken];
    backgroundMode = NO;
    [[JCSkinManager shared] changeSkin:[[JCSkinManager shared] currentSkin]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [JCViewHelper getRootViewController];
    
    self.isConnectionAvailabel = YES;
    NSMutableArray *guideArr = [NSMutableArray new];
    for (int i = 0; i < 4; i++) {
        NSString *imageName = [NSString stringWithFormat:@"turn_5_%d", i + 1];
        [guideArr addObject:imageName];
    }
    [JCViewHelper loadGuideViewToView:self.window
                            imageArr:guideArr
                       pageIconImage:[UIImage imageNamed:@"radio_n.png"]
               pageSelectedIconImage:[UIImage imageNamed:@"radio_s.png"]];
    

    //推送配置
    [[JCXgPushService shared] registerXgPush];
    //角标清0
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self.reachAbility startNotifier];
    [self registeReachabilityChangedNotification];
    [self.window makeKeyAndVisible];
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings
{
    //用户已经允许接收以下类型的推送
    // UIUserNotificationType allowedTypes = [notificationSettings types];
    //        [application registerForRemoteNotifications];
}

//按钮点击事件回调
- (void)application:(UIApplication*)application handleActionWithIdentifier:(NSString*)identifier forRemoteNotification:(NSDictionary*)userInfo completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]) {
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    completionHandler();
}

#endif

- (BOOL)isBackgroundMode {
    return backgroundMode;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [[JCXgPushService shared] registerDevice:deviceToken];
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication*)app didFailToRegisterForRemoteNotificationsWithError:(NSError*)err
{
    NSString* str = [NSString stringWithFormat:@"Error: %@", err];
    NSLog(@"%@", str);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
}

// !必须在这里面实现，替换之前applicationWillEnterForeground：代理方法里面的实现
- (void)applicationWillResignActive:(UIApplication*)application
{
    
}

// !必须在这里实现替换之前的applicationWillEnterForeground里面的实现
- (void)applicationDidBecomeActive:(UIApplication*)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    backgroundMode = YES;
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    backgroundMode = NO;
}

- (void)applicationWillTerminate:(UIApplication*)application
{

}

- (void)registeReachabilityChangedNotification
{
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(reachabilityChangedReceived:)
               name:kReachabilityChangedNotification
             object:nil];
}

- (void)unregisteReachabilityChangedNotification
{
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
                  name:kReachabilityChangedNotification
                object:nil];
}

- (void)reachabilityChangedReceived:(NSNotification*)notification
{
    self.isConnectionAvailabel = YES;
    //  static BOOL isFirstTime = YES;

    Reachability* curReach = [notification object];
    NetworkStatus status = [curReach currentReachabilityStatus];

    //  if (isFirstTime) {
    //    isFirstTime = NO;
    //
    //    if (status != NotReachable)
    //      return;
    //  }

    if (status == NotReachable) {
        self.isConnectionAvailabel = NO;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络异常"
                                                       delegate:nil
                                              cancelButtonTitle:@"重试"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onReq:(BaseReq*)req {
   /*
            39      onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
            40      */
}

- (void)onResp:(BaseResp*)resp {
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if(resp.errCode == 0) {
            [[EventBus shared] emit:@selector(shareSuccess) withArguments:[NSArray array]];
        }
        return;
    }
    [[JCWeiXinLoginService shared] getWeiXinCodeFinishedWithResp:resp];
}

- (void)sendlinkToWX:(NSMutableDictionary *)dict {
    [[JCWeiXinLoginService shared] sendlinkToWX:dict];
}
@end
