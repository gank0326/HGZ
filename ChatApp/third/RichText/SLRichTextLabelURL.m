//
//  SLRichTextLabelURL.m
//
//  Created by amao on 13-8-31.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import "SLRichTextLabelURL.h"

static NSString *urlExpression = @"((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[\\-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9\\.\\-]+|(?:www\\.|[\\-;:&=\\+\\$,\\w]+@)[A-Za-z0-9\\.\\-]+)((:[0-9]+)?)((?:\\/[\\+~%\\/\\.\\w\\-]*)?\\??(?:[\\-\\+=&;%@\\.\\w]*)#?(?:[\\.\\!\\/\\\\\\w]*))?)";

static SLRichTextLabelBlock customDetectBlock = nil;

@implementation SLRichTextLabelURL

+ (SLRichTextLabelURL *)urlWithLinkData:(id)linkData
                                  range:(NSRange)range
                                  color:(UIColor *)color {
	SLRichTextLabelURL *url  = [[SLRichTextLabelURL alloc]init];
	url.linkData                = linkData;
	url.range                   = range;
	url.color                   = color;
	return url;
}

+ (NSArray *)detectLinks:(NSString *)plainText {
	//提供一个自定义的解析接口给
	if (customDetectBlock) {
		return customDetectBlock(plainText);
	}
	else {
		NSMutableArray *links = nil;
		if ([plainText length]) {
			links = [NSMutableArray array];

			NSError *theError = nil;
			NSDataDetector *detect = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber error:&theError];
			NSArray *allLinks = [detect matchesInString:plainText options:0 range:NSMakeRange(0, [plainText length])];
			if ([allLinks count] > 0) {
				for (NSTextCheckingResult *result in allLinks) {
					switch (result.resultType) {
						case NSTextCheckingTypeLink:
						{
							NSRange range = result.range;
							SLRichTextLabelURL *link = [SLRichTextLabelURL urlWithLinkData:result
							                                                         range:range
							                                                         color:nil];
							[links addObject:link];
						}
						break;

						case NSTextCheckingTypePhoneNumber:
						{
							NSRange range = result.range;
							SLRichTextLabelURL *link = [SLRichTextLabelURL urlWithLinkData:result
							                                                         range:range
							                                                         color:nil];
							[links addObject:link];
						}
						break;

						default:
							break;
					}
				}
			}
		}
		return links;
	}
}

+ (void)setCustomDetectMethod:(SLRichTextLabelBlock)block {
	customDetectBlock = [block copy];
}

@end


@implementation SLRichTextLabelColor

@end
