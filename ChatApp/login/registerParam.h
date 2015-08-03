//
//  carperson.h
//  car4S
//
//  Created by huazi on 14-2-19.
//  Copyright (c) 2014年 huifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface registerParam : NSObject


@property (copy, nonatomic)NSString *workTag;
@property (copy, nonatomic)NSString *identityTag;
@property (strong,nonatomic)UIImage *photoImage;
@property (copy, nonatomic)NSString *nickName;
@property (assign)int sexTag;
@property(copy,nonatomic)NSString *customTag;
+ (registerParam *) shareRegisterParam;

@end
