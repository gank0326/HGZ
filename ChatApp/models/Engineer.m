//
//  Engineer.m
//  MXR
//
//  Created by joychuang on 15/4/10.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "Engineer.h"

@implementation Engineer

+ (instancetype)modelWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.uuid = [dict objectForKey:@"uuid"];
            self.icon =  [dict objectForKey:@"icon"];
            self.nickname = [dict objectForKey:@"nickname"];
            self.sexTag =  [[dict objectForKey:@"sexTag"] integerValue];
            self.reputably =  [dict objectForKey:@"reputably"];
            self.descInfo =  [dict objectForKey:@"descInfo"];
            self.distance =  [dict objectForKey:@"distance"];
            self.orderNum =  [[dict objectForKey:@"orderNum"] integerValue];
    }
    return self;
}

@end
