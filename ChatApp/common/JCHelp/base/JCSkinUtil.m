//
//  JCSkinUtil.m
//  Shanliao
//
//  Created by gsw on 3/13/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "JCSkinUtil.h"
#import "JCViewUtil.h"
#import "Colors.h"
#import "JCSkinManager.h"

static NSString *GLOBAL = @"Global";

@implementation JCSkinUtil

+ (NSDictionary *)getNormalSkin {
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	[result addEntriesFromDictionary:[[JCSkinManager shared] getSkin:GLOBAL]];
    int sex = 1; //男人
	if (sex == 1) {
		[result setObject:[result objectForKey:@"btn_chat_boy_off_image"] forKey:BTN_BG_NORMAL];
		[result setObject:[result objectForKey:@"btn_chat_boy_on_image"] forKey:BTN_BG_ON];
		[result setObject:[result objectForKey:@"man_color_off"] forKey:SEX_BG_NORMAL];
	}
	else {
		[result setObject:[result objectForKey:@"btn_chat_girl_off_image"] forKey:BTN_BG_NORMAL];
		[result setObject:[result objectForKey:@"btn_chat_girl_on_image"] forKey:BTN_BG_ON];
		[result setObject:[result objectForKey:@"woman_color_off"] forKey:SEX_BG_NORMAL];
	}
	return result;
}

+ (UIImage *)getImageForSkinWithKey:(NSString *)key {
	UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", [[JCSkinManager shared] currentSkin], key]];
	if (!image) {
		image = [UIImage imageNamed:key];
		if (!image) {
			image = [UIImage imageNamed:@"bg_photo_144.png"];
		}
	}
	return image;
}

+ (void)setBackgroundColor:(UIView *)view withColor:(NSString *)hexString {
	if (![hexString isEqualToString:@"none"]) {
		view.backgroundColor = [JCViewUtil colorWithHexString:hexString alpha:1.f];
	}
	else {
		view.backgroundColor = [UIColor clearColor];
	}
}

+ (void)setLayerColor:(CALayer *)layer withColor:(NSString *)hexString {
	if (![hexString isEqualToString:@"none"]) {
		layer.backgroundColor = [JCViewUtil colorWithHexString:hexString alpha:1.f].CGColor;
	}
	else {
		layer.backgroundColor = [UIColor clearColor].CGColor;
	}
}

+ (void)setUIImageView:(UIImageView *)imageView withImageName:(NSString *)imageName {
	if (![imageName isEqualToString:@"none"]) {
		imageView.image = [UIImage imageNamed:imageName];
	}
	else {
		imageView.image = nil;
	}
}

@end
