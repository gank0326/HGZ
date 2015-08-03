//
//  JCSmsCodeViewController.m
//  ChatApp
//
//  Created by joychuang on 15/3/10.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCSmsCodeViewController.h"
#import "JCSetPwdViewController.h"
#import "SLRichTextLabel.h"
#import "SLTimerContext.h"
#import "WTReTextField.h"
#import "JCNickNameViewController.h"
#import "JCViewHelper.h"

@interface JCSmsCodeViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) SLRichTextLabel *note_lbl;
@property (nonatomic, strong) UIView *phoneBgView;
@property (nonatomic, strong) UIImageView *smsIcon;
@property (nonatomic, strong) WTReTextField *sms_textfield;
@property (nonatomic, strong) UIButton *resend_btn;
@property (nonatomic, strong) NSMutableDictionary *timer_dict;
@property (nonatomic) NSUInteger leftTime;

@end

@implementation JCSmsCodeViewController

- (id)init {
    self = [super init];
    return self;
}

#pragma mark -viewLife

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"短信验证";
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.backgroundColor = RGBA(238, 239, 244, 1);
    self.note_lbl.frame = CGRectMake(15 * kCurrentWidthScale, 18 * kCurrentHeightScale, 290, 20 * kCurrentHeightScale);
    [self.view addSubview:self.note_lbl];
    [self.phoneBgView addSubview:self.smsIcon];
    self.sms_textfield.frame = CGRectMake(CGRectGetMaxX(self.smsIcon.frame) + 13 * kCurrentWidthScale, 0, MainWidth - 30, CGRectGetHeight(self.phoneBgView.frame));
    [self.phoneBgView addSubview:self.sms_textfield];
    self.resend_btn.frame = CGRectMake((MainWidth-298/2)/2, CGRectGetMaxY(self.phoneBgView.frame) + 30*kCurrentHeightScale, 298/2, 77/2);
    [self.view addSubview:self.resend_btn];
    
    self.navigationItem.rightBarButtonItem = [JCViewHelper getTextItemWithTarget:@"下一步" forTarget:self withSEL:@selector(nextAction)];
    
    [self fetchSmsCode];
    [self resetResenderTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.note_lbl.text = [NSString stringWithFormat:@"验证码短信已发送到: +86 %@",self.phone];
    [self.note_lbl setTextColor:RGBA(105, 212, 0, 1.0) range:NSMakeRange(10, 16)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)dealloc {
    for (SLTimerContext *ctx in[self.timer_dict allValues]) {
        [ctx.timer invalidate];
    }
    [self.timer_dict removeAllObjects];
}

#pragma mark - initUI

- (UIView *)phoneBgView {
    if (!_phoneBgView) {
        _phoneBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.note_lbl.frame) + 15 * kCurrentHeightScale, MainWidth, 44 * kCurrentHeightScale)];
        _phoneBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_phoneBgView];
        UIView *line_view_top = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_phoneBgView.frame), MainWidth, 0.5)];
        line_view_top.backgroundColor = [@"dcded8" toColor];
        [self.view addSubview:line_view_top];
        UIView *line_view_bot = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_phoneBgView.frame), MainWidth, 0.5)];
        line_view_bot.backgroundColor = [@"dcded8" toColor];
        [self.view addSubview:line_view_bot];
    }
    return _phoneBgView;
}

- (UIImageView *)smsIcon {
    if (!_smsIcon) {
        _smsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14 * kCurrentWidthScale, 12 * kCurrentHeightScale, 20 * kCurrentWidthScale, 20 * kCurrentHeightScale)];
        _smsIcon.image = [UIImage imageNamed:@"icon_login_sms.png"];
    }
    return _smsIcon;
}

- (SLRichTextLabel *)note_lbl {
    if (!_note_lbl) {
        _note_lbl = [[SLRichTextLabel alloc] initWithFrame:CGRectNull withTapEvent:NO];
        _note_lbl.font = [UIFont systemFontOfSize:13.0*kCurrentWidthScale];
        _note_lbl.textColor = [@"787878" toColor];
        _note_lbl.backgroundColor = [UIColor clearColor];
        _note_lbl.textAlignment = NSTextAlignmentLeft;
    }
    return _note_lbl;
}

- (WTReTextField *)sms_textfield {
    if (!_sms_textfield) {
        _sms_textfield = [[WTReTextField alloc] init];
        _sms_textfield.textColor = [@"282828" toColor];
        _sms_textfield.pattern = @"^\\d{6}$";
        _sms_textfield.placeholder = NSLocalizedString(@"请输入验证码", nil);
        _sms_textfield.keyboardType = UIKeyboardTypeNumberPad;
        _sms_textfield.font = [UIFont systemFontOfSize:15.0*kCurrentWidthScale];
        _sms_textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _sms_textfield;
}

- (UIButton *)resend_btn {
    if (!_resend_btn) {
        _resend_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resend_btn setTitle:NSLocalizedString(@"发送验证码", nil) forState:UIControlStateNormal];
        [_resend_btn addTarget:self action:@selector(resend) forControlEvents:UIControlEventTouchUpInside];
        [_resend_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _resend_btn.backgroundColor = RGBA(105, 212, 0, 1.0);
        _resend_btn.titleLabel.font = [UIFont systemFontOfSize:15.0*kCurrentWidthScale];
        _resend_btn.layer.cornerRadius = 4.0;
    }
    return _resend_btn;
}

#pragma mark - aux

Boolean verifyCode(NSString *text) {
    NSString *regex = @"^[0-9]{6}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:text];
    
    return isMatch;
}

- (NSMutableDictionary *)timer_dict {
    if (!_timer_dict) {
        _timer_dict = [NSMutableDictionary new];
    }
    return _timer_dict;
}

- (void)resetResenderTimer {
    
    NSString *key = checkNotNull(self.phone)?self.phone:@"default";
    SLTimerContext *timerCtx = [self.timer_dict objectForKey:key];
    if (timerCtx) {
        //server timer up before client
        [timerCtx.timer invalidate];
    }
    else {
        timerCtx = [SLTimerContext new];
    }
    [self.timer_dict setObject:timerCtx forKey:key];
    timerCtx.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime:) userInfo:key repeats:YES];
    
    timerCtx.timeElipsed = 0;
    [timerCtx.timer fire];
}

- (void)countTime:(NSTimer *)timer {
    NSString *key = [timer userInfo];
    SLTimerContext *ctx = self.timer_dict[key];
    if (++ctx.timeElipsed >= 60) {
        [timer invalidate];
        [self.timer_dict removeObjectForKey:key];
        if ([key isEqualToString:self.phone]) {
            self.resend_btn.enabled = YES;
            [self.resend_btn setTitle:NSLocalizedString(@"发送验证码", nil) forState:UIControlStateNormal];
            [self.resend_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.resend_btn.backgroundColor = RGBA(105, 212, 0, 1.0);
        }
    }
    else {
        if ([key isEqualToString:self.phone]) {
            NSString *title = [NSString stringWithFormat:@"%@(%d)", NSLocalizedString(@"重发验证码", nil), (int)(60 - ctx.timeElipsed)];
            self.resend_btn.enabled = YES;
            [self.resend_btn setTitle:title forState:UIControlStateNormal];
            [self.resend_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.resend_btn.backgroundColor = RGBA(191, 191, 191, 1.0);
            self.resend_btn.enabled = NO;
        }
    }
}

- (void)resend {
    [self fetchSmsCode];
}

- (void)fetchSmsCode {
    if(![AppUtils isMobileNumber:self.phone]) {
        [AppUtils alert:@"手机号输入错误" withConfirmBtnTitle:@"确定"];
        return;
    }
    NSString *typeStr = self.type>0?@"2":@"1";
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:[AppUtils getOpenId],@"deviceid",self.phone,@"mobile",typeStr,@"rflag",nil];
    
    WEAKSELF
    [JCViewHelper showHudOnFrontWindowWithText:@"发送中..."];
    [[NetWorkManager shareInstance] loadData:paramDic requestCode:kREQESUT_GETCODE success:^(NSDictionary*dic){
        [JCViewHelper hideHudOnFrontWindow];
        [weakSelf fetchSmsCodeSuccess:dic];
    } fail:^(id fail) {
        [JCViewHelper hideHudOnFrontWindow];
    }];
}

- (void)fetchSmsCodeSuccess:(NSDictionary *)resultDic {
    if([[resultDic objectForKey:@"status"]intValue]!=0) {
        [JCViewHelper showError:[resultDic objectForKey:@"msg"]];
    }
    else {
        [JCViewHelper showSuccess:[NSString stringWithFormat:@"短信已发送到您的手机%@，请注意查收",self.phone]];
    }
}

- (void)nextAction {
    if(![AppUtils isMobileNumber:self.phone]) {
        [AppUtils alert:@"手机号输入错误" withConfirmBtnTitle:@"确定"];
        return;
    }
    if([CommonUtils isEmpty:self.sms_textfield.text.trim]) {
        [AppUtils alert:@"请输入验证码" withConfirmBtnTitle:@"确定"];
        return;
    }
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:self.phone,@"mobile",self.sms_textfield.text.trim,@"verifycode",nil];
    
    WEAKSELF
    [JCViewHelper showHudOnFrontWindowWithText:@"正在验证..."];
    [[NetWorkManager shareInstance] loadData:paramDic requestCode:kREQEUST_MESSAGECODE_VALIDATE success:^(NSDictionary*dic){
        [JCViewHelper hideHudOnFrontWindow];
        [weakSelf validateSmsCodeSuccess:(NSDictionary *)dic];
    } fail:^(id fail) {
        [JCViewHelper hideHudOnFrontWindow];
    }];
}

- (void)validateSmsCodeSuccess:(NSDictionary *)resultDic {
    if([[resultDic objectForKey:@"status"]intValue]==0) {
        if (self.type >0) {
            JCSetPwdViewController *SetPasswordVC = [JCSetPwdViewController new];
            SetPasswordVC.phoneNum = self.phone;
            SetPasswordVC.type = self.type;
            [self.navigationController pushViewController:SetPasswordVC animated:YES];
        }
        else {
            //注册
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self registerAccount];
            });
        }
        
    } else {
        [AppUtils alert:@"验证码错误" withConfirmBtnTitle:@"确定"];
    }
}

- (void)registerAccount {
    NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:self.phone,@"username",self.pwd,@"password",nil];
    
    WEAKSELF
    [[NetWorkManager shareInstance] loadData:paramDic requestCode:kREQESUT_REGISTER success:^(NSDictionary*dic){
        [weakSelf registerSuccess:(NSDictionary *)dic];
    } fail:^(id fail) {
    }];
}

- (void)registerSuccess:(NSDictionary *)resultDic {
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    if([dic isKindOfClass:[NSDictionary class]]) {
        NSString *uid = [dic objectForKey:@"uid"];
        [UserDefaultsUtils saveValue:uid forKey:UID];
        JCNickNameViewController *userInfo = [JCNickNameViewController new];
        [self.navigationController pushViewController:userInfo animated:YES];
    } else {
        [AppUtils alert:@"注册失败" withConfirmBtnTitle:@"确定"];
    }
}

@end