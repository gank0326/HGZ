//
//  JCSkinManager.h
//  Shanliao
//
//  Created by gsw on 4/16/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCSkinUtil.h"

@interface JCSkinManager : NSObject

+ (id)shared;

- (NSDictionary *)getSkin:(NSString *)skinName;

- (void)changeSkin:(NSString *)skinName;

- (NSString *)currentSkin;

@end
