//
//  UINavigationController+XJPush.m
//  OrderApp
//
//  Created by howard on 14-8-29.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import "UINavigationController+XJPush.h"

@implementation UINavigationController (XJPush)
- (void)pushViewControllerHideBar:(UIViewController *)viewController animated:(BOOL)animated;
{
    viewController.hidesBottomBarWhenPushed = YES;
    [self pushViewController:viewController animated:animated];
}
@end
