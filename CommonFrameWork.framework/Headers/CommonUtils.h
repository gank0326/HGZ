//
//  CommonUtils.h
//  DondibuyFramework
//
//  Created by howard on 15/1/8.
//  Copyright (c) 2015年 howard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonUtils : NSObject
//获取应用版本
+(NSString*)getAppVersion;
//MD5加密
+(NSString *)md5:(NSString*)inPutText ;
//转成base64
+(NSString*)toBase64String:(NSData*)data;
//判断字符串是否为空
+(BOOL)isEmpty:(NSString*)str;
//判断是否为字母
+(BOOL)isEnglishLetter:(NSString*)word;
//把字典转成字符串
+(NSString*)getJsonString:(NSDictionary*)dic;
//把字符串转成字典
+(NSDictionary*)getJsonDiction:(NSString*)string;
//把数组转成json字符串
+(NSString*)getJsonByArray:(NSArray*)array;
//计算文本高度
+(CGFloat)labelCalculateHeight:(NSString*)text font:(UIFont*)font MaxWidth:(CGFloat)maxWidth;
//计算文本宽度
+(CGFloat)labelCalculateWidth:(NSString*)text font:(UIFont*)font MaxHeight:(CGFloat)maxHeight;
//把汉字转成拼音
+(NSString*)toPingYingString:(NSString*)text;
//高斯模糊图片
+(UIImage*)getBlurImage:(UIImage*)fromImage blurRadius:(CGFloat)blurRadius;
//把dictionary值为null转成""
+(NSMutableDictionary*)formatResponseDictionary:(NSDictionary*)dic;
/**
 *  检查是否有更新版本
 *
 *  @param appid        appstore上应用id
 *  @param successBlock 检查到更新版本回调方法
 *  @param failBlock    未检查到更新版本回调方法
 */
+(void)checkVersion:(NSString*)appid success:(void (^)())successBlock failure:(void (^)())failBlock;
/**
 *  加载app引导页
 *
 *  @param applicationWindown APP window
 *  @param imageArr           引导页图片名称数组
 *  @param iconImage          页码正常图
 *  @param selectedIconImage  页码选中图
 */
+(void)loadGuideViewToView:(UIWindow*)applicationWindown imageArr:(NSArray*)imageArr pageIconImage:(UIImage*)iconImage pageSelectedIconImage:(UIImage*)selectedIconImage;
@end
