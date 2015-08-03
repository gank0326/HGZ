//
//  RegisterExtendViewController.h
//  ChatApp
//
//  Created by howard on 14-11-29.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import "XJBaseViewController.h"

@interface RegisterExtendViewController : XJBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
- (IBAction)okAction:(id)sender;
- (IBAction)showPhotoPickerAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
- (IBAction)buttonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end
