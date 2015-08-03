//
//  JCRedPointService.h
//  ChatApp
//
//  Created by joychuang on 15/3/24.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCRedPointService : NSObject

+ (id)shared;

- (void)fetchRed;

@property (nonatomic) BOOL isCycRed;
@property (nonatomic) BOOL isRMRed;
@property (nonatomic) BOOL isGroupRed;
@property (nonatomic) BOOL isActivityRed;
@property (nonatomic) BOOL isNewFriendRed;

@end
