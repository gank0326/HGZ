//
//  SLRichTextLabelURL.h
//
//  Created by amao on 13-8-31.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLRichTextLabelDelegate.h"


@interface SLRichTextLabelURL : NSObject
@property (nonatomic, strong)    id linkData;
@property (nonatomic, assign)    NSRange range;
@property (nonatomic, strong)    UIColor *color;
@property (nonatomic) CGPoint point;

+ (SLRichTextLabelURL *)urlWithLinkData:(id)linkData
                                  range:(NSRange)range
                                  color:(UIColor *)color;


+ (NSArray *)detectLinks:(NSString *)plainText;

+ (void)setCustomDetectMethod:(SLRichTextLabelBlock)block;

@end


@interface SLRichTextLabelColor : NSObject

@property (nonatomic, assign)    NSRange range;
@property (nonatomic, strong)    UIColor *color;

@end
