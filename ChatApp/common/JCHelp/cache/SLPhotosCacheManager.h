//
//  SLPhotosCacheManager.h
//  Shanliao
//
//  Created by gsw on 6/3/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDImageCache.h"

@interface SLPhotosCacheManager : NSObject

+ (id)shared;

- (SDImageCache *)defaultCache;

- (void)cacheImage:(UIImage*) image withURL:(NSURL *)url;

- (UIImage *)fetcherImage:(NSURL *)imageURL;

@end
