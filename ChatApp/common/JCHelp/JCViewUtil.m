//
//  TMVewUtil.m
//  FlashChat
//
//  Created by gsw on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JCViewUtil.h"
#import "JCViewHelper.h"
#import "OpenUDID.h"
#import "Reachability.h"
#import "JCSkinManager.h"
#import "SLRichTextLabel.h"
#import "AppDelegate.h"
#import "JCUtils.h"


#define DEVICE_ID @"device_id"
#define LOCAL_URL_ENDFiX @"_shanliao_local"
#define LAST_CLIENT_VERSION @"last_client_version"

@implementation JCViewUtil

+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha {
    if ([hex length] == 8) {
    }
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hex {
    if (hex == nil || hex.length < 6) {
        return [UIColor clearColor];
    }
    return [hex toColor];
}

+ (float)getHeightForString:(NSString *)str font:(float)font width:(float)width {
    if (IOS7_ABOVE) {
        CGSize size = CGSizeMake(width, 9999);
        CGRect textRect = [str
                           boundingRectWithSize:size
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                           context:nil];
        return textRect.size.height;
    }else {
        CGSize s = [str sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        
        return s.height;
    }
}

+ (float)getAttributedStringHeightForString:(NSString *)str font:(float)fontSize width:(float)width {
	if (str == nil || [@"" isEqualToString : str]) {
		return 0;
	}
    SLRichTextLabel *lbl = [[SLRichTextLabel alloc] initWithFrame:CGRectZero];
    [lbl setText:str];
    lbl.font = [UIFont systemFontOfSize:fontSize];;
    CGSize size = [lbl sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;
}

+ (NSDateComponents *)getNSDateComponents:(long long int)bir {
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"Asia/Chongqing"];
    [calendar setTimeZone:tzGMT];
    NSDateComponents *components = [calendar components:NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[[NSDate alloc] initWithTimeIntervalSince1970:bir / 1000]];
    return components;
}

+ (int)getAge:(long long)sec {
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:sec / 1000];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date toDate:[NSDate date] options:0];
    int year = (int)[components year];
    return year;
}

+ (NSString *)generateTempLocalName {
    return [[JCUtils uuid] stringByAppendingString:LOCAL_URL_ENDFiX];
}

+ (BOOL)isTempLocalUrl:(NSString *)url {
    return url != nil && [url rangeOfString:LOCAL_URL_ENDFiX].length > 0;
}

+ (NSString *)getRecoderUrl {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [[paths objectAtIndex:0] stringByAppendingString:@"/tempAudio/"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [[cachePath stringByAppendingString:[JCViewUtil generateTempLocalName]] stringByAppendingString:@".amr"];
}

+ (NSString *)formatRecoderUrl:(NSString *)urlString {
    if ([JCViewUtil isTempLocalUrl:urlString]) {
        int index = [urlString lastIndexOfString:@"/tempAudio/"];
        NSRange range = NSMakeRange(index, urlString.length - index);
        urlString = [urlString substringWithRange:range];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        return  [[paths objectAtIndex:0] stringByAppendingString:urlString];
    }
    return urlString;
}

+ (NSString *)getFormatReadTime:(NSDate *)date {
    return [JCViewUtil getFormatReadTimeWithLong:[date timeIntervalSince1970]];
}

+ (NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:uiDate];
    if (!destDate) {
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
         destDate= [dateFormatter dateFromString:uiDate];
    }
    return destDate;
}

//毫秒计算
+ (NSString *)getFormatReadTimeWithLong:(long long int)refDatelong {
    NSString *dateString;
    if (refDatelong <= 0) {
        return @"";
    }
    //当前时间
    long currentTime = [[NSDate date] timeIntervalSince1970];
    int timeInterval = (int)(currentTime - refDatelong);
    
    
    NSDate *refDate = [NSDate dateWithTimeIntervalSince1970:refDatelong];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    
    NSDate *today = [cal dateFromComponents:components];
    if ([refDate compare:today] == NSOrderedDescending) {
        if (timeInterval < 60) {
            dateString = NSLocalizedString(@"刚刚", nil);
            return dateString;
        }
        else if (timeInterval < 60 * 60) {
            dateString = [NSString stringWithFormat:@"%d分钟前", timeInterval / 60];
            return dateString;
        }
        else if (timeInterval < 24 * 60 * 60) {
            dateString = [NSString stringWithFormat:@"%d小时前", timeInterval / (60 * 60)];
            return dateString;
        }
    }
    
    NSDate *yesterday = [today dateByAddingTimeInterval:(-86400)];
    if ([refDate compare:yesterday] == NSOrderedDescending) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"H:mm"];
        NSString *str = [formatter stringFromDate:refDate];
        dateString = [NSLocalizedString(@"昨天", nil) stringByAppendingString:str];
        return dateString;
    }
    
    NSDate *dayBeforeYesterday = [today dateByAddingTimeInterval:(-86400 * 2)];
    if ([refDate compare:dayBeforeYesterday] == NSOrderedDescending) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"H:mm"];
        NSString *str = [formatter stringFromDate:refDate];
        dateString = [NSLocalizedString(@"昨天", nil) stringByAppendingString:str];
        return dateString;
    }
    
    NSString *thisYearString = [[[NSDate date]description] substringToIndex:4];
    NSString *refYearString = [[refDate description] substringToIndex:4];
    if ([thisYearString isEqualToString:refYearString]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M月d日"];
        dateString = [formatter stringFromDate:refDate];
        return dateString;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年M月"];
    dateString = [formatter stringFromDate:refDate];
    return dateString;
}
//TODO 后缀不能写死.jpg
+ (NSURL *)getWebpUrl:(NSURL *)url {
    if (!url) {
        return nil;
    }
    NSString *absoluteString = url.absoluteString;
    int dotPosition = [absoluteString lastIndexOfString:@"."];
    if (dotPosition <= 0) {
        return url;
    }
    NSString *prefixString = [absoluteString substringWithRange:NSMakeRange(0, dotPosition)];
    absoluteString = [prefixString stringByAppendingString:@".webp"];
    url = [NSURL URLWithString:absoluteString];
    return url;
}

+ (NSString *)getFormatReadTimeForPlazaTrendWithLong:(long long)refDatelong {
    NSString *dateString;
    if (refDatelong <= 0) {
        return @"";
    }
    NSDate *refDate = [NSDate dateWithTimeIntervalSince1970:refDatelong];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    
    NSDate *today = [cal dateFromComponents:components];
    if ([refDate compare:today] == NSOrderedDescending) {
        return NSLocalizedString(@"today", nil);
    }
    
    NSDate *yesterday = [today dateByAddingTimeInterval:(-86400)];
    if ([refDate compare:yesterday] == NSOrderedDescending) {
        return NSLocalizedString(@"yestday", nil);
    }
    
    NSDate *dayBeforeYesterday = [today dateByAddingTimeInterval:(-86400 * 2)];
    if ([refDate compare:dayBeforeYesterday] == NSOrderedDescending) {
        return NSLocalizedString(@"yesterday", nil);
    }
    
    NSString *thisYearString = [[[NSDate date]description] substringToIndex:4];
    NSString *refYearString = [[refDate description] substringToIndex:4];
    if ([thisYearString isEqualToString:refYearString]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M.d"];
        dateString = [formatter stringFromDate:refDate];
        return dateString;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.M"];
    dateString = [formatter stringFromDate:refDate];
    return dateString;
}

+ (BOOL)isSameDayWithLong:(long long int)date1 andLong:(long long int)date2 {
    NSDate *d1 = [NSDate dateWithTimeIntervalSince1970:date1];
    NSDate *d2 = [NSDate dateWithTimeIntervalSince1970:date2];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:d1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:d2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (long long)getSameDayMaxTime:(long long)date {
    NSDate *refDate = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年M月d日"];
    NSString *todayStr = [formatter stringFromDate:refDate];
    NSDate *today = [formatter dateFromString:todayStr];
    
    return ([today timeIntervalSince1970] + 86400 - 1)*1000;
//    return ([today timeIntervalSince1970] + 24*60*60 - 1)*1000;
}

+ (void)networkErr {
    [JCViewHelper showNetworkError];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color withWidth:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (void)adjustViewWidth:(UIView *)view withDelta:(int)delta {
    CGRect frame = view.frame;
    frame.size.width += delta;
    view.frame = frame;
}

+ (void)adjustViewLeft:(UIView *)view withDelta:(int)delta {
    CGRect frame = view.frame;
    frame.origin.x += delta;
    view.frame = frame;
}

+ (NSString *)placeholderString {
    unichar objectReplacementChar = 0xFFFC;
    return [NSString stringWithCharacters:&objectReplacementChar length:1];
}

+ (void)addCornerRadiusWith:(UIView *)view byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    view.layer.masksToBounds = YES;
}

+ (void)formatStateBar {
    if (IOS7_ABOVE) {
        if (checkNotNull(valueForGlobalTheme(@"status_bar_style"))) {
            if ([@"2" isEqualToString : valueForGlobalTheme(@"status_bar_style")]) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }
            else {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }
        }
        else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
    }
    else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
}

+ (void)formatTitleAttributes:(UIColor *)color withNav:(UINavigationController *)nav {
    NSDictionary *navbarTitleTextAttributes
    = @{ UITextAttributeTextColor : color,
         UITextAttributeTextShadowColor : [UIColor clearColor],
         UITextAttributeFont : [UIFont boldSystemFontOfSize:19],
         UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] };
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    nav.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
}

+ (BOOL)isWifiConnected {
    Reachability *networkReachability = [Reachability new];
    return  networkReachability.currentReachabilityStatus == kReachableViaWiFi;
}

+ (BOOL)isIncallorHotspot {
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    return rect.size.height == 40;
}

+ (SLSuitableRectOutput)suitableCountFitRect:(SLSuitableRectInput)input {
    int count = (input.totalWidth * 1.0f+2*input.gap) / (input.suggestWidth + input.gap);
    CGFloat suggestWidth = ((input.totalWidth * 1.0f) - (count - 1) * input.gap)/count;
    return SLSuitableRectOutputMake(suggestWidth, count);
}

+ (BOOL)isCurrentDay:(NSDate *)aDate {
    if (aDate == nil) return NO;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    return ([today isEqualToDate:otherDate]);
}

/*当前设备对于iphone5的比列*/
+ (float)currentWidthScale {
    return MainWidth/320.f;
}

+ (float)currentHeightScale {
    float scale = 1.0;
    if (isIphone6) {
        scale = 667.0/568;
    } else if (isIphone6Plus) {
        scale = 736.0/568;
    }
    return scale;
}

@end
