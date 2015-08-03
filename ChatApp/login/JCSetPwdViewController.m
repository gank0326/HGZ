//
//  JCSetPwdViewController.m
//  ChatApp
//
//  Created by joychuang on 15/3/10.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCSetPwdViewController.h"

@interface JCSetPwdViewController ()
{
    UIView *userView;
    UIView *pwdView;
}

@property (strong, nonatomic) UITextField *passwordTextField1;
@property (strong, nonatomic) UITextField *passwordTextField2;
@property (strong, nonatomic) UIButton *submitButton;
@end

@implementation JCSetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置密码";
    self.view.backgroundColor = RGBA(238, 239, 244, 1);
    
    userView = [[UIView alloc] initWithFrame:CGRectMake(20, 30, MainWidth - 40, 45)];
    userView.backgroundColor = [UIColor whiteColor];
    userView.layer.borderColor = [@"dddddd" toColor].CGColor;
    userView.layer.borderWidth = 1.0;
    [userView addSubview:self.passwordTextField1];
    [self.view addSubview:userView];
    
    pwdView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(userView.frame) + 20, MainWidth - 40, 45)];
    pwdView.backgroundColor = [UIColor whiteColor];
    pwdView.layer.borderColor = [@"dddddd" toColor].CGColor;
    pwdView.layer.borderWidth = 1.0;
    [pwdView addSubview:self.passwordTextField2];
    [self.view addSubview:pwdView];
    
    [self.view addSubview:self.submitButton];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)viewTapped:(UITapGestureRecognizer *)tapGr {
    [self.passwordTextField1 resignFirstResponder];
    [self.passwordTextField2 resignFirstResponder];
}

- (UITextField *)passwordTextField1 {
    if (!_passwordTextField1) {
        _passwordTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(userView.frame) - 15, 45)];
        _passwordTextField1.secureTextEntry = YES;
        _passwordTextField1.textAlignment = NSTextAlignmentLeft;
        _passwordTextField1.font = [UIFont systemFontOfSize:15.0];
        _passwordTextField1.placeholder = NSLocalizedString(@"请输入密码", nil);
        _passwordTextField1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordTextField1.textColor = [@"282828" toColor];
        _passwordTextField1.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _passwordTextField1;
}

- (UITextField *)passwordTextField2 {
    if (!_passwordTextField2) {
        _passwordTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(pwdView.frame) - 15, 45)];
        _passwordTextField2.secureTextEntry = YES;
        _passwordTextField2.textAlignment = NSTextAlignmentLeft;
        _passwordTextField2.font = [UIFont systemFontOfSize:15.0];
        _passwordTextField2.placeholder = NSLocalizedString(@"请再次输入密码", nil);
        _passwordTextField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordTextField2.textColor = [@"282828" toColor];
        _passwordTextField2.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _passwordTextField2;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initWithFrame:CGRectMake((MainWidth-298/2)/2, 250, 298/2, 77/2)];
        [_submitButton setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _submitButton.backgroundColor = RGBA(105, 212, 0, 1.0);
        _submitButton.layer.cornerRadius = 4.0;
        [_submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (void)submitAction {
    NSString *newPwd = self.passwordTextField1.text.trim;
    NSString *confirmPwd = self.passwordTextField2.text.trim;
    
    if([CommonUtils isEmpty:newPwd]) {
        [JCViewHelper showTextTipOnFrontWindowAutoHide:@"请输入密码"];
        return;
    }
    if (newPwd.length>20||newPwd.length<6) {
        [JCViewHelper showTextTipOnFrontWindowAutoHide:@"密码长度为6-20"];
        return;
    }
    if([CommonUtils isEmpty:confirmPwd]) {
        [JCViewHelper showTextTipOnFrontWindowAutoHide:@"请输入确定密码"];
        return;
    }
    if(![newPwd isEqualToString:confirmPwd]) {
        [JCViewHelper showTextTipOnFrontWindowAutoHide:@"两次密码不一致"];
        return;
    }
    NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:self.phoneNum,@"username",self.passwordTextField1.text,@"newpassword",nil];
    
    WEAKSELF
    [JCViewHelper showHudOnFrontWindowWithText:@""];
    [[NetWorkManager shareInstance] loadData:paramDic requestCode:kREQESUT_FORGETPASSWORD success:^(NSDictionary*dic){
        [JCViewHelper hideHudOnFrontWindow];
        [weakSelf resetPwdSuccess:(NSDictionary *)dic];
    } fail:^(id fail) {
        [JCViewHelper hideHudOnFrontWindow];
    }];
}

- (void)resetPwdSuccess:(NSDictionary *)dic {
    [JCViewHelper showSuccess:@"设置成功"];
    [self performSelector:@selector(finishAction) withObject:nil afterDelay:1];
}

- (void)finishAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

@end
