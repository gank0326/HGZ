//
//  TagPicker3.h
//  ChatApp
//
//  Created by howard on 14-11-29.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import "XJBaseViewController.h"
#import "CustomTagView.h"

@interface TagPicker3 : XJBaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet CustomTagView *customTagPickerView;
- (IBAction)okAction:(UIButton *)sender;
@property(assign)int type;
@property(strong,nonatomic)NSMutableArray *currentDataArr;

@end
