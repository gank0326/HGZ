//
//  LoginVC.m
//  OrderApp
//
//  Created by apple on 14-9-14.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import "LoginVC.h"
#import "UIViewController+CustomNavigation.h"
#import "PhoneCodeVC.h"
#import "TagPicker3.h"
#import "XGPush.h"
#import "XJBaseViewController.h"
#import "Tab1ViewController.h"
@interface LoginVC ()

@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.titleForNav = @"登录";
    self.isSupportTapHideKeyboard = YES;
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(237, 239, 244, 1);
    [self setNavRightItemWith:@"注册" andImage:nil];
    [self.logoImageView.layer setCornerRadius:20.0];
    [self.logoImageView.layer setMasksToBounds:YES];
    self.userNameTextField.text = [UserDefaultsUtils valueWithKey:USERMOBILE];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[IQKeyboardManager sharedManager] setEnable:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
-(void)rightItemClick:(id)sender
{
    [self.view endEditing:YES];
    PhoneCodeVC *phoneCodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"phoneCodeVC"];
    phoneCodeVC.type = 0;
    [self.navigationController pushViewController:phoneCodeVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginAction:(UIButton *)sender {
    NSString *token = [UserDefaultsUtils valueWithKey:USERDEFAULT_TOKEN];
    if([CommonUtils isEmpty:self.userNameTextField.text]) {
        [self.view makeToast:@"请输入用户名" duration:1 position:@"center"];
        return;
    }
    if([CommonUtils isEmpty:self.passwordTextField.text]) {
        [self.view makeToast:@"请输入密码" duration:1 position:@"center"];
        return;
    }
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:self.userNameTextField.text,@"username",self.passwordTextField.text,@"password",[AppUtils getOpenId],@"deviceid",token,@"apptoken",@"4",@"devicetype",nil];
    [self loadData:paramDic requestCode:kREQESUT_LOGIN showAnimation:YES];
    
    [self.view endEditing:YES];
   
    
    
}
-(void)finishReqestOk:(NSDictionary *)resultDic
{
    [super finishReqestOk:resultDic];
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    if([dic isKindOfClass:[NSDictionary class]]) {
        [UserDefaultsUtils saveValue:[dic objectForKey:@"uid"] forKey:UID];
        [UserDefaultsUtils saveValue:[dic objectForKey:@"nickname"] forKey:USERNAME];
        [UserDefaultsUtils saveValue:[dic objectForKey:@"photopath1"] forKey:USERPHOTO];
        [UserDefaultsUtils saveValue:self.userNameTextField.text forKey:USERMOBILE];
        [XGPush setAccount:[AppUtils getUserId]];
        NSData *token = [UserDefaultsUtils valueWithKey:@"device"];
        if (token)
            [XGPush registerDevice:token];
        [[SocketManager shareInstance]connect];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.view makeToast:[resultDic objectForKey:@"msg"] duration:1 position:@"center"];
    }
    
}
- (IBAction)forgetPasswordAction:(UIButton *)sender {
    PhoneCodeVC *phoneCodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"phoneCodeVC"];
    phoneCodeVC.type = 1;
    [self.navigationController pushViewControllerHideBar:phoneCodeVC animated:YES];
//    [self.navigationController pushViewController:phoneCodeVC animated:YES];
}
//-(void)finishReqestOk:(NSDictionary *)resultDic
//{
//   
//    NSString *requestCode = [resultDic objectForKey:@"requestCode"];
//    if([requestCode isEqualToString:kREQEUST_LOGIN]) {
//        if([[resultDic objectForKey:@"rescode"]intValue]==1) {
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self.view makeToast:[resultDic objectForKey:@"resdes"] duration:1 position:@"center"];
//        } else{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [[NSUserDefaults standardUserDefaults] setObject:[resultDic objectForKey:@"userId"] forKey:USER_ID];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            
//            [APService setAlias:self.userNameTextField.text callbackSelector:nil object:self];
//            [self dismissViewControllerAnimated:YES completion:nil];
//           
//        }
//    }
//}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
  
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
@end
