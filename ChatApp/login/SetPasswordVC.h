//
//  SetPasswordVC.h
//  OrderApp
//
//  Created by apple on 14-9-14.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import "XJBaseViewController.h"

@interface SetPasswordVC : XJBaseViewController
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField1;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField2;
@property(copy,nonatomic)NSString *phoneNum;
- (IBAction)okAction:(UIButton *)sender;
@property(assign)int type;
@property (strong, nonatomic) IBOutlet UIButton *okButton;

@end
