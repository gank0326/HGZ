//
//  UIActionSheet+Block.h
//  DondibuyShopping
//
//  Created by howard on 14/11/11.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishActionSheetBlock)(int);
@interface UIActionSheet (Block)<UIActionSheetDelegate>
-(void)showInViewWithBlock:(UIView*)view block:(FinishActionSheetBlock)finishBlock;

@end
