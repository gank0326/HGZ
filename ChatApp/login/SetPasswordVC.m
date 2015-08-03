//
//  SetPasswordVC.m
//  OrderApp
//
//  Created by apple on 14-9-14.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import "SetPasswordVC.h"
#import "TagPicker1.h"


@interface SetPasswordVC ()

@end

@implementation SetPasswordVC

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
    self.titleForNav = @"设置密码";
    [super viewDidLoad];
//    UIImage * image = [XJApplicationUtil createImageWithColor:[XJApplicationUtil colorWithHex:0x3ca1d2]];
//    [self.okButton setBackgroundImage:[UIImage createRoundedRectImage:image size:self.okButton.frame.size radius:5] forState:UIControlStateHighlighted];
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

- (IBAction)okAction:(UIButton *)sender {
    if([CommonUtils isEmpty:self.passwordTextField1.text]) {
        [self.view makeToast:@"请输入密码" duration:1 position:@"center"];
        return;
    }
    if (self.passwordTextField1.text.length>20||self.passwordTextField1.text.length<6) {
        [self.view makeToast:@"密码长度为6-20" duration:1 position:@"center"];
        return;
    }
    if([CommonUtils isEmpty:self.passwordTextField2.text]) {
        [self.view makeToast:@"请输入确定密码" duration:1 position:@"center"];
        return;
    }
    if(![self.passwordTextField1.text isEqualToString:self.passwordTextField2.text]) {
        [self.view makeToast:@"两次密码不一致" duration:1 position:@"center"];
        return;
    }
    
    if(self.type==0) {
        NSString *token = [UserDefaultsUtils valueWithKey:USERDEFAULT_TOKEN];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.phoneNum,@"username",token,@"apptoken",self.passwordTextField1.text,@"password",nil];
        [self loadData:dic requestCode:kREQESUT_REGISTER showAnimation:YES];
    } else {
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.phoneNum,@"username",self.passwordTextField1.text,@"newpassword",nil];
        [self loadData:dic requestCode:kREQESUT_FORGETPASSWORD showAnimation:YES needToken:YES];
    }

}

-(void)finishReqestOk:(NSDictionary *)resultDic
{
    [super finishReqestOk:resultDic];
    NSString *requestCode = [resultDic objectForKey:@"requestCode"];
    if([requestCode isEqualToString:kREQESUT_REGISTER]) {
        NSDictionary *dic = [resultDic objectForKey:@"data"];
        if([dic isKindOfClass:[NSDictionary class]]) {
            NSString *uid = [dic objectForKey:@"uid"];
            [UserDefaultsUtils saveValue:uid forKey:UID];
            TagPicker1 *tagPicker1 = [self.storyboard instantiateViewControllerWithIdentifier:@"TagPicker1"];
            [self.navigationController pushViewController:tagPicker1 animated:YES];

        } else {
            [self.view makeToast:@"注册失败" duration:1 position:@"center"];

        }
    } else if ([requestCode isEqualToString:kREQESUT_FORGETPASSWORD]) {
        [self.view makeToast:@"设置成功" duration:1 position:@"center"];
        [self performSelector:@selector(finishAction) withObject:nil afterDelay:1];
    }

}

-(void)finishAction
{
    if (self.type==1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
@end
