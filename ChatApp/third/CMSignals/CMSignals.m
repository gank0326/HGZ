//
//  CMSignals.m
//  Shanliao
//
//  Created by gsw on 7/22/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "CMSignals.h"
#import "CMConnection.h"

#define CM_SIGNALARGS @"CMSignalsArgs"

@interface CMSignals ()

@property (nonatomic, strong) NSMutableDictionary *connections;

- (NSString *)signalDescription:(SEL)signal withSender:(id)sender;

@end


@implementation CMSignals

static CMSignals *sharedSingleton;

+ (CMSignals *)sharedSingleton {
	static CMSignals *__singletion;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    __singletion = [[self alloc] init];
	});
	return __singletion;
}

- (void)connectObject:(id)sender
                 with:(SEL)signal
                   to:(id)receiver
                 with:(SEL)slot {
	if (sender == nil) {
		return;
	}

	NSString *signalDescription = [self signalDescription:signal withSender:sender];

	__block SEL _slot = slot;
	__weak __block id _receiver = receiver;

	CMConnection *connection = [[CMConnection alloc] init];
	connection.sender = sender;
	connection.signal = signal;
	connection.receiver = receiver;
	connection.slot = slot;

	NSMutableSet *slots = [_connections objectForKey:signalDescription];

	if (!slots) {
		slots = [[NSMutableSet alloc] init];
	}

	NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];

	connection.observer = [[NSNotificationCenter defaultCenter] addObserverForName:signalDescription
	                                                                        object:sender
	                                                                         queue:mainQueue
	                                                                    usingBlock: ^(NSNotification *notification) {
	    if (!_receiver) {
	        return;
		}
	    @try {
	        NSArray *args = [notification.userInfo objectForKey:CM_SIGNALARGS];
	        NSMethodSignature *methodSignature = [_receiver methodSignatureForSelector:_slot];

	        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
	        [invocation setTarget:_receiver];
	        [invocation setSelector:_slot];
	        for (NSUInteger i = 0; i < [args count]; ++i) {
	            id arg = [args objectAtIndex:i];
	            [invocation setArgument:&arg atIndex:i + 2];
			}
	        if (_receiver) {
	            [invocation invoke];
			}
		}
	    @catch (NSException *exception)
	    {
	        //  [SLRemoteLogger loggerExeception:exception];
		}
	}];
	[slots addObject:connection];
	[_connections setObject:slots forKey:signalDescription];
}

- (void)removeAllObserver {
	NSArray *keys = [_connections allKeys];
	for (CMConnection *key in keys) {
		CMConnection *_connection = [[[_connections objectForKey:key] objectsPassingTest: ^(CMConnection *obj, BOOL *stop) {
		    return YES;
		}] anyObject];
		[[NSNotificationCenter defaultCenter] removeObserver:_connection.observer];
	}
	[_connections removeAllObjects];
	_connections = nil;
	sharedSingleton = nil;
}

- (void)removeObserverBindOnSender:(id)sender {
	[[NSNotificationCenter defaultCenter] removeObserver:sender];
	NSArray *keys = [_connections allKeys];
	for (CMConnection *key in keys) {
		CMConnection *_connection = [[[_connections objectForKey:key] objectsPassingTest: ^(CMConnection *obj, BOOL *stop) {
		    if (!obj.receiver || obj.receiver == sender) {
		        return YES;
			}
		    return NO;
		}] anyObject];
		if (_connection) {
			[[NSNotificationCenter defaultCenter] removeObserver:_connection.observer];
			[_connections removeObjectForKey:key];
		}
	}
}

- (void)disconnectObject:(id)sender
                    with:(SEL)signal
                    from:(id)receiver
                    with:(SEL)slot {
	NSString *signalDescription = [self signalDescription:signal withSender:sender];

	__block CMConnection *connection = [[CMConnection alloc] init];
	connection.sender = sender;
	connection.signal = signal;
	connection.receiver = receiver;
	connection.slot = slot;

	CMConnection *_connection = [[[_connections objectForKey:signalDescription] objectsPassingTest: ^(CMConnection *obj, BOOL *stop) {
	    return [connection isEqual:obj];
	}] anyObject];
	if (_connection) {
		[[NSNotificationCenter defaultCenter] removeObserver:_connection.observer];
		[[_connections objectForKey:signalDescription] removeObject:_connection];
	}
}

- (void)emit:(SEL)signal object:(id)sender withArguments:(NSArray *)argsArray {
	NSString *signalDescription = [self signalDescription:signal withSender:sender];

	[[NSNotificationCenter defaultCenter] postNotificationName:signalDescription
	                                                    object:sender
	                                                  userInfo:@{ CM_SIGNALARGS :  argsArray }];
}

- (NSString *)signalDescription:(SEL)signal withSender:(id)sender {
	return [NSString stringWithFormat:@"%@-%@-CMSignal", NSStringFromSelector(signal), NSStringFromClass([sender class])];
}

@end
