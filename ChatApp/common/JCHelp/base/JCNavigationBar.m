//
//  SLNavigationBar.h
//  Shanliao
//
//  Created by gsw on 10/13/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "JCNavigationBar.h"
#import "JCViewUtil.h"
#import "JCSkinManager.h"

#define kNearZero 0.000001f

@interface JCNavigationBar ()
@property (nonatomic, strong) UIView *line;
@end

@implementation JCNavigationBar

- (void)setCustomBarImage:(UIImage *)image {
	[self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
	if (IOS6_ABOVE) {
		self.shadowImage = [[UIImage alloc] init];
	}
	if (!_line) {
		_line = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 0.5, MainWidth, 0.5)];
		[self addSubview:_line];
	}
	_line.backgroundColor = colorWithGlobalThemeKey(@"nav_line_color");
}

- (void)setCustomBarTintColor:(UIColor *)barTintColor {
	if (!IOS7_ABOVE) {
		self.tintColor = barTintColor;
		if (IOS6_ABOVE) {
			self.shadowImage = [[UIImage alloc] init];
		}
	}
	else {
		[self setBarTintColor:barTintColor];
	}
}

- (void)setLineColor:(UIColor *)color {
	_line.backgroundColor = color;
}

@end
