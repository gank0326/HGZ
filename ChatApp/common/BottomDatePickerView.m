//
//  HZUINavAddBottomView.m
//  Constraint
//
//  Created by huazi on 14-5-27.
//  Copyright (c) 2014年 AutoLayoutTestDemo. All rights reserved.
//

#import "BottomDatePickerView.h"
#define DeviceRect   [UIScreen mainScreen].bounds

@implementation BottomDatePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(void)setDefaultIndex:(int)defaultIndex
{
}
- (void)initSubviews
{
    self.backgroundColor =[UIColor clearColor];
    viewBJAlpha =[[UIView alloc] initWithFrame:self.frame];
    viewBJAlpha.backgroundColor =[UIColor blackColor];
    viewBJAlpha.alpha =0.4;
    [self addSubview:viewBJAlpha];
    UIDatePicker *pickView =[[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 320,216.0)];
    BottomView = pickView;
    if (BottomView)
    {
        [self addSubview:BottomView];
        BottomView.backgroundColor =[UIColor whiteColor];
        upView= [[UIView alloc]initWithFrame:CGRectMake(0, DeviceRect.size.height, 320, 50)];
        upView.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
        
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 50, 25)];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"inputbg.png" ] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(TapToHideSelf:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [upView addSubview:cancelButton];
        
        UIButton *okButton = [[UIButton alloc]initWithFrame:CGRectMake(260, 12, 50, 25)];
        [okButton setBackgroundImage:[UIImage imageNamed:@"inputbg.png" ] forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(BtnToHideSelf:) forControlEvents:UIControlEventTouchUpInside];
        [okButton setTitle:@"完成" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        okButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [upView addSubview:okButton];
        [self addSubview:upView];
    }
}


- (void)addSubviewToSuperView:(UIView *)superView
{
    [superView addSubview:self];
    [self addSingleTapToHiddenSelf];
    [UIView animateWithDuration:0.3 animations:^{
        viewBJAlpha.alpha =0.4;
        BottomView.transform = CGAffineTransformMakeTranslation(0.0,-216.0);
        upView.transform = CGAffineTransformMakeTranslation(0.0, -236.0);
    }];
}

- (void)addSingleTapToHiddenSelf
{
    UITapGestureRecognizer *sinletap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapToHideSelf:)];
    sinletap.numberOfTapsRequired =1;
    [self addGestureRecognizer:sinletap];
}

- (void)BtnToHideSelf:(UIButton *)sender
{
    UIDatePicker *pickerView = (UIDatePicker*)BottomView;
    if(self.TapOkBottomView) {
        NSDate *selectDate = pickerView.date;
        self.TapOkBottomView(selectDate);
        
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         BottomView.transform = CGAffineTransformMakeTranslation(0.0,0.0);
                         upView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
                         viewBJAlpha.alpha =0.0f;
                         [self viewWithTag:100].alpha =0.0f;
                         
                     }
                     completion:^(BOOL finish)
     {
         [self removeFromSuperview];
     }];
    
    
    
}
- (void)TapToHideSelf:(id)sender
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         BottomView.transform = CGAffineTransformMakeTranslation(0.0,0.0);
                         upView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
                         viewBJAlpha.alpha =0.0f;
                         [self viewWithTag:100].alpha =0.0f;
                         
                     }
                     completion:^(BOOL finish)
     {
         [self removeFromSuperview];
         if(self.TapCancelBottomView) {
             self.TapCancelBottomView();
         }
     }];
}
@end
