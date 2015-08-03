//
//  SLButtonBlock.m
//  Shanliao
//
//  Created by gsw on 11/3/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "JCButtonBlock.h"

@implementation JCButtonBlock

@synthesize touchUpInsideBlock = _touchUpInsideBlock;

- (void)setTouchUpInsideBlock:(ButtonTouchUpInsideBlock)touchUpInsideBlock
{
    _touchUpInsideBlock = [touchUpInsideBlock copy];
    if ([[self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] count] > 0)
    {
        [self removeTarget:self action:@selector(performTouchUpInsideBlock) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addTarget:self action:@selector(performTouchUpInsideBlock) forControlEvents:UIControlEventTouchUpInside];
}

- (void)performTouchUpInsideBlock
{
    if (self.touchUpInsideBlock)
    {
        self.touchUpInsideBlock(self);
    }
}

@end
