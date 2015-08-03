//
//  TagPicker2.h
//  ChatApp
//
//  Created by howard on 14-11-29.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import "XJBaseViewController.h"
#import "CustomTagView.h"

@interface TagPicker2 : XJBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIView *stateView;
- (IBAction)okAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property(assign)int type;
@property(copy,nonatomic)NSString *currentSelectedString;
@end
