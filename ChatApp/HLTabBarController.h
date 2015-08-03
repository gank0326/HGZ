//
//  XJTabBarController.h
//  ChatApp
//
//  Created by howard on 14/11/18.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCSkinDelegate.h"

@interface HLTabBarController : UITabBarController<JCSkinDelegate>

- (void)setupAppearance;
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@property (nonatomic, strong) void (^appearCallback)();

@end
