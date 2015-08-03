//
//  SLRichTextLabelDelegate.h
//  SLRichTextLabelDelegate
//
//  Created by amao on 13-8-31.
//  Copyright (c) 2013年 Netease. All rights reserved.
//


typedef NS_ENUM (NSUInteger, SLRichTextImageAlignment)
{
	SLRichTextImageAlignmentTop,
	SLRichTextImageAlignmentCenter,
	SLRichTextImageAlignmentBottom
};

@class SLRichTextLabel;

@protocol SLRichTextLabelDelegate <NSObject>

- (void)richTextAttributedLabel:(SLRichTextLabel *)label
                  clickedOnLink:(id)linkData;

@end

typedef NSArray *(^SLRichTextLabelBlock)(NSString *text);

//如果文本长度小于这个值,直接在UI线程做Link检测,否则都dispatch到共享线程
#define SLRichTextMinAsyncDetectLinkLength 10
