//
//  JCAccountService.m
//  ChatApp
//
//  Created by joychuang on 15/3/16.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCAccountService.h"
#import "JCLoginViewController.h"
#import "AppDelegate.h"
#import "JCXgPushService.h"

@implementation JCAccountService

+ (id)shared {
    static JCAccountService *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] init];
    });
    return __singletion;
}


- (BOOL)isLogin
{
    NSString *uid = [UserDefaultsUtils valueWithKey:UID];
    if([CommonUtils isEmpty:uid]) {
        return NO;
    }
    return YES;
}

- (void)popoverLoginView:(UIViewController *)controller {
    JCNavigationViewController *nav = [[JCNavigationViewController alloc] initWithRootViewController:[JCLoginViewController new]];
    [controller presentViewController:nav animated:YES completion:^{
        [controller.navigationController popToRootViewControllerAnimated:NO];
        [[JCViewHelper mainTab] setSelectedIndex:0];
    }];
}

- (void)logout:(UIViewController *)controller
{
    [UserDefaultsUtils saveValue:@"" forKey:UID];
    [[JCXgPushService shared] unRegisterXgPush];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self popoverLoginView:controller];    
}

-(void)loadAppToken
{
    NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:[AppUtils getOpenId],@"deviceid",@"4",@"devicetype", nil];
    [[NetWorkManager shareInstance] loadData:paramDic requestCode:kREQESUT_GETTOKEN success:^(id responseDic) {
        NSString*token = [[responseDic objectForKey:@"data"] objectForKey:@"apptoken"];
        [UserDefaultsUtils saveValue:token forKey:USERDEFAULT_TOKEN];
    } fail:^(id errorString) {
        
    }];
}

@end
