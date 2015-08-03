//
//  SLImageFetcher.h
//  Shanliao
//
//  Created by gsw on 11/2/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLImageCacheFetcher : NSObject

+ (id)shared;

/*
    在内存的中160*106获取90*90的图片都是经过剪裁的圆型图片
 */
- (UIImage *)fetcherImage:(NSURL *)imageURL fromMemory:(BOOL)fromMemory;

@end
