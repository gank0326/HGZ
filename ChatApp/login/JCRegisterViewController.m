//
//  JCRegisterViewController.m
//  ChatApp
//
//  Created by joychuang on 15/3/12.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCRegisterViewController.h"
#import "JCSmsCodeViewController.h"
#import "SLRichTextLabel.h"
#import "JCUserAgreementViewController.h"

@interface JCRegisterViewController ()

@property (nonatomic, strong) UILabel *accoutLab;
@property (nonatomic, strong) UILabel *pwdLab;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) SLRichTextLabel *phoneLeagl_label;
@end

@implementation JCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = RGBA(238, 239, 244, 1);
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((MainWidth-591/2)/2, 30, 591/2, 90)];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = [UIImage imageNamed:@"loginBg.png"];
    [self.view addSubview:bgImageView];
    
    [bgImageView addSubview:self.accoutLab];
    [bgImageView addSubview:self.pwdLab];
    [bgImageView addSubview:self.phoneTextField];
    [bgImageView addSubview:self.passwordTextField];
    
    
    [self.phoneLeagl_label setFrame:CGRectMake(CGRectGetMinX(bgImageView.frame) + 10, CGRectGetMaxY(bgImageView.frame)+20, 200, 20)];
    [self.view addSubview:self.phoneLeagl_label];
    
    [self.view addSubview:self.loginBtn];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)viewTapped:(UITapGestureRecognizer *)tapGr {
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


- (UILabel *)accoutLab {
    if (!_accoutLab) {
        _accoutLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 45)];
        _accoutLab.backgroundColor = [UIColor clearColor];
        _accoutLab.textColor = [@"4c4c4c" toColor];
        _accoutLab.font = [UIFont systemFontOfSize:15.0];
        _accoutLab.textAlignment = NSTextAlignmentLeft;
        _accoutLab.text = @"账号";
    }
    return _accoutLab;
}

- (UILabel *)pwdLab {
    if (!_pwdLab) {
        _pwdLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 46, 50, 45)];
        _pwdLab.backgroundColor = [UIColor clearColor];
        _pwdLab.textColor = [@"4c4c4c" toColor];
        _pwdLab.font = [UIFont systemFontOfSize:15.0];
        _pwdLab.textAlignment = NSTextAlignmentLeft;
        _pwdLab.text = @"密码";
    }
    return _pwdLab;
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.accoutLab.frame), 0, 591/2 - CGRectGetMaxX(self.accoutLab.frame) , 45)];
        _phoneTextField.borderStyle = UITextBorderStyleNone;
        _phoneTextField.font = [UIFont systemFontOfSize:15.0];
        _phoneTextField.placeholder = NSLocalizedString(@"请输入手机号码", nil);
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.backgroundColor = [UIColor clearColor];
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneTextField.textColor = [@"282828" toColor];
    }
    return _phoneTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pwdLab.frame), 45, 591/2 - CGRectGetMaxX(self.accoutLab.frame), 45)];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.textAlignment = NSTextAlignmentLeft;
        _passwordTextField.font = [UIFont systemFontOfSize:15.0];
        _passwordTextField.placeholder = NSLocalizedString(@"请填写密码", nil);
        _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordTextField.textColor = [@"282828" toColor];
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _passwordTextField;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((MainWidth-298/2)/2, 250,298/2, 77/2)];
        [_loginBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _loginBtn.backgroundColor = RGBA(105, 212, 0, 1.0);
        _loginBtn.layer.cornerRadius = 4.0;
        [_loginBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (SLRichTextLabel *)phoneLeagl_label {
    NSString *legalInfo = NSLocalizedString(@"点击下一步表示同意用户协议", nil);
    if (!_phoneLeagl_label) {
        _phoneLeagl_label = [[SLRichTextLabel alloc] initWithFrame:CGRectNull withTapEvent:YES];
        _phoneLeagl_label.font = [UIFont systemFontOfSize:12.0* kCurrentWidthScale];
        _phoneLeagl_label.text = legalInfo;
        _phoneLeagl_label.numberOfLines = 0;
        _phoneLeagl_label.textAlignment = NSTextAlignmentLeft;
        _phoneLeagl_label.delegate = (id <SLRichTextLabelDelegate> )self;
        _phoneLeagl_label.backgroundColor = [UIColor clearColor];
        UIColor *fontColor = [@"b6b6b3" toColor];
        _phoneLeagl_label.textColor = fontColor;
        NSUInteger s = [legalInfo length] - [NSLocalizedString(@"用户协议", nil) length];
        NSUInteger len = [NSLocalizedString(@"用户协议", nil) length];
        _phoneLeagl_label.autoDetectLinks = YES;
        [_phoneLeagl_label addCustomLink:NSLocalizedString(@"用户协议", nil)  forRange:NSMakeRange(s, len) linkColor:RGBA(105, 212, 0, 1.0)];
    }
    return _phoneLeagl_label;
}

- (void)nextAction {
    [self.view endEditing:YES];
    NSString *phone = [self.phoneTextField.text trim];
    NSString *pwd = [self.passwordTextField.text trim];
    if([CommonUtils isEmpty:phone]) {
        [AppUtils alert:@"请输入用户名" withConfirmBtnTitle:@"确定"];
        return;
    }
    if(![AppUtils isMobileNumber:phone]) {
        [AppUtils alert:@"手机号输入错误" withConfirmBtnTitle:@"确定"];
        return;
    }
    if([CommonUtils isEmpty:pwd]) {
        [AppUtils alert:@"请输入密码" withConfirmBtnTitle:@"确定"];
        return;
    }
    if (pwd.length>20||pwd.length<6) {
        [AppUtils alert:@"密码长度为6-20" withConfirmBtnTitle:@"确定"];
        return;
    }
    JCSmsCodeViewController *code = [JCSmsCodeViewController new];
    code.phone = self.phoneTextField.text.trim;
    code.pwd = self.passwordTextField.text.trim;
    [self.navigationController pushViewController:code animated:YES];
}

#pragma mark SLRichTextLabel delegate
- (void)richTextAttributedLabel:(SLRichTextLabel *)label clickedOnLink:(id)linkData {
    [self.navigationController pushViewController:[JCUserAgreementViewController new] animated:YES];
}

@end
