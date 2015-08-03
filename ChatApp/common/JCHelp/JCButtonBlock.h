//
//  SLButtonBlock.h
//  Shanliao
//
//  Created by gsw on 11/3/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCButtonBlock;

typedef void(^ButtonTouchUpInsideBlock)(JCButtonBlock *button);

@interface JCButtonBlock : UIButton

@property (copy, nonatomic) ButtonTouchUpInsideBlock touchUpInsideBlock;

- (void)setTouchUpInsideBlock:(ButtonTouchUpInsideBlock)touchUpInsideBlock;

- (void)performTouchUpInsideBlock;


@end
