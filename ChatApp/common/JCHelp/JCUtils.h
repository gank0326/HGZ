//
//  SLUtils.h
//  Shanliao
//
//  Created by gsw on 8/9/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCUtils : NSObject

+ (NSString *)uuid;

+ (NSString *)encodeURL:(NSString *)unencodeString;

+ (NSString *)urlDecode:(NSString *)encodedString;

+ (NSString *)getOpenUDID;

/**
 *  合并集合
 *
 *  @param source   要加入的数据
 *  @param dest     目标集合
 *  @param selector 比较器，这个返回只能是数字
 *
 *  @return 合并后的集合
 */
//+ (id<JavaUtilList>)appendAndMerge:(id<JavaUtilList>)source to:(id<JavaUtilList>)dest withIdentiferSelector:(SEL)selector;

/**
 *  合并集合
 *
 *  @param source   要加入的数据
 *  @param dest     目标集合
 *  @param selector 比较器
 *
 *  @return 合并后的集合
 */
//+ (id<JavaUtilList>)appendAndMerge:(id<JavaUtilList>)source to:(id<JavaUtilList>)dest withUsingComparator:(NSComparator)cmptr;

@end
