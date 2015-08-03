//
//  CustomTagView.h
//  ChatApp
//
//  Created by howard on 14-11-30.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTagView : UIView
- (IBAction)closeAction:(UIButton *)sender;
- (IBAction)saveAction:(UIButton *)sender;
@property (nonatomic, copy) void(^TapOkBlock)(NSString *string);
@property (weak, nonatomic) IBOutlet UITextField *myTextField;

@end
