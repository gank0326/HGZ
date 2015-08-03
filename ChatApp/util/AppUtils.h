//
//  AppUtils.h
//  DondibuyShopping
//
//  Created by howard on 14-10-9.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtils : NSObject
//获取openid
+(NSString*)getOpenId;
+(NSString*)getToken;
+(NSString*)getUserId;
+(NSString*)getUserName;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//格式化消息时间
+(NSString*)formatMessageDate:(NSString*)date;
+(BOOL)isLateFromDate:(NSString*)fromDate toDate:(NSString*)toDate;
+(long long)getSecondWithDate:(NSString*)date;
+(long long)getSecondWithCurrentDate;
+(NSString *)getUserImageStr;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color withWidth:(CGSize)size;
+ (void)alert:(NSString *)msg withConfirmBtnTitle:(NSString *)title;
@end
