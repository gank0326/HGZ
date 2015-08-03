//
//  PhotoPickerView.h
//  hehe
//
//  Created by howard on 14/12/5.
//  Copyright (c) 2014年 xj. All rights reserved.
//

//选择照片
#import <UIKit/UIKit.h>

@interface PhotoPickerView : UIView
@property (nonatomic, copy) void(^TapOkBottomView)(UIImage *image);
-(id)initWithFrameAndViewController:(CGRect)frame viewController:(UIViewController*)viewController;
@end
