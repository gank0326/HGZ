//
//  SLRichTextLabelAttachment.m
//  SLRichTextLabelAttachment
//
//  Created by amao on 13-8-31.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import "SLRichTextLabelAttachment.h"

void deallocCallback(void *ref) {
}

CGFloat ascentCallback(void *ref) {
	SLRichTextLabelAttachment *image = (__bridge SLRichTextLabelAttachment *)ref;
	CGFloat ascent = 0;
	CGFloat height = [image boxSize].height;
	switch (image.alignment) {
		case SLRichTextImageAlignmentTop:
			ascent = image.fontAscent;
			break;

		case SLRichTextImageAlignmentCenter:
		{
			CGFloat fontAscent  = image.fontAscent;
			CGFloat fontDescent = image.fontDescent;
			CGFloat baseLine = (fontAscent + fontDescent) / 2 - fontDescent;
			ascent = height / 2 + baseLine;
		}
		break;

		case SLRichTextImageAlignmentBottom:
			ascent = height - image.fontDescent;
			break;

		default:
			break;
	}
	return ascent;
}

CGFloat descentCallback(void *ref) {
	SLRichTextLabelAttachment *image = (__bridge SLRichTextLabelAttachment *)ref;
	CGFloat descent = 0;
	CGFloat height = [image boxSize].height;
	switch (image.alignment) {
		case SLRichTextImageAlignmentTop:
		{
			descent = height - image.fontAscent;
			break;
		}

		case SLRichTextImageAlignmentCenter:
		{
			CGFloat fontAscent  = image.fontAscent;
			CGFloat fontDescent = image.fontDescent;
			CGFloat baseLine = (fontAscent + fontDescent) / 2 - fontDescent;
			descent = height / 2 - baseLine;
		}
		break;

		case SLRichTextImageAlignmentBottom:
		{
			descent = image.fontDescent;
			break;
		}

		default:
			break;
	}

	return descent;
}

CGFloat widthCallback(void *ref) {
	SLRichTextLabelAttachment *image  = (__bridge SLRichTextLabelAttachment *)ref;
	return [image boxSize].width;
}

#pragma mark - SLRichTextLabelAttachment
@interface SLRichTextLabelAttachment ()
- (CGSize)calculateContentSize;
- (CGSize)attachmentSize;
@end

@implementation SLRichTextLabelAttachment




+ (SLRichTextLabelAttachment *)attachmentWith:(id)content
                                       margin:(UIEdgeInsets)margin
                                    alignment:(SLRichTextImageAlignment)alignment
                                      maxSize:(CGSize)maxSize {
	SLRichTextLabelAttachment *attachment    = [[SLRichTextLabelAttachment alloc]init];
	attachment.content                          = content;
	attachment.margin                           = margin;
	attachment.alignment                        = alignment;
	attachment.maxSize                          = maxSize;
	return attachment;
}

- (CGSize)boxSize {
	CGSize contentSize = [self attachmentSize];
	if (_maxSize.width > 0 && _maxSize.height > 0 &&
	    contentSize.width > 0 && contentSize.height > 0) {
		contentSize = [self calculateContentSize];
	}
	return CGSizeMake(contentSize.width + _margin.left + _margin.right,
	                  contentSize.height + _margin.top  + _margin.bottom);
}

#pragma mark - 辅助方法
- (CGSize)calculateContentSize {
	CGSize attachmentSize   = [self attachmentSize];
	CGFloat width           = attachmentSize.width;
	CGFloat height          = attachmentSize.height;
	CGFloat newWidth        = _maxSize.width;
	CGFloat newHeight       = _maxSize.height;
	if (width <= newWidth &&
	    height <= newHeight) {
		return attachmentSize;
	}
	CGSize size;
	if (width / height > newWidth / newHeight) {
		size = CGSizeMake(newWidth, newWidth * height / width);
	}
	else {
		size = CGSizeMake(newHeight * width / height, newHeight);
	}
	return size;
}

- (CGSize)attachmentSize {
	CGSize size = CGSizeZero;
	if ([_content isKindOfClass:[UIImage class]]) {
		size = [((UIImage *)_content)size];
	}
	else if ([_content isKindOfClass:[UIView class]]) {
		size = [((UIView *)_content)bounds].size;
	}
	return size;
}

@end
