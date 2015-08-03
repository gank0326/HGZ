//
//  NSObject+CMSignals.m
//  Shanliao
//
//  Created by gsw on 7/22/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//
#import "NSObject+CMSignals.h"

@implementation NSObject (CMSignals)

- (void)connect:(SEL)signal
           from:(id)sender
           with:(SEL)slot {
	[[CMSignals sharedSingleton] connectObject:sender with:signal to:self with:slot];
}

- (void)disconnect:(SEL)signal
              from:(id)sender
              with:(SEL)slot {
	[[CMSignals sharedSingleton] disconnectObject:sender with:signal from:self with:slot];
}

- (void)emit:(SEL)signal withArguments:(NSArray *)argsArray {
	[[CMSignals sharedSingleton] emit:signal object:self withArguments:argsArray];
}

@end
