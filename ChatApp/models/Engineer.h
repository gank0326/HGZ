//
//  Engineer.h
//  MXR
//
//  Created by joychuang on 15/4/10.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Engineer : NSObject

@property(copy,nonatomic)NSString *uuid;
@property(copy,nonatomic)NSString *icon;
@property(copy,nonatomic)NSString *nickname;
@property(assign)NSInteger sexTag;
@property(copy,nonatomic)NSString *reputably;
@property(copy,nonatomic)NSString *descInfo;
@property(copy,nonatomic)NSString *distance;
@property(assign)NSInteger orderNum;

+ (instancetype)modelWithDictionary:(NSDictionary*)dic;

@end
