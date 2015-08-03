//
//  JCDoorServiceViewController.m
//  MXR
//
//  Created by joychuang on 15/4/10.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCDoorServiceViewController.h"

@implementation JCDoorServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上门服务";
    [self addSubView];
}

- (void)addSubView {
    
    float gap = ((MainWidth - 20) - 125*2)/3;
    UIButton *meiRong = [self createBtnWithTag:0 with:@"index_doorservice_image.png" withHighLight:@"index_doorservice_selected_image.png"];
    [meiRong setFrame:CGRectMake(10, 35, 125/2, 163/2)];
    [self.view addSubview:meiRong];
    
    UIButton *xiZao = [self createBtnWithTag:1 with:@"index_mechant_image" withHighLight:@"index_mechant_selected_image"];
    [xiZao setFrame:CGRectMake(CGRectGetMaxX(meiRong.frame) + gap, 35, 125/2, 163/2)];
    [self.view addSubview:xiZao];
}

- (UIButton *)createBtnWithTag:(NSInteger)tag with:(NSString *)image withHighLight:(NSString *)highLight {
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectZero];
    btn.backgroundColor = [UIColor clearColor];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highLight] forState:UIControlStateHighlighted];
    btn.tag = tag;
    [btn addTarget:self action:@selector(serviceSelect:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)serviceSelect:(UIButton*)btn {
    switch (btn.tag) {
        case 0:
            
            break;
        case 1:
            
            break;

        default:
            break;
    }
}
@end
