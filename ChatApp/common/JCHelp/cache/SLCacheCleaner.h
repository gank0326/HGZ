//
//  SLDBCacheCleaner.h
//  Shanliao
//
//  Created by gsw on 8/30/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLCacheCleaner : NSObject

+ (void)historyMessageArrived;

+ (void)clearCache;

@end
