//
//  TMVewUtil.h
//  FlashChat
//
//  Created by gsw on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

struct SLSuitableRectInput {
    CGFloat totalWidth;
    CGFloat suggestWidth;
    CGFloat gap;
};

typedef struct SLSuitableRectInput SLSuitableRectInput;

struct SLSuitableRectOutput {
    CGFloat suitableWidth;
    int count;
};

typedef struct SLSuitableRectOutput SLSuitableRectOutput;

CG_INLINE SLSuitableRectOutput SLSuitableRectOutputMake(CGFloat width, CGFloat count)
{
    struct SLSuitableRectOutput rect;
    rect.suitableWidth = width; rect.count = count;
    return rect;
}

CG_INLINE SLSuitableRectInput SLSuitableRectInputMake(CGFloat totalWidth, CGFloat suggestWidth, CGFloat gap)
{
    struct SLSuitableRectInput rect;
    rect.totalWidth = totalWidth; rect.suggestWidth = suggestWidth;
    rect.gap = gap;
    return rect;
}

@interface JCViewUtil : NSObject

+ (void)alert:(NSString *)msg;

+ (void)alert:(NSString *)msg withConfirmBtnTitle:(NSString *)title;

+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hex;

+ (float)getHeightForString:(NSString *)str font:(float)font width:(float)width;

+ (float)getAttributedStringHeightForString:(NSString *)str font:(float)fontSize width:(float)width;

+ (NSDateComponents *)getNSDateComponents:(long long int)bir;

/**
 *  获取年龄
 *
 *  @param sec 单位毫秒
 *
 *  @return 年龄
 */
+ (int)getAge:(long long)sec;

/**
 *  获取一个文件名字，这个文件标示是本地文件
 *
 *  @return 文件名
 */
+ (NSString *)generateTempLocalName;

/**
 *  判断一个文件是否是一个本地文件
 *
 *  @param url 文件名字
 *
 *  @return 是否本地文件
 */
+ (BOOL)isTempLocalUrl:(NSString *)url;

/**
 *  返回一个录音的本地文件路径
 *
 *  @return
 */
+ (NSString *)getRecoderUrl;

/**
 *  返回一个当前沙盒录音的本地文件路径
 *
 *  @return
 */
+ (NSString *)formatRecoderUrl:(NSString *)urlString;


/**
 *  字符串转化为日期
 *
 *  @param uiDate
 *
 *  @return
 */
+ (NSDate*) convertDateFromString:(NSString*)uiDate;

/**
 *  获取一个格式化为今天 昨天，MM-dd的日期
 *
 *  @param date 日期
 *
 *  @return 格式化日期
 */
+ (NSString *)getFormatReadTime:(NSDate *)date;

/**
 *  获取一个格式化为今天 昨天，MM-dd的日期
 *
 *  @param date 秒为单位
 *
 *  @return 格式化日期
 */
+ (NSString *)getFormatReadTimeWithLong:(long long int)date;

/**
 *  将URL转化为webp URL
 *
 *  @param url
 *
 *  @return
 */
+ (NSURL *)getWebpUrl:(NSURL *)url;

+ (NSString *)getFormatReadTimeForPlazaTrendWithLong:(long long int)date;

/**
 *  判断是否是同一天
 *
 *  @param date1
 *  @param date2
 *
 *  @return
 */
+ (BOOL)isSameDayWithLong:(long long int)date1 andLong:(long long int)date2;

/**
 *  获取同一天中的最大时间
 *
 *  @param date
 *
 *  @return 
 */
+ (long long int)getSameDayMaxTime:(long long int)date;

+ (void)networkErr;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color withWidth:(CGSize)size;

+ (void)adjustViewWidth:(UIView *)view withDelta:(int)delta;

+ (void)adjustViewLeft:(UIView *)view withDelta:(int)delta;

+ (NSString *)placeholderString;

+ (void)addCornerRadiusWith:(UIView *)view byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

+ (void)formatStateBar;

+ (void)formatTitleAttributes:(UIColor *)color withNav:(UINavigationController *)nav;

+ (BOOL)isWifiConnected;

+ (BOOL)isIncallorHotspot;

/**
 *  返回一个适合 input 条件的 output，output会指定个数与宽度
 *
 *  @param input 适合的宽度，总宽度，间隙
 *
 *  @return 推荐能够展示个数与宽度
 */
+ (SLSuitableRectOutput)suitableCountFitRect:(SLSuitableRectInput)input;

+ (BOOL)isCurrentDay:(NSDate *)aDate;

/*当前设备对于iphone5的比列*/
+ (float)currentWidthScale;

+ (float)currentHeightScale;

@end
