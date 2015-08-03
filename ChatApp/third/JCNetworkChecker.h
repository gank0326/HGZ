//
//  SLNetworkChecker.h
//  Shanliao
//
//  Created by gsw on 8/27/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^networkCheckBlock) (void);

@interface JCNetworkChecker : NSObject

+ (void)checkNetwork:(void (^)(BOOL))avaliable;
+ (Boolean)isAvailable;

@end
