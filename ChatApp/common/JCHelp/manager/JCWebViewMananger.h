//
//  SLWebViewMananger.h
//  Shanliao
//
//  Created by gsw on 9/13/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCWebViewMananger : NSObject

+ (id)shared;

- (NSString *)requestUrl:(NSString *)url;

@end
