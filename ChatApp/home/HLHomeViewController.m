//
//  JCHomeViewController.m
//  MXR
//
//  Created by joychuang on 15/4/6.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "HLHomeViewController.h"
#import "EScrollerView.h"
#import "JCDoorServiceViewController.h"
#import "JCAnswerViewController.h"
#import "JCAccountService.h"

@interface HLHomeViewController ()<EScrollerViewDelegate>{
    
}
@property (nonatomic ,strong) UIScrollView *scroll;
@property (nonatomic ,strong) EScrollerView *headScroll;
@property (nonatomic, strong) UIView *serviceView;
@property (nonatomic, strong) UIView *answerView;
@property (nonatomic, strong) UIView *businessView;
@end

@implementation HLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好股指";
    [self.scroll addSubview:self.headScroll];
    [self addSubView];
    [self.scroll addSubview:self.answerView];
}

- (void)navToAnswerDetail:(UITapGestureRecognizer *)tapGr {
    JCAnswerViewController *answer = [JCAnswerViewController new];
    [self.navigationController pushViewController:answer animated:YES];
}

- (void)addSubView {

    float gap = ((MainWidth - 20) - 125*2)/3;
    UIButton *meiRong = [self createBtnWithTag:0 with:@"index_doorservice_image.png" withHighLight:@"index_doorservice_selected_image.png"];
    [meiRong setFrame:CGRectMake(10, 5, 125/2, 163/2)];
    [self.serviceView addSubview:meiRong];
    
    UIButton *xiZao = [self createBtnWithTag:1 with:@"index_mechant_image" withHighLight:@"index_mechant_selected_image"];
    [xiZao setFrame:CGRectMake(CGRectGetMaxX(meiRong.frame) + gap, 5, 125/2, 163/2)];
    [self.serviceView addSubview:xiZao];
    
    UIButton *yiLiao = [self createBtnWithTag:2 with:@"index_doorservice_image.png" withHighLight:@"index_doorservice_selected_image.png"];
    [yiLiao setFrame:CGRectMake(CGRectGetMaxX(xiZao.frame) + gap, 5, 125/2, 163/2)];
    [self.serviceView addSubview:yiLiao];
    
    UIButton *jiYang = [self createBtnWithTag:3 with:@"index_travel_image" withHighLight:@"index_travel_selected_image"];
    [jiYang setFrame:CGRectMake(CGRectGetMaxX(yiLiao.frame) + gap, 5, 125/2, 163/2)];
    [self.serviceView addSubview:jiYang];
    
    
    UIButton *tuoYun = [self createBtnWithTag:4 with:@"index_activity_image.png" withHighLight:@"index_activity_selected_image"];
    [tuoYun setFrame:CGRectMake(10, 48, 125/2, 163/2)];
    [self.businessView addSubview:tuoYun];
    
    UIButton *xunLian = [self createBtnWithTag:5 with:@"index_mechant_image" withHighLight:@"index_mechant_selected_image"];
    [xunLian setFrame:CGRectMake(CGRectGetMaxX(meiRong.frame) + gap, CGRectGetMinY(tuoYun.frame), 125/2, 163/2)];
    [self.businessView addSubview:xunLian];
    
    UIButton *sheYin = [self createBtnWithTag:6 with:@"index_doorservice_image.png" withHighLight:@"index_doorservice_selected_image.png"];
    [sheYin setFrame:CGRectMake(CGRectGetMaxX(xiZao.frame) + gap, CGRectGetMinY(tuoYun.frame), 125/2, 163/2)];
    [self.businessView addSubview:sheYin];
    
    UIButton *leYuan = [self createBtnWithTag:7 with:@"index_travel_image" withHighLight:@"index_travel_selected_image"];
    [leYuan setFrame:CGRectMake(CGRectGetMaxX(yiLiao.frame) + gap, CGRectGetMinY(tuoYun.frame), 125/2, 163/2)];
    [self.businessView addSubview:leYuan];
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

- (UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, [[SLGloble shareInstance] getHeightExeceptStatusAndNav])];
        [self.view addSubview:_scroll];
        [_scroll setContentSize:CGSizeMake(MainWidth, 580)];
        _scroll.backgroundColor = [UIColor clearColor];
    }
    return _scroll;
}

- (EScrollerView *)headScroll {
    if (!_headScroll) {
        _headScroll = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0.5, MainWidth, 150) ImageArray:@[@"ad1.jpg",@"ad2.jpg",@"ad3.jpg",@"ad4.jpg"] TitleArray:@[@"宠物医院",@"宠物美容",@"宠物寄养",@"宠物寄养"]];
        _headScroll.delegate = self;
    }
    return _headScroll;
}

- (UIView *)serviceView {
    if (!_serviceView) {
        _serviceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headScroll.frame), MainWidth, 90)];
        _serviceView.backgroundColor = [UIColor whiteColor];
        [self.scroll addSubview:_serviceView];
    }
    return _serviceView;
}

- (UIView *)answerView {
    if (!_answerView) {
        _answerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.serviceView.frame)+15, MainWidth, 100)];
        _answerView.backgroundColor = [UIColor whiteColor];
        
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 39)];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 9, 22, 22)];
        icon.image = [UIImage imageNamed:@"index_hot_title_image.png"];
        [head addSubview:icon];
        
        UILabel *headLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 40)];
        headLab.backgroundColor = [UIColor clearColor];
        headLab.font = [UIFont systemFontOfSize:15.0];
        headLab.text = @"互助问答";
        headLab.textAlignment = NSTextAlignmentLeft;
        headLab.textColor = [@"282828" toColor];
        [head addSubview:headLab];
        [_answerView addSubview:head];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, MainWidth, 1)];
        line.backgroundColor = [@"f0f0f0" toColor];
        [_answerView addSubview:line];
        
        UIImageView *queIcon = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(head.frame) +8, 15, 15)];
        queIcon.image = [UIImage imageNamed:@"index_hot_question_image.png"];
        [_answerView addSubview:queIcon];
        
        UILabel *queLab = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(head.frame)+2, MainWidth - 50, 26)];
        queLab.backgroundColor = [UIColor clearColor];
        queLab.font = [UIFont systemFontOfSize:14.0];
        queLab.text = @"我们家金毛有时候老是舔舌头，跑出去找母狗么办？";
        queLab.textAlignment = NSTextAlignmentLeft;
        queLab.textColor = [@"282828" toColor];
        [_answerView addSubview:queLab];
        
        UIImageView *ansIcon = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(queLab.frame) +6, 15, 15)];
        ansIcon.image = [UIImage imageNamed:@"index_hot_answer_image.png"];
        [_answerView addSubview:ansIcon];
        
        UILabel *ansLab = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(queLab.frame), MainWidth - 50, 26)];
        ansLab.backgroundColor = [UIColor clearColor];
        ansLab.font = [UIFont systemFontOfSize:14.0];
        ansLab.text = @"您好，继续补充微量元素并且观察狗狗状态，发现异常请及时就医疗！";
        ansLab.textAlignment = NSTextAlignmentLeft;
        ansLab.textColor = [@"282828" toColor];
        [_answerView addSubview:ansLab];
        
        [self.scroll addSubview:_answerView];
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navToAnswerDetail:)];
        tapGr.cancelsTouchesInView = NO;
        [_answerView addGestureRecognizer:tapGr];
    }
    return _answerView;
}

- (UIView *)businessView {
    if (!_businessView) {
        _businessView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.answerView.frame)+15, MainWidth, 136)];
        _businessView.backgroundColor = [UIColor whiteColor];
        
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 39)];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 9, 22, 22)];
        icon.image = [UIImage imageNamed:@"index_hot_title_image.png"];
        [head addSubview:icon];
        
        UILabel *headLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 40)];
        headLab.backgroundColor = [UIColor clearColor];
        headLab.font = [UIFont systemFontOfSize:15.0];
        headLab.text = @"热门服务";
        headLab.textAlignment = NSTextAlignmentLeft;
        headLab.textColor = [@"282828" toColor];
        [head addSubview:headLab];
        [_businessView addSubview:head];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, MainWidth, 1)];
        line.backgroundColor = [@"f0f0f0" toColor];
        [_businessView addSubview:line];
        
        [self.scroll addSubview:_businessView];
    }
    return _businessView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"好股指";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark -event
- (void)EScrollerViewDidClicked:(NSUInteger)index{
    //to do 从1开始
}

- (void)serviceSelect:(UIButton*)btn {
    switch (btn.tag) {
        case 0:
        {
//            JCDoorServiceViewController *doorService = [JCDoorServiceViewController new];
//            [self.navigationController pushViewController:doorService animated:YES];
            [[JCAccountService shared] popoverLoginView:self];
        }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        default:
            break;
    }
}

@end
