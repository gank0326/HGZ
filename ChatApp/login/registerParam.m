//
//  carperson.m
//  car4S
//
//  Created by huazi on 14-2-19.
//  Copyright (c) 2014年 huifu. All rights reserved.
//

#import "registerParam.h"

@implementation registerParam

static  registerParam *shareQuestionParam =nil;

+(registerParam *)shareRegisterParam
{
    @synchronized(self) {
        if (shareQuestionParam == nil)
        {
            
            // assignment not done here
            shareQuestionParam =[[self alloc] init];
            
        }
        
    }
    
    return shareQuestionParam;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (shareQuestionParam == nil) {
            
            shareQuestionParam = [super allocWithZone:zone];
            
            return shareQuestionParam; // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts
}

- (id) init
{
    return self;
}
@end
