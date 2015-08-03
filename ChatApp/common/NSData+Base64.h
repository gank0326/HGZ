//
//  NSData+Base64.h
//  MeetingApp
//
//  Created by songzhanglong on 13-6-5.
//  Copyright (c) 2013年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

- (NSString *)base64Encoding;

+ (id)base64Decoding:(NSString *)string;

+ (NSString *)base64StringEncoding:(NSString *)str;

@end
