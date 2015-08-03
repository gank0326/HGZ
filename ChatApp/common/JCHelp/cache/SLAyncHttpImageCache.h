//
//  SLAyncHttpImageCache.h
//  Shanliao
//
//  Created by gsw on 11/14/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDImageCache.h"

@interface SLAyncHttpImageCache : NSObject

+ (id)shared;

- (SDImageCache *)defaultCache;

//- (void)cacheImage:(UIImage *)image withURL:(NSURL *)url;

- (UIImage *)fetcherImage:(NSURL *)imageURL;

- (void)removeImage:(NSURL *)imageURL;

@end
