//
//  CMSignals.h
//  Shanliao
//
//  Created by gsw on 7/22/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CM_signals @optional

@interface CMSignals : NSObject

+ (CMSignals *)sharedSingleton;

- (void)connectObject:(id)sender
                 with:(SEL)signal
                   to:(id)receiver
                 with:(SEL)slot;

- (void)disconnectObject:(id)sender
                    with:(SEL)signal
                    from:(id)receiver
                    with:(SEL)slot;

- (void)emit:(SEL)signal object:(id)sender withArguments:(NSArray *)argsArray;

- (void)removeAllObserver;

- (void)removeObserverBindOnSender:(id)sender;

@end
