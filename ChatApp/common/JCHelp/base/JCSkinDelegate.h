//
//  SLSkinDelegate.h
//  Shanliao
//
//  Created by gsw on 4/16/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JCSkinDelegate <NSObject>

@optional
- (void)applySkin:(NSDictionary *)properties;
- (NSString *)skinKey;

@end
