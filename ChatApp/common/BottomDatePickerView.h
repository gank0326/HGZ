//
//  HZUINavAddBottomView.h
//  Constraint
//
//  Created by huazi on 14-5-27.
//  Copyright (c) 2014年 AutoLayoutTestDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BottomDatePickerView : UIView
{
    UIDatePicker *BottomView;
    UIView *upView;
    UIView *viewBJAlpha;
}
- (void)initSubviews;
- (void)addSubviewToSuperView:(UIView *)superView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(assign,nonatomic)int defaultIndex;
@property (nonatomic, copy) void(^TapOkBottomView)(NSDate *date);
@property (nonatomic, copy) void(^TapCancelBottomView)();
@end
