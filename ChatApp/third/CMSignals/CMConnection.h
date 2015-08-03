//
//  CMConnection.h
//  Shanliao
//
//  Created by gsw on 7/22/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMConnection : NSObject <NSCopying>

@property (nonatomic, strong) id sender;
@property (nonatomic, weak) id receiver;

@property (assign) SEL slot;
@property (assign) SEL signal;

@property (assign) id observer;

@end
