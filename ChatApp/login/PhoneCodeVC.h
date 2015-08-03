//
//  PhoneCodeVC.h
//  OrderApp
//
//  Created by apple on 14-9-14.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import "XJBaseViewController.h"

@interface PhoneCodeVC : XJBaseViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) IBOutlet UIButton *getCodeButton;
@property (assign)int type;
- (IBAction)getCodeAction:(UIButton *)sender;
- (IBAction)nextAction:(UIButton *)sender;

@end
