//
//  JCMeViewController.m
//  MXR
//
//  Created by joychuang on 15/4/6.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "HLMeViewController.h"

@implementation HLMeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员中心";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"会员中心";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}
@end
