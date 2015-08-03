//
//  SLRichTextLabelAttachment.h
//  SLRichTextLabelAttachment
//
//  Created by amao on 13-8-31.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLRichTextLabelDelegate.h"

void deallocCallback(void *ref);
CGFloat ascentCallback(void *ref);
CGFloat descentCallback(void *ref);
CGFloat widthCallback(void *ref);

@interface SLRichTextLabelAttachment : NSObject
@property (nonatomic, strong)    id content;
@property (nonatomic, assign)    UIEdgeInsets margin;
@property (nonatomic, assign)    SLRichTextImageAlignment alignment;
@property (nonatomic, assign)    CGFloat fontAscent;
@property (nonatomic, assign)    CGFloat fontDescent;
@property (nonatomic, assign)    CGSize maxSize;


+ (SLRichTextLabelAttachment *)attachmentWith:(id)content
                                       margin:(UIEdgeInsets)margin
                                    alignment:(SLRichTextImageAlignment)alignment
                                      maxSize:(CGSize)maxSize;

- (CGSize)boxSize;

@end
