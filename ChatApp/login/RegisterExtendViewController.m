//
//  RegisterExtendViewController.m
//  ChatApp
//
//  Created by howard on 14-11-29.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import "RegisterExtendViewController.h"
#import "TagPicker3.h"

@interface RegisterExtendViewController ()<UITextFieldDelegate>
{
    int currentSexIndex;
}

@end

@implementation RegisterExtendViewController

- (void)viewDidLoad {
    self.titleForNav = @"资料完善";
    [self setIsSupportTapHideKeyboard:YES];
    [super viewDidLoad];
    currentSexIndex = 1;
    [self.photoButton.layer setMasksToBounds:YES];
    [self.photoButton.layer setCornerRadius:52.0];
    [self.photoButton.layer setBorderWidth:1.0];
    [self.photoButton.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    self.button1.layer.borderWidth = 1;
    self.button1.layer.borderColor = [RGBA(107, 199, 247, 1)CGColor];
    self.button2.layer.borderWidth = 1;
    self.button2.layer.borderColor = [RGBA(251, 147, 186, 1)CGColor];
    [self buttonAction:self.button1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)okAction:(id)sender {
    if([CommonUtils isEmpty:self.nickNameTextField.text]) {
        [self.view makeToast:@"请输入昵称" duration:1 position:@"center"];
        return;
    }
    if(self.nickNameTextField.text.length>10) {
        [self.view makeToast:@"昵称最多10个字符" duration:1 position:@"center"];
        return;
    }
    registerParam *rParam = [registerParam shareRegisterParam];
    rParam.photoImage = [self.photoButton imageForState:UIControlStateNormal];
    rParam.nickName = self.nickNameTextField.text;
    rParam.sexTag = currentSexIndex;
    TagPicker3 *tagPicker3 = [self.storyboard instantiateViewControllerWithIdentifier:@"TagPicker3"];
    [self.navigationController pushViewController:tagPicker3 animated:YES];
}

- (IBAction)showPhotoPickerAction:(UIButton *)sender {
    PhotoPickerView *photoPickerView = [[PhotoPickerView alloc]initWithFrameAndViewController:self.view.frame viewController:self];
    [photoPickerView setTapOkBottomView:^(UIImage*image) {
        [self.photoButton setImage:image forState:UIControlStateNormal];
    }];
    [self.view addSubview:photoPickerView];
}

- (IBAction)buttonAction:(UIButton *)sender {
    currentSexIndex = sender.tag;
    self.button1.layer.borderWidth = 1;
    self.button1.layer.borderColor = [RGBA(107, 199, 247, 1)CGColor];
    self.button1.backgroundColor = [UIColor whiteColor];
    self.button2.backgroundColor = [UIColor whiteColor];
    self.button2.layer.borderWidth = 1;
    self.button2.layer.borderColor = [RGBA(251, 147, 186, 1)CGColor];
    self.button1.selected = NO;
    self.button2.selected=NO;
    if (currentSexIndex==1) {
        [sender setSelected:YES];
        [sender setBackgroundColor:RGBA(107, 199, 247, 1)];
        sender.layer.borderWidth = 0;
    } else {
        [sender setSelected:YES];
        [sender setBackgroundColor:RGBA(107, 199, 247, 1)];
        sender.layer.borderWidth = 0;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
