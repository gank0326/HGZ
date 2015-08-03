//
//  JCLoginViewController.m
//  ChatApp
//
//  Created by joychuang on 15/3/10.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCLoginViewController.h"
#import "XGPush.h"
#import "JCSmsCodeViewController.h"
#import "JCWeiXinLoginService.h"
#import "JCRegisterViewController.h"
#import "JCNickNameViewController.h"
#import "JCForgetPwdViewController.h"

@interface JCLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *accoutLab;
@property (nonatomic, strong) UILabel *pwdLab;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *weixinBtn;
@property (nonatomic, strong) UIButton *forgetPwdBtn;
@property (nonatomic, strong) UILabel *tipLab;

@end

@implementation JCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.autoCreateBackButtonItem = NO;
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((MainWidth-591/2)/2, 30, 591/2, 90)];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = [UIImage imageNamed:@"loginBg.png"];
    [self.view addSubview:bgImageView];
    
    [bgImageView addSubview:self.accoutLab];
    [bgImageView addSubview:self.pwdLab];
    [bgImageView addSubview:self.phoneTextField];
    
    [bgImageView addSubview:self.passwordTextField];

    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.forgetPwdBtn];
    if ([WXApi isWXAppInstalled]){
        [self.view addSubview:self.tipLab];
        [self.view addSubview:self.weixinBtn];
    }
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [JCViewHelper getTextItemWithTarget:NSLocalizedString(@"注册", nil) forTarget:self withSEL:@selector(registerAction)];
    
    [self connect:@selector(weixinLoginSuccess:) from:[EventBus shared] with:@selector(weixinLoginSuccess:)];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)viewTapped:(UITapGestureRecognizer *)tapGr {
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.phoneTextField.text = [UserDefaultsUtils valueWithKey:USERMOBILE];
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

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth/2-130/2, CGRectGetMaxY(self.loginBtn.frame) + 50, 130, 20)];
        _tipLab.backgroundColor = [UIColor clearColor];
        _tipLab.textColor = [@"b3b3b3" toColor];
        _tipLab.font = [UIFont systemFontOfSize:13.0];
        _tipLab.textAlignment = NSTextAlignmentLeft;
        _tipLab.text = @"使用合作伙伴账号登录";
        
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_tipLab.frame) + 10, MainWidth/2-142/2, 1)];
        line1.image = [UIImage imageNamed:@"loginLine.png"];
        [self.view addSubview:line1];
        
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tipLab.frame)+5, CGRectGetMinY(_tipLab.frame) + 10, MainWidth/2-140/2, 1)];
        line2.image = [UIImage imageNamed:@"loginLine.png"];
        [self.view addSubview:line2];
    }
    return _tipLab;
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.accoutLab.frame), 0, 591/2 - CGRectGetMaxX(self.accoutLab.frame) , 45)];
        _phoneTextField.delegate = self;
        _phoneTextField.borderStyle = UITextBorderStyleNone;
        _phoneTextField.font = [UIFont systemFontOfSize:15.0];
        _phoneTextField.placeholder = NSLocalizedString(@"用户名", nil);
        _phoneTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _phoneTextField.backgroundColor = [UIColor clearColor];
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneTextField.textColor = [@"282828" toColor];
        _phoneTextField.text = [UserDefaultsUtils valueWithKey:USERMOBILE];
    }
    return _phoneTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pwdLab.frame), 45, 591/2 - CGRectGetMaxX(self.accoutLab.frame), 45)];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
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
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((MainWidth-298/2)/2, 240-64,298/2, 77/2)];
        [_loginBtn setTitle:NSLocalizedString(@"登  录", nil) forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _loginBtn.backgroundColor = RGBA(105, 212, 0, 1.0);
        _loginBtn.layer.cornerRadius = 4.0;
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)weixinBtn {
    if (!_weixinBtn) {
        //weixinLogin@2x 237 76
        _weixinBtn = [[UIButton alloc] initWithFrame:CGRectMake((MainWidth-237/2)/2, CGRectGetMaxY(self.tipLab.frame)+30,237/2, 76/2)];
        [_weixinBtn setTitle:NSLocalizedString(@"微信登录", nil) forState:UIControlStateNormal];
        [_weixinBtn setTitleColor:[@"b3b3b3" toColor] forState:UIControlStateNormal];
        //39 33
        [_weixinBtn setImage:[UIImage imageNamed:@"weixin.png"] forState:UIControlStateNormal];
        [_weixinBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        _weixinBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _weixinBtn.backgroundColor = [UIColor clearColor];
        [_weixinBtn setBackgroundImage:[UIImage imageNamed:@"weixinLogin.png"] forState:UIControlStateNormal];
        [_weixinBtn addTarget:self action:@selector(weixinLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weixinBtn;
}

- (UIButton *)forgetPwdBtn {
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainWidth- 125 , 124, 120, 40)];
        [_forgetPwdBtn setTitle:NSLocalizedString(@"忘记密码?", nil) forState:UIControlStateNormal];
        [_forgetPwdBtn setTitleColor:[@"b3b3b3" toColor] forState:UIControlStateNormal];
        _forgetPwdBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _forgetPwdBtn.backgroundColor = [UIColor clearColor];
        [_forgetPwdBtn addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdBtn;
}

- (void)loginAction {
    NSString *phone = [self.phoneTextField.text trim];
    NSString *pwd = [self.passwordTextField.text trim];
    if([CommonUtils isEmpty:phone]) {
        [AppUtils alert:@"请输入用户名" withConfirmBtnTitle:@"确定"];
        return;
    }
    if([CommonUtils isEmpty:pwd]) {
        [AppUtils alert:@"请输入密码" withConfirmBtnTitle:@"确定"];
        return;
    }
    [self.view endEditing:YES];
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:phone,@"username",pwd,@"password",[AppUtils getOpenId],@"deviceid",@"4",@"devicetype",nil];
    [JCViewHelper showHudOnFrontWindowWithText:@"正在登录..."];
    WEAKSELF
    [[NetWorkManager shareInstance] loadData:paramDic requestCode:kREQESUT_LOGIN success:^(NSDictionary*dic){
        [weakSelf finishReqestOk:dic];
    } fail:^(id fail) {
        [JCViewHelper hideHudOnFrontWindow];
    }];
}

- (void)registerAction {
    [self.view endEditing:YES];
    JCRegisterViewController *regist = [JCRegisterViewController new];
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneTextField.text.trim forKey:USERMOBILE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController pushViewController:regist animated:YES];
}

- (void)forgetAction {
    JCForgetPwdViewController *codeVC = [JCForgetPwdViewController new];
    [self.navigationController pushViewController:codeVC animated:YES];
}

- (void)weixinLoginAction {
    JCWeiXinLoginService *weixinLogin = [JCWeiXinLoginService shared];
    [weixinLogin login];
}

- (void)finishReqestOk:(NSDictionary *)resultDic
{
    [JCViewHelper hideHudOnFrontWindow];
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    if([dic isKindOfClass:[NSDictionary class]]) {
        [UserDefaultsUtils saveValue:self.phoneTextField.text.trim forKey:USERMOBILE];
        [self afterLogin:dic];
    } else {
        [JCViewHelper showTextTipOnFrontWindowAutoHide:resultDic[@"msg"]];
    }
}

- (void)afterLogin:(NSDictionary *)dic {
    [UserDefaultsUtils saveValue:[dic objectForKey:@"uid"] forKey:UID];
    [UserDefaultsUtils saveValue:[dic objectForKey:@"nickname"] forKey:USERNAME];
    [UserDefaultsUtils saveValue:[dic objectForKey:@"photopath1"] forKey:USERPHOTO];
    NSData *token = [UserDefaultsUtils valueWithKey:@"device"];
    [XGPush setAccount:[AppUtils getUserId]];
    if (token) {
        [XGPush registerDevice:token];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [[JCViewHelper mainTab] setSelectedIndex:0];
}

- (void)weixinLoginSuccess:(NSDictionary *)dic {
    [self afterLogin:dic];
}

@end
