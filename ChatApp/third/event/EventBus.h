//
//  EventBus.h
//  IOSBehind
//
//  Created by gsw on 7/23/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "NSObject+CMSignals.h"

@interface EventBus : NSObject


+(id) shared;

//will register the command to execute when the event get fired
-(void) registerBlock:(void (^)(NSObject *))block  withName:(NSString *)name;

-(void) excuteBlock:(NSString *) name;

-(void) excuteBlock:(NSString *)name withData:(NSObject *)data;

@end
