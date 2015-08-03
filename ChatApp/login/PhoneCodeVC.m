//
//  PhoneCodeVC.m
//  OrderApp
//
//  Created by apple on 14-9-14.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import "PhoneCodeVC.h"
#import "SetPasswordVC.h"

@interface PhoneCodeVC ()
{
    NSTimer *timer;
    int Second;
}

@end

@implementation PhoneCodeVC

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
    self.titleForNav = @"短信验证";
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.getCodeButton.layer setBorderColor:[ThemeDefaultColor CGColor]];
    [self.getCodeButton.layer setBorderWidth:1.0];
    Second = 0;
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [timer invalidate];
    timer = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getCodeAction:(UIButton *)sender {
   
    if([CommonUtils isEmpty:self.phoneTextField.text]) {
        [self.view makeToast:@"请输入手机号" duration:1 position:@"center"];
        return;
    }
    if(![AppUtils isMobileNumber:self.phoneTextField.text]) {
        [self.view makeToast:@"手机号输入错误" duration:1 position:@"center"];
        return;
    }
     [self.phoneTextField resignFirstResponder];
    NSString *token = [UserDefaultsUtils valueWithKey:USERDEFAULT_TOKEN];
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:[AppUtils getOpenId],@"deviceid",token,@"apptoken",self.phoneTextField.text,@"mobile",@"1",@"rflag",nil];
    [self loadData:paramDic requestCode:kREQESUT_GETCODE showAnimation:YES];

}

- (IBAction)nextAction:(UIButton *)sender {

    if([CommonUtils isEmpty:self.phoneTextField.text]) {
        [self.view makeToast:@"请输入手机号" duration:1 position:@"center"];
        return;
    }
    if(![AppUtils isMobileNumber:self.phoneTextField.text]) {
        [self.view makeToast:@"手机号输入错误" duration:1 position:@"center"];
        return;
    }
    if([CommonUtils isEmpty:self.codeTextField.text]) {
        [self.view makeToast:@"请输入验证码" duration:1 position:@"center"];
        return;
    }
    NSString *token = [UserDefaultsUtils valueWithKey:USERDEFAULT_TOKEN];
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:token,@"apptoken",self.phoneTextField.text,@"mobile",self.codeTextField.text,@"verifycode",nil];
    [self loadData:paramDic requestCode:kREQEUST_MESSAGECODE_VALIDATE showAnimation:YES];
}

-(void)finishReqestOk:(NSDictionary *)resultDic
{
    [super finishReqestOk:resultDic];
    NSString *requestCode = [resultDic objectForKey:@"requestCode"];
    if ([requestCode isEqualToString:kREQEUST_MESSAGECODE_VALIDATE])
    {
        if([[resultDic objectForKey:@"status"]intValue]==0) {
            SetPasswordVC *SetPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SetPasswordVC"];
            SetPasswordVC.phoneNum = self.phoneTextField.text;
            SetPasswordVC.type = self.type;
            [self.navigationController pushViewController:SetPasswordVC animated:YES];

        } else {
            [self.view makeToast:@"验证码错误" duration:1 position:@"center"];
        }
    }else {
        if([[resultDic objectForKey:@"status"]intValue]!=0) {
             [self.view makeToast:[resultDic objectForKey:@"msg"] duration:1 position:@"center"];
        } else {
            if (Second <=0){
                self.getCodeButton.enabled=NO;
                Second =60;
                self.getCodeButton.titleLabel.text =[NSString stringWithFormat:@"(%i)秒重发",Second];
                if(timer==nil) {
                    timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeats) userInfo:nil repeats:YES];
                }
            }
        }
    }
}
- (void)repeats
{
    
    if (Second >0)
    {  --Second;
        
        self.getCodeButton.titleLabel.text =[NSString stringWithFormat:@"(%i)秒重发",Second];
        
    }
    else
    {
        
        self.getCodeButton.enabled =YES;
        self.getCodeButton.titleLabel.text =[NSString stringWithFormat:@"发送验证码"];
    }
    
}
@end
