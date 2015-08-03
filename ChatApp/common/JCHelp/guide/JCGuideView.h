//
//  HZUIViewForGuide.h
//  Constraint
//
//  Created by huazi on 14-5-28.
//  Copyright (c) 2014年 AutoLayoutTestDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCMyPageControl.h"
@interface JCGuideView : UIView

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) JCMyPageControl *pageControl;

- (void)initSubviews:(UIWindow *)window picArr:(NSArray*)imageArr pageIcon:(UIImage*)icon pageSelectedIcon:(UIImage*)selectedIcon;

@end
