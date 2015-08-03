//
//  HZUINavAddBottomView.h
//  Constraint
//
//  Created by huazi on 14-5-27.
//  Copyright (c) 2014年 AutoLayoutTestDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CityPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
// 下面的View
@property(strong,nonatomic)UIView *upView;
@property (strong, nonatomic) UIView *viewBJAlpha;
- (void)initSubviews;
- (void)addSubviewToSuperView:(UIView *)superView;
-(void)popBackToHiddenSelf;
@property (nonatomic, copy) void(^TapOkCityPickerView)(NSString *provId,NSString *cityId);
-(id)initWithFrameAndViewController:(CGRect)frame viewController:(UIView*)superView cityData:(NSDictionary*)cityDic;


@end
