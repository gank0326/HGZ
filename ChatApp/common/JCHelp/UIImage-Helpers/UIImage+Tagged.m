//
//  UIImage+Tagged.m
//  Shanliao
//
//  Created by 徐涛 on 12/17/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "UIImage+Tagged.h"
#import <objc/runtime.h>

@implementation UIImage (Tagged)

- (void)setTag:(NSString *)tag {
    objc_setAssociatedObject(self, @selector(tag), tag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)tag {
    return objc_getAssociatedObject(self, @selector(tag));
}

@end
