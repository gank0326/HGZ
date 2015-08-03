//
//  AppUtils.m
//  DondibuyShopping
//
//  Created by howard on 14-10-9.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import "AppUtils.h"
#import "CommonCrypto/CommonDigest.h"
#import "SvUDIDTools.h"
#import "OpenUDID.h"
@implementation AppUtils

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    NSString * MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
        
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(NSString*)getOpenId
{
    NSLog(@"openID:%@",[SvUDIDTools UDID]);
//    return [@"ios_" stringByAppendingString:[SvUDIDTools UDID]];
    return [OpenUDID value];
}

+(NSString*)getToken
{
    return [UserDefaultsUtils valueWithKey:USERDEFAULT_TOKEN];
}
+(NSString*)getUserId
{
    NSString*userId =  [UserDefaultsUtils valueWithKey:UID];
    if([CommonUtils isEmpty:userId]) {
        return @"";
    }
    return userId;
}

+(NSString*)getUserName {
    NSString*userName =  [UserDefaultsUtils valueWithKey:USERNAME];
    if([CommonUtils isEmpty:userName]) {
        return @"";
    }
    return userName;
}

+(NSString*)formatMessageDate:(NSString*)date
{
//    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
//    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *dateSend =[NSDate dateWithTimeIntervalSince1970:[date longLongValue]/1000];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:dateSend];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd";
    }
    NSString *time = [formatter stringFromDate:dateSend];
    return time;

}
+(BOOL)isLateFromDate:(NSString*)fromDate toDate:(NSString*)toDate
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date1 =[dateFormat dateFromString:fromDate];
    NSDate *date2 =[dateFormat dateFromString:toDate];
    if([date1 isEqualToDate:date2]|| [date1 laterDate:date2]==date1) {
        return NO;
    } else {
        return YES;
    }

}
+(long long)getSecondWithDate:(NSString*)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *dateSend =[dateFormat dateFromString:date];
    return (long long)[dateSend timeIntervalSince1970]*1000;
}
+(long long)getSecondWithCurrentDate
{
    return (long long)[[NSDate date] timeIntervalSince1970]*1000;
}
+(NSString *)getUserImageStr
{
    return [UserDefaultsUtils valueWithKey:USERPHOTO];
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

+ (void)alert:(NSString *)msg withConfirmBtnTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:msg
                          delegate:self
	                         cancelButtonTitle:title
	                         otherButtonTitles:nil];
    [alert show];
}

@end
