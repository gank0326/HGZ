//
//  CustomTagView.m
//  ChatApp
//
//  Created by howard on 14-11-30.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import "CustomTagView.h"

@implementation CustomTagView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)saveAction:(UIButton *)sender {
    if ([CommonUtils isEmpty:self.myTextField.text]) {
        [self makeToast:@"请输入内容" duration:1 position:@"center"];
        return;
    }
    if (self.myTextField.text.length>8) {
        [self makeToast:@"最多8个字符" duration:1 position:@"center"];
        return;
    }
    if(self.TapOkBlock) {
        self.TapOkBlock(self.myTextField.text);
    }
    [self removeFromSuperview];
}
@end
