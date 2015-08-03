//
//  HZUINavAddBottomView.m
//  Constraint
//
//  Created by huazi on 14-5-27.
//  Copyright (c) 2014年 AutoLayoutTestDemo. All rights reserved.
//

#import "CityPickerView.h"
@interface CityPickerView()
{
    UIPickerView *myPickerView;
    UIView *currentSuperView;
    NSMutableArray *data1;
    NSMutableArray *data2;
    NSDictionary *mCityDic;
}
@end

@implementation CityPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(id)initWithFrameAndViewController:(CGRect)frame viewController:(UIView*)superView cityData:(NSDictionary*)cityDic
{

    self = [super initWithFrame:frame];
    if (self) {
        currentSuperView = superView;
        mCityDic = cityDic;
        data1 = [[cityDic allKeys] mutableCopy];
        data2 = [[NSMutableArray alloc]init];
        NSString *cityOne = [data1 objectAtIndex:0];
        NSDictionary *dic = [cityDic objectForKey:cityOne];
        for (NSString *key in [dic allKeys]) {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
            [tempDic setObject:key forKey:@"code"];
            [tempDic setObject:[dic objectForKey:key] forKey:@"text"];
            [data2 addObject:tempDic];
        }

        
    }
    return self;
    
    
}
- (void)initSubviews
{
    myPickerView =[[UIPickerView alloc] initWithFrame:CGRectMake(0, currentSuperView.frame.size.height, 320,216.0)];
    myPickerView.delegate =self;
    myPickerView.dataSource =self;
    myPickerView.showsSelectionIndicator =YES;
    
    self.backgroundColor =[UIColor clearColor];
    //self.viewBJAlpha =[[UIView alloc] initWithFrame:self.frame];
    self.viewBJAlpha =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
    self.viewBJAlpha.backgroundColor =[UIColor blackColor];
    self.viewBJAlpha.alpha =0.4;
    [self addSubview:self.viewBJAlpha];
    [self addSubview:myPickerView];
    
    myPickerView.backgroundColor =[UIColor whiteColor];
    self.upView= [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight, 320, 50)];
    _upView.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    UIButton *okButton = [[UIButton alloc]initWithFrame:CGRectMake(250, 12, 57, 25)];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(BtnToHideSelf:) forControlEvents:UIControlEventTouchUpInside];
    [_upView addSubview:okButton];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 12, 57, 25)];
    [cancelButton addTarget:self action:@selector(TapToHideSelf:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:cancelButton.titleLabel.font.familyName size:18];
    [_upView addSubview:cancelButton];
    
    [self addSubview:_upView];
    
    
}


- (void)addSubviewToSuperView:(UIView *)superView
{
    [superView addSubview:self];
    [self addSingleTapToHiddenSelf];
    [UIView animateWithDuration:0.3 animations:^{
        self.viewBJAlpha.alpha =0.4;
      myPickerView.frame =CGRectMake(0,self.frame.size.height-216.0,320,myPickerView.frame.size.height);
        
        
        self.upView.frame =CGRectMake(0,DeviceHeight-300,320,self.upView.frame.size.height);
        
       
 
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
    int a = [myPickerView selectedRowInComponent:0];
    int b = [myPickerView selectedRowInComponent:1];
    if(self.TapOkCityPickerView) {
        
        
        self.TapOkCityPickerView([NSString stringWithFormat:@"%@ %@",[data1 objectAtIndex:a],[[data2 objectAtIndex:b] objectForKey:@"text"]],[[data2 objectAtIndex:b] objectForKey:@"code"]);
    }
    [self TapToHideSelf:sender];
    
    
    
}

//后来添加的隐藏cityPicker
-(void)popBackToHiddenSelf{
    [UIView animateWithDuration:0.3
                     animations:^{
                         myPickerView.frame =CGRectMake(0,self.frame.size.height +myPickerView.frame.size.height,320,myPickerView.frame.size.height);
                         self.upView.frame =CGRectMake(0,self.frame.size.height +self.upView.frame.size.height,320,self.upView.frame.size.height);
                         self.viewBJAlpha.alpha =0.0f;
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
                         myPickerView.frame =CGRectMake(0,self.frame.size.height +myPickerView.frame.size.height,320,myPickerView.frame.size.height);
                         self.upView.frame =CGRectMake(0,self.frame.size.height +self.upView.frame.size.height,320,self.upView.frame.size.height);
                         self.viewBJAlpha.alpha =0.0f;
                         [self viewWithTag:100].alpha =0.0f;
                         
                     }
                     completion:^(BOOL finish)
     {
         [self removeFromSuperview];
     }];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45;
}
//每一列有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0) {
        return data1.count;
    }
    return data2.count;
}
//第一行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0) {
        return [data1 objectAtIndex:row];
    }
    return [[data2 objectAtIndex:row] objectForKey:@"text"];
    
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(component==0) {
        [data2 removeAllObjects];
        NSString *cityInfo = [data1 objectAtIndex:row];
        NSDictionary *dic = [mCityDic objectForKey:cityInfo];
        for (NSString *key in [dic allKeys]) {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
            [tempDic setObject:key forKey:@"code"];
            [tempDic setObject:[dic objectForKey:key] forKey:@"text"];
            [data2 addObject:tempDic];
        }
        [pickerView reloadComponent:1];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  
    [UIView animateWithDuration:0.3
                     animations:^{
                         myPickerView.frame =CGRectMake(0,self.frame.size.height +myPickerView.frame.size.height,320,myPickerView.frame.size.height);
                         self.upView.frame =CGRectMake(0,self.frame.size.height +self.upView.frame.size.height,320,self.upView.frame.size.height);
                         self.viewBJAlpha.alpha =0.0f;
                         [self viewWithTag:100].alpha =0.0f;
                         
                     }
                     completion:^(BOOL finish)
     {
         [self removeFromSuperview];
     }];

}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
