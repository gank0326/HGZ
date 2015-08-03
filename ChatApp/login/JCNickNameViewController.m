

//
//  JCNickNameViewController.m
//  ChatApp
//
//  Created by joychuang on 15/3/11.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCNickNameViewController.h"

@interface JCNickNameViewController ()<UITextFieldDelegate> {
    UIView *userView;
}

@property (nonatomic, strong)  UIButton *photoButton;
@property (nonatomic, strong)  UILabel *tipLab;
@property (nonatomic, strong)  UILabel *nickLab;
@property (nonatomic, strong)  UILabel *jobLab;
@property (nonatomic, strong)  UILabel *companyLab;
@property (nonatomic, strong)  UITextField *nickTextField;
@property (nonatomic, strong)  UITextField *jobTextField;
@property (nonatomic, strong)  UITextField *companyTextField;
@property (nonatomic, strong)  UIButton *nextBtn;

@end

@implementation JCNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资料完善";
    self.view.backgroundColor = RGBA(238, 239, 244, 1);
    
    [self.view addSubview:self.photoButton];
    [self.view addSubview:self.tipLab];
    userView = [[UIView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(self.tipLab.frame) + 21, MainWidth - 24, 46*3)];
    userView.backgroundColor = [UIColor whiteColor];
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, CGRectGetWidth(userView.frame), 1)];
    line1.backgroundColor = [@"dfdfdf" toColor];
    [userView addSubview:line1];
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 91, CGRectGetWidth(userView.frame), 1)];
    line2.backgroundColor = [@"dfdfdf" toColor];
    [userView addSubview:line2];
    
    [userView addSubview:self.nickLab];
    [userView addSubview:self.jobLab];
    [userView addSubview:self.companyLab];
    [userView addSubview:self.nickTextField];
    [userView addSubview:self.jobTextField];
    [userView addSubview:self.companyTextField];

    [self.view addSubview:userView];
    [self.view addSubview:self.nextBtn];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)viewTapped:(UITapGestureRecognizer *)tapGr {
    [self.nickTextField resignFirstResponder];
    [self.jobTextField resignFirstResponder];
    [self.companyTextField resignFirstResponder];
}


- (UIButton *)photoButton {
    if (!_photoButton) {
        _photoButton = [[UIButton alloc] initWithFrame:CGRectMake((MainWidth-175/2)/2,  20, 175/2, 175/2)];
        _photoButton.backgroundColor = [UIColor whiteColor];
        _photoButton.layer.cornerRadius = 8.0;
        [_photoButton setImage:[UIImage imageNamed:@"regDefaultAvater.png"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(showPhotoPickerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoButton;
}

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth/2-130/2, CGRectGetMaxY(self.photoButton.frame) + 10, 130, 20)];
        _tipLab.backgroundColor = [UIColor clearColor];
        _tipLab.textColor = [@"b3b3b3" toColor];
        _tipLab.font = [UIFont systemFontOfSize:13.0];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.text = @"点击上传头像";
    }
    return _tipLab;
}

- (UILabel *)nickLab {
    if (!_nickLab) {
        _nickLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 46)];
        _nickLab.backgroundColor = [UIColor clearColor];
        _nickLab.textColor = [@"4c4c4c" toColor];
        _nickLab.font = [UIFont systemFontOfSize:13.0];
        _nickLab.textAlignment = NSTextAlignmentLeft;
        _nickLab.text = @"名 字";
    }
    return _nickLab;
}

- (UILabel *)jobLab {
    if (!_jobLab) {
        _jobLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 46, 50, 46)];
        _jobLab.backgroundColor = [UIColor clearColor];
        _jobLab.textColor = [@"4c4c4c" toColor];
        _jobLab.font = [UIFont systemFontOfSize:13.0];
        _jobLab.textAlignment = NSTextAlignmentLeft;
        _jobLab.text = @"职 位";
    }
    return _jobLab;
}

- (UILabel *)companyLab {
    if (!_companyLab) {
        _companyLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 92, 50, 46)];
        _companyLab.backgroundColor = [UIColor clearColor];
        _companyLab.textColor = [@"4c4c4c" toColor];
        _companyLab.font = [UIFont systemFontOfSize:13.0];
        _companyLab.textAlignment = NSTextAlignmentLeft;
        _companyLab.text = @"公 司";
    }
    return _companyLab;
}

- (UITextField *)nickTextField {
    if (!_nickTextField) {
        _nickTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nickLab.frame), 0, 591/2 - CGRectGetMaxX(self.nickLab.frame) , 46)];
        _nickTextField.delegate = self;
        _nickTextField.borderStyle = UITextBorderStyleNone;
        _nickTextField.font = [UIFont systemFontOfSize:15.0];
        _nickTextField.placeholder = NSLocalizedString(@"请输入名字", nil);
        _nickTextField.keyboardType = UIKeyboardTypeDefault;
        _nickTextField.backgroundColor = [UIColor clearColor];
        _nickTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nickTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nickTextField.textColor = [@"4c4c4c" toColor];
    }
    return _nickTextField;
}

- (UITextField *)jobTextField {
    if (!_jobTextField) {
        _jobTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.jobLab.frame), 46, 591/2 - CGRectGetMaxX(self.jobLab.frame), 46)];
        _jobTextField.delegate = self;
        _jobTextField.textAlignment = NSTextAlignmentLeft;
        _jobTextField.font = [UIFont systemFontOfSize:15.0];
        _jobTextField.placeholder = NSLocalizedString(@"请输入您的职位", nil);
        _jobTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _jobTextField.textColor = [@"4c4c4c" toColor];
        _jobTextField.keyboardType = UIKeyboardTypeDefault;
    }
    return _jobTextField;
}

- (UITextField *)companyTextField {
    if (!_companyTextField) {
        _companyTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.companyLab.frame), 92, 591/2 - CGRectGetMaxX(self.companyLab.frame), 46)];
        _companyTextField.delegate = self;
        _companyTextField.textAlignment = NSTextAlignmentLeft;
        _companyTextField.font = [UIFont systemFontOfSize:15.0];
        _companyTextField.placeholder = NSLocalizedString(@"请输入您的公司名称", nil);
        _companyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _companyTextField.textColor = [@"4c4c4c" toColor];
        _companyTextField.keyboardType = UIKeyboardTypeDefault;
    }
    return _companyTextField;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((MainWidth-298/2)/2, CGRectGetMaxY(userView.frame) + 47, 298/2, 77/2)];
        [_nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _nextBtn.backgroundColor = RGBA(105, 212, 0, 1.0);
        _nextBtn.layer.cornerRadius = 4.0;
        [_nextBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (void)okAction {
    if([CommonUtils isEmpty:self.nickTextField.text]) {
        [AppUtils alert:@"请输入名字" withConfirmBtnTitle:@"确定"];
        return;
    }
    if(self.nickTextField.text.length>10) {
        [AppUtils alert:@"名字最多10个字符" withConfirmBtnTitle:@"确定"];
        return;
    }
    if([CommonUtils isEmpty:self.jobTextField.text]) {
        [AppUtils alert:@"请输入您的职位" withConfirmBtnTitle:@"确定"];
        return;
    }
    if([CommonUtils isEmpty:self.companyTextField.text]) {
        [AppUtils alert:@"请输入您的公司名称" withConfirmBtnTitle:@"确定"];
        return;
    }

    //更新资料
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]init];
    [dic2 setObject:[UserDefaultsUtils valueWithKey:UID] forKey:@"uid"];
    [dic2 setObject:self.nickTextField.text.trim forKey:@"nickname"];
    [dic2 setObject:[NSString stringWithFormat:@"%d",1] forKey:@"gender"];
    dic2[@"company"] = self.companyTextField.text.trim;
    dic2[@"position"] = self.jobTextField.text.trim;
    if([self.photoButton imageForState:UIControlStateNormal]) {
        [dic2 setObject: [NSString stringWithFormat:@"data:image/jpg;base64,%@",[CommonUtils toBase64String:UIImageJPEGRepresentation([self.photoButton imageForState:UIControlStateNormal], 0.7)]] forKey:@"icon"];
    } else {
        [dic2 setObject: [NSString stringWithFormat:@"data:image/jpg;base64,%@",[CommonUtils toBase64String:UIImageJPEGRepresentation([UIImage imageNamed:@"defaultPhoto.png"], 0.7)]] forKey:@"icon"];
    }
    
    [JCViewHelper showHudOnFrontWindowWithText:@"正在处理"];
    WEAKSELF
    [[NetWorkManager shareInstance] loadData:dic2 requestCode:kREQESUT_REGISTER_EXTEND success:^(NSDictionary*dic){
        [weakSelf updateUserInfoSuccess:dic];
    } fail:^(id fail) {
        [JCViewHelper hideHudOnFrontWindow];
    }];
}

- (void)updateUserInfoSuccess:(NSDictionary *)dic {
    [JCViewHelper hideHudOnFrontWindow];
    [JCViewHelper showSuccess:@"设置成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self finishAction];
    });
}

-(void)finishAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)showPhotoPickerAction {
    PhotoPickerView *photoPickerView = [[PhotoPickerView alloc]initWithFrameAndViewController:self.view.frame viewController:self];
    [photoPickerView setTapOkBottomView:^(UIImage*image) {
        [self.photoButton setImage:image forState:UIControlStateNormal];
    }];
    [self.view addSubview:photoPickerView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
