//
//  UIAlertView+Block.h
//  DondibuyShopping
//
//  Created by howard on 14-10-21.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CompleteAlertViewBlock)(int);
@interface UIAlertView (Block)
-(void)showAlertViewWithBlock:(CompleteAlertViewBlock)comBlock;
@end
