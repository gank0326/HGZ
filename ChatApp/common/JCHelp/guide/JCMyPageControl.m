//
//  MyPageControl.m
//  car4S
//
//  Created by howard on 14-4-17.
//  Copyright (c) 2014年 huifu. All rights reserved.
//

#import "JCMyPageControl.h"

@implementation JCMyPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    self.backgroundColor = [UIColor clearColor];
    [self setCurrentPageIndicatorTintColor:[UIColor clearColor]];
    [self setPageIndicatorTintColor:[UIColor clearColor]];
    return self;
}
- (void)setCurrentPage:(NSInteger)currentPage
{
    [self setNeedsDisplay];
    [super setCurrentPage:currentPage];
    
}
- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    [self setNeedsDisplay];
    [super setNumberOfPages:numberOfPages];
    
}

- (void)drawRect:(CGRect)iRect
{
    int i;
    CGRect rect;
    UIImage *image;
    
    iRect = self.bounds;
    
    if (self.opaque) {
        [self.backgroundColor set];
        UIRectFill(iRect);
    }
//    CGFloat _kSpacing = 5.0f;
    
    if (self.hidesForSinglePage && self.numberOfPages == 1) {
        return;
    }
    
    rect.size.height = 9;
    rect.size.width = 9;
    rect.origin.x = floorf((iRect.size.width - rect.size.width*self.numberOfPages) / 2.0);
    rect.origin.y = floorf((iRect.size.height - rect.size.height) / 2.0);
//    rect.size.width = 10;
    
    for (i = 0; i < self.numberOfPages; ++i) {
        image = (i == self.currentPage) ? _activeImage : _inactiveImage;
        [image drawInRect:rect];
        rect.origin.x += 13;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
