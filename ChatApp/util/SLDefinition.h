//
//  SLDefinition.h
//  ChatApp
//
//  Created by joychuang on 15/3/9.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#ifndef Shanliao_SLDefinition_h
#define Shanliao_SLDefinition_h

#define kGlobalQueue    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define MainWidth ScreenWidth
#define MainHeight (ScreenHeight - 20)
#define NavigationHeight 44
#define StatusHeight_default 20
#define StateBarHeight 20
#define isIphone5  (MainHeight == 548 ? YES : NO)
#define isIphone6  (MainWidth == 375 ? YES : NO)
#define isIphone6Plus  (ScreenWidth == 414 ? YES : NO)
#define Iphone5_ABOVE  (MainHeight > 500 ? YES : NO)
#define TABBar_Height ([SLGloble shareInstance].tabbarHeight)
#define BottomHeight 56

#define IOS7_ABOVE (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
#define IOS8_ABOVE (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
#define IOS6_ABOVE (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_6_0)
#define IOS6_BEFORE (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_6_0)
#define Scale_Relative_320 (MainWidth/320.0f)

#define imageWithTheme(key) [JCSkinUtil getImageForSkinWithKey : key]
#define currentSkinMap [[JCSkinManager shared] getSkin:[self skinKey]]
#define imageWithThemeKey(key) imageWithTheme([currentSkinMap objectForKey:key])
#define colorWithThemeKey(key) [JCViewUtil colorWithHexString :[currentSkinMap objectForKey:key]]
#define colorWithGlobalThemeKey(key) [JCViewUtil colorWithHexString :[[JCSkinUtil getNormalSkin] objectForKey:key]]
#define imageWithGlobalThemeKey(key) imageWithTheme([[JCSkinUtil getNormalSkin] objectForKey:key])
#define valueForGlobalTheme(key) [[JCSkinUtil getNormalSkin] objectForKey : key]

#define NoNullString(x) ((x && [x isKindOfClass:[NSString class]]) ? x : @"")

#define DEBUG_LOG(log) ([SLLogger logWithNSString:(log)])

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define BLOCKSELF typeof(self) __block blockSelf = self;
#define __Weak_ObJ(obj) typeof(obj) __weak weakObj = obj;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#define checkNotNull(key) (key != nil && [key length] > 0)

#define isStringEmpty(string) (string == nil || [string isEqualToString:@""])
#endif

#define IOS8_Later_Compile "1"

#define Scene_Shared_SNS_URL @"http://liao.com/s%d"
#define Plaza_Shared_SNS_URL @"http://liao.com/g%d"
#define Post_Shared_SNS_URL @"http://liao.com/t%d"

#define SD_WEBP "enable"

#define kCurrentWidthScale [JCViewUtil currentWidthScale]
#define kCurrentHeightScale [JCViewUtil currentHeightScale]

//微信
#ifndef LoginDemo_Define_h
#define LoginDemo_Define_h
#define kAppDescription @"com.joychuang.community"
#define kWeiXinAppId    @"wx7148a0e96e6458d8"
#define kWeiXinAppSecret           @"3ea1ea220fb39693db2f037acd29643f"
#define kWeiXinAccessToken   @"WeiXinAccessToken"
#define kWeiXinOpenId             @"WeiXinOpenId"
#define kWeiXinRefreshToken  @"WeiXinRefreshToken"
#endif

#define kXGPushId    2200072534
#define kXGPushKey   @"I689T81SHECR"
#import "NSObject+CMSignals.h"
#import "EventBus.h"
#import "Colors.h"
#import "NSStringWrapper.h"
#define SEND_IMAGE_MAX_WIDTH 1200
#define SEND_IMAGE_MAX_HEIGHT 1200
#import "JCViewUtil.h"
#import "JCViewHelper.h"
#import "UIViewController+SL.h"
#import "UIImageView+SL.h"
#import "JCNetworkChecker.h"

#define APPLICATION_ENTER_BACKGROUND_MSG @"applicationDidEnterBackground"
#define APPLICATION_ENTER_FOREGROUND_MSG @"applicationDidEnterForeground"
#define APPLICATION_WILL_RESIGN_MSG      @"applicationWillResign"
#define APPLICATION_DID_BECOME_ACTIVE    @"applicationDidBecomeActive"
#define kAudio_Session_Begin_Interruption   @"kAudioSessionBeginInterruption"
#define kAudio_Session_End_Interruption   @"kAudioSessionEndInterruption"

#define kThemeColor        RGBA(0, 174, 240, 1.0)

static  int SMILEY_HEIGHT = 20;
static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}
