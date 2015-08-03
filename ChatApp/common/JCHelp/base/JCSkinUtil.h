//
//  JCSkinUtil.h
//  Shanliao
//
//  Created by gsw on 3/13/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BTN_BG_NORMAL @"maleBgColor"
#define BTN_BG_ON @"maleBgColorOn"
#define SEX_BG_NORMAL @"sexBgColor"


@interface JCSkinUtil : NSObject

+ (NSDictionary *)getNormalSkin;

+ (UIImage *)getImageForSkinWithKey:(NSString *)key;

+ (void)setBackgroundColor:(UIView *)view withColor:(NSString *)hexString;

+ (void)setUIImageView:(UIImageView *)imageView withImageName:(NSString *)imageName;

+ (void)setLayerColor:(CALayer *)layer withColor:(NSString *)hexString;

@end
