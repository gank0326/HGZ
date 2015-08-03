//
//  JCAccountService.h
//  ChatApp
//
//  Created by joychuang on 15/3/16.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCAccountService : NSObject

+ (id)shared;

-(BOOL)isLogin;

- (void)popoverLoginView:(UIViewController *)controller;

- (void)logout:(UIViewController *)controller;

- (void)loadAppToken;
@end
