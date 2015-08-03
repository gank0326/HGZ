//
//  JCForgetPwdViewController.m
//  ChatApp
//
//  Created by joychuang on 15/3/13.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCForgetPwdViewController.h"
#import "JCSmsCodeViewController.h"

@interface JCForgetPwdViewController ()
{
    UIView *userView;
}
@property (nonatomic, strong) UILabel *accoutLab;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIButton *loginBtn;
@end

@implementation JCForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = RGBA(238, 239, 244, 1);
    
    userView = [[UIView alloc] initWithFrame:CGRectMake(20, 30, MainWidth - 40, 45)];
    userView.backgroundColor = [UIColor whiteColor];
    userView.layer.borderColor = [@"dddddd" toColor].CGColor;
    userView.layer.borderWidth = 1.0;
    [userView addSubview:self.phoneTextField];
    [self.view addSubview:userView];
    [userView addSubview:self.accoutLab];
    [self.view addSubview:self.loginBtn];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)viewTapped:(UITapGestureRecognizer *)tapGr {
    [self.phoneTextField resignFirstResponder];
}

- (UILabel *)accoutLab {
    if (!_accoutLab) {
        _accoutLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 45)];
        _accoutLab.backgroundColor = [UIColor clearColor];
        _accoutLab.textColor = [@"4c4c4c" toColor];
        _accoutLab.font = [UIFont systemFontOfSize:15.0];
        _accoutLab.textAlignment = NSTextAlignmentLeft;
        _accoutLab.text = @"手机号";
    }
    return _accoutLab;
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.accoutLab.frame)+10, 0, 591/2 - CGRectGetMaxX(self.accoutLab.frame)-30 , 45)];
        _phoneTextField.borderStyle = UITextBorderStyleNone;
        _phoneTextField.font = [UIFont systemFontOfSize:15.0];
        _phoneTextField.placeholder = NSLocalizedString(@"请输入手机号", nil);
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.backgroundColor = [UIColor clearColor];
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneTextField.textColor = [@"4c4c4c" toColor];
    }
    return _phoneTextField;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((MainWidth-298/2)/2, 240 - 64,298/2, 77/2)];
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

- (void)nextAction {
    [self.view endEditing:YES];
    NSString *phone = [self.phoneTextField.text trim];
    if([CommonUtils isEmpty:phone]) {
        [AppUtils alert:@"请输入用户名" withConfirmBtnTitle:@"确定"];
        return;
    }
    if(![AppUtils isMobileNumber:phone]) {
        [AppUtils alert:@"手机号输入错误" withConfirmBtnTitle:@"确定"];
        return;
    }
    JCSmsCodeViewController *code = [JCSmsCodeViewController new];
    code.phone = self.phoneTextField.text.trim;
    code.type = 1;
    [self.navigationController pushViewController:code animated:YES];
}
@end
