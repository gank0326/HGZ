//
//  JCShareViewController.m
//  ChatApp
//
//  Created by joychuang on 15/3/24.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCShareViewController.h"
#import "UIImage+Resize.h"
#import "UIImage+TM.h"
#import "MobClick.h"

@interface JCShareViewController ()
{
    NSMutableDictionary *shareDic;
}

@property (nonatomic, strong) UIButton *weixinBtn;
@property (nonatomic, strong) UIButton *timeLineBtn;
@end

@implementation JCShareViewController

- (id)initWithShare:(NSMutableDictionary *)dict {
    if (self = [super init]) {
        shareDic = dict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享";
    
    self.weixinBtn.frame = CGRectMake(50, 60, 90, 90);
    [self resetLayout:self.weixinBtn];
    [self.view addSubview:self.weixinBtn];
    
    self.timeLineBtn.frame = CGRectMake(CGRectGetMaxX(self.weixinBtn.frame)+20, 60, 90, 90);
    [self resetLayout:self.timeLineBtn];
    [self.view addSubview:self.timeLineBtn];
    
    UIImage *originalImage = shareDic[@"thumbImage"];
    UIImage *croppedImage = [originalImage croppedImage:CGRectMake(0, 0, originalImage.size.width, originalImage.size.height)];
    UIImage *desImage = [croppedImage resizedImage:CGSizeMake(150, 110) imageOrientation:originalImage.imageOrientation];
    shareDic[@"thumbImage"] = desImage;
    [self connect:@selector(shareSuccess) from:[EventBus shared] with:@selector(shareSuccess)];
}

- (void)resetLayout:(UIButton *)button {
    CGSize imageSize = button.imageView.frame.size;
    CGFloat spacing = 6.0f;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);
    
    CGSize titleSize = button.titleLabel.frame.size;
    button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 10.0, 0.0, -titleSize.width-10);
}

- (UIButton *)createAdminPanelBtn:(NSString *)title withSelector:(SEL)selector withImage:(UIImage *)image {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[@"282828" toColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIButton *)weixinBtn {
    if (!_weixinBtn) {
        _weixinBtn = [self createAdminPanelBtn:NSLocalizedString(@"分享给朋友", nil) withSelector:@selector(sendLink:) withImage:[UIImage imageNamed:@"icon_share_wechat.png"]];
    }
    return _weixinBtn;
}

- (UIButton *)timeLineBtn {
    if (!_timeLineBtn) {
        _timeLineBtn = [self createAdminPanelBtn:NSLocalizedString(@"分享到朋友圈", nil) withSelector:@selector(sendLink:) withImage:[UIImage imageNamed:@"icon_share_wechat_friend.png"]];
    }
    return _timeLineBtn;
}


- (void)sendLink:(UIButton *)btn {
    if (btn == self.weixinBtn) {
        shareDic[@"scene"] = @"1";
    } else if (btn == self.timeLineBtn) {
        shareDic[@"scene"] = @"2";
    }
    [[EventBus shared] emit:@selector(sendlinkToWX:) withArguments:@[shareDic]];
    [MobClick event:@"sendlinkToWX" attributes:@{@"activityTitle":shareDic[@"title"]}];
}

- (void)shareSuccess {
    [JCViewHelper showSuccess:@"分享成功！"];
}

@end
