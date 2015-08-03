//
//  Globle.h
//  ChatApp
//
//  Created by joychuang on 15/3/9.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLGloble : NSObject

@property (nonatomic, assign) float globleWidth; //screen with
@property (nonatomic, assign) float globleHeight; //screen height include status bar hegith
@property (nonatomic, assign) float nearbyBarHeight;
@property (nonatomic, assign) float nearbyBarItemWidth;
@property (nonatomic, assign) float nearbyBarItemGap;
@property (nonatomic, assign) float statusBarHeight;
@property (nonatomic, assign) float navigatorBarHeight;
@property (nonatomic, assign) float tabbarHeight;
@property (nonatomic, assign) float datePickerHeight;

+ (SLGloble *)shareInstance;
- (float)getHeightExeceptStatusAndNav;
- (float)getStatusAndNavHeight;

@end
