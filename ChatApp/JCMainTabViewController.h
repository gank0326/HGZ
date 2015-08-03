//
//  JCMainTabViewController.h
//  ChatApp
//
//  Created by joychuang on 15/3/10.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCMainTabViewController : UITabBarController

- (void)setupAppearance;
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@property (nonatomic, strong) void (^appearCallback)();

@end
