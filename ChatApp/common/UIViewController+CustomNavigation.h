//
//  UIViewController+CustomNavigation.h
//  OrderApp
//
//  Created by howard on 14-8-28.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CustomNavigation)
// NavigationItem需要button
- (void)setNavigationItemCostomView:(NSArray *)arrayBtnStr;
// 点击NavigationItem上的哪个button
- (void)navigationItemBtnItem:(UIButton *)sender;

//设置nav上右上角按钮
- (void)setNavRightItemWith:(NSString *)str  andImage:(UIImage *)image;
- (void)rightItemClick:(id)sender;

- (void)setNavLeftItemWith:(NSString *)str andImage:(UIImage *)image;
-(void)leftItemClick:(id)sender;
-(void)setNavTitle:(NSString*)title;
@end
