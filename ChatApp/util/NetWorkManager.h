//
//  NewWorkManager.h
//  ChatApp
//
//  Created by howard on 14/12/24.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkManager : NSObject
+ (NetWorkManager *) shareInstance;
-(void)loadData:(NSDictionary *)paramDic requestCode:(NSString*)requestCode success:(void (^)(id responseDic))_success
           fail:(void (^)(id errorString))_fail;
-(void)cancelReqesut;
@end
