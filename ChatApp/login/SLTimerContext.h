//
//  SLTimerContext.h
//  Shanliao
//
//  Created by gsw on 14-8-21.
//  Copyright (c) 2014年 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLTimerContext : NSObject
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSUInteger timeElipsed;
@property (nonatomic) NSUInteger timeStartAbs;
@end