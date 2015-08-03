//
//  SLImageDownloaderManager.h
//  Shanliao
//
//  Created by gsw on 4/30/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLImageDownloaderManager : NSObject

+ (id)shared;

- (void)downloadImage:(NSString *)url;

@end
