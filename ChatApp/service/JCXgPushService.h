//
//  JCXgPushService.h
//  ChatApp
//
//  Created by joychuang on 15/3/25.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCXgPushService : NSObject

+ (id)shared;

- (void)registerXgPush;

- (void)unRegisterXgPush;

- (void)registerDevice:(NSData*)deviceToken;
@end
