//
//  UIWindow+SL.m
//  Shanliao
//
//  Created by gsw on 5/19/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "UIWindow+SL.h"

@implementation UIWindow (SL)

- (UIViewController *)visibleViewController {
	UIViewController *rootViewController = self.rootViewController;
	return [UIWindow getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
	if ([vc isKindOfClass:[UINavigationController class]]) {
		return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *)vc)visibleViewController]];
	}
	else if ([vc isKindOfClass:[UITabBarController class]]) {
		return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *)vc)selectedViewController]];
	}
	else {
		if (vc.presentedViewController) {
			return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
		}
		else {
			return vc;
		}
	}
}

@end
