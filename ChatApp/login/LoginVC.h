//
//  LoginVC.h
//  OrderApp
//
//  Created by apple on 14-9-14.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import "XJBaseViewController.h"


@interface LoginVC : XJBaseViewController

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginAction:(UIButton *)sender;
- (IBAction)forgetPasswordAction:(UIButton *)sender;
@end
