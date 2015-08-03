//
//  CommonDefine.h
//  DondibuyFramework
//
//  Created by howard on 15/1/8.
//  Copyright (c) 2015年 howard. All rights reserved.
//

#import <Foundation/Foundation.h>
#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

#define DeviceRect   [UIScreen mainScreen].bounds
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth [UIScreen mainScreen].bounds.size.w
@interface CommonDefine : NSObject

@end
