//
//  NSObject+CMSignals.h
//  Shanliao
//
//  Created by gsw on 7/22/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//
#import "CMSignals.h"
#import <Foundation/Foundation.h>

@interface NSObject (CMSignals)

- (void)connect:(SEL)signal
           from:(id)sender
           with:(SEL)slot;

- (void)disconnect:(SEL)signal
              from:(id)sender
              with:(SEL)slot;

- (void)emit:(SEL)signal withArguments:(NSArray *)argsArray;


@end
