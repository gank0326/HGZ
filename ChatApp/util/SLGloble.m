//
//  Globle.m
//  ChatApp
//
//  Created by joychuang on 15/3/9.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "SLGloble.h"

@implementation SLGloble

@synthesize globleWidth = _globleWidth;
@synthesize globleHeight = _globleHeight;
@synthesize nearbyBarHeight = _nearbyBarHeight;
@synthesize nearbyBarItemWidth = _nearbyBarItemWidth;
@synthesize nearbyBarItemGap = _nearbyBarItemGap;
@synthesize statusBarHeight = _statusBarHeight;
@synthesize navigatorBarHeight = _navigatorBarHeight;
@synthesize tabbarHeight = _tabbarHeight;
@synthesize datePickerHeight = _datePickerHeight;

+ (SLGloble *)shareInstance {
	static SLGloble *__singletion;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    __singletion = [[self alloc] init];
	});
	return __singletion;
}

- (id)init {
	if (self = [super init]) {
		self.nearbyBarHeight = 37;
		self.nearbyBarItemGap = 0;
		self.globleWidth = [UIScreen mainScreen].bounds.size.width;
		self.globleHeight = [UIScreen mainScreen].bounds.size.height;
		self.statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
		self.navigatorBarHeight = 44;
		self.datePickerHeight = 416;
		self.nearbyBarItemWidth = self.globleWidth / 5;
	}
	return self;
}

- (float)statusBarHeight{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (float)getHeightExeceptStatusAndNav {
	float height = self.globleHeight - self.statusBarHeight - self.navigatorBarHeight;
	return height;
}

- (float)getStatusAndNavHeight {
	return self.statusBarHeight + self.navigatorBarHeight;
}

@end
