//
//  JCWeiXinLoginService.h
//  ChatApp
//
//  Created by joychuang on 15/3/12.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface JCWeiXinLoginService : NSObject

+ (id)shared;

- (void)login;

- (void)getWeiXinCodeFinishedWithResp:(BaseResp *)resp;

- (void)sendlinkToWX:(NSMutableDictionary *)dict;
@end
