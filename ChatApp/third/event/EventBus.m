//
//  EventBus.m
//  IOSBehind
//
//  Created by gsw on 7/23/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "EventBus.h"

@interface SLBlock : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) void (^blockHandler)(NSObject *);

@end

@implementation SLBlock

@synthesize name;
@synthesize blockHandler;

@end

@interface EventBus()
@property (strong, nonatomic) NSMutableArray *blocks;
@end

@implementation EventBus
@synthesize blocks;
static id _EventBus;
+(id) shared
{
    if (nil == _EventBus) {
        _EventBus = [[EventBus alloc] init];
    }
    return _EventBus;
}

-(id) init
{
    self = [super init];
    blocks = [[NSMutableArray alloc] init];
    return self;
}

-(void) registerBlock:(void (^)(NSObject *))block  withName:(NSString *)name
{
    SLBlock *blockObj = [[SLBlock alloc] init];
    blockObj.name = name;
    blockObj.blockHandler = block;
    [blocks addObject:blockObj];
}

-(void) excuteBlock:(NSString *) name
{
    [self excuteBlock:name withData:nil];
}

-(void) excuteBlock:(NSString *)name withData:(NSObject *)data
{
    void (^blockHandler)(NSObject *);
    for (int i = 0; i < [blocks count]; i++) {
        SLBlock *item = [blocks objectAtIndex:i];
        if ([item.name isEqualToString:name]) {
            blockHandler = item.blockHandler;
            if (nil == blockHandler) {
                return;
            }
            blockHandler(data);
        }
    }
}



@end
