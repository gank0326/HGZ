//
//  UIView+Roundify.h
//  Shanliao
//
//  Created by gsw on 5/22/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Roundify)

- (void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;
- (CALayer *)maskForRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;

@end
