//
//  HZUIViewForGuide.m
//  Constraint
//
//  Created by huazi on 14-5-28.
//  Copyright (c) 2014年 AutoLayoutTestDemo. All rights reserved.
//

#import "JCGuideView.h"
#define DeviceRect1   [UIScreen mainScreen].bounds
#define DeviceHeight1 [UIScreen mainScreen].bounds.size.height
#define DeviceWidth1 [UIScreen mainScreen].bounds.size.width
#define FirstUsedApp [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
@interface JCGuideView ()<UIScrollViewDelegate>
{
    NSArray *arrayPic;
    int countsPic;
}
@end

@implementation JCGuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)initSubviews:(UIWindow *)window picArr:(NSArray*)imageArr pageIcon:(UIImage*)icon pageSelectedIcon:(UIImage*)selectedIcon;
{
    arrayPic = imageArr;
    self.scrollView =[[UIScrollView alloc] initWithFrame:window.frame];
    [self addSubview:self.scrollView];
    if (arrayPic.count>0)
    {
        countsPic =[arrayPic count];
        self.scrollView.contentSize =CGSizeMake(DeviceWidth1*countsPic, DeviceHeight1);
        self.scrollView.pagingEnabled =YES;
        self.scrollView.bounces =NO;
        self.scrollView.delegate = self;
        self.scrollView.showsVerticalScrollIndicator =NO;
        self.scrollView.showsHorizontalScrollIndicator =NO;
        for (int i=0; i<countsPic; i++)
        {
            UIImageView *image =[[UIImageView alloc] initWithFrame:CGRectMake(0+i*DeviceWidth1, 0, DeviceWidth1, DeviceHeight1)];
            image.image =[UIImage imageNamed:[arrayPic objectAtIndex:i]];
            [self.scrollView addSubview:image];
            if (i==countsPic-1)
            {
                UIButton*intoButton = [[UIButton alloc]initWithFrame:CGRectMake(160-100/2, DeviceHeight1-90, 100, 35)];
                [intoButton setTitle:@"立即体验" forState:UIControlStateNormal];
                intoButton.backgroundColor = RGBA(105, 212, 0, 1.0);
                intoButton.layer.cornerRadius = 5.0;
                [intoButton addTarget:self action:@selector(TapToHideSelf:) forControlEvents:UIControlEventTouchUpInside];
                intoButton.userInteractionEnabled = YES;
                image.userInteractionEnabled = YES;
                [image addSubview:intoButton];
            }
            
        }
    }
    
    window.hidden = NO;
    [window addSubview:self];
    self.pageControl = [[JCMyPageControl alloc]initWithFrame:CGRectMake(0, DeviceHeight1-50, 320, 48)];
    self.pageControl.activeImage = selectedIcon;
    self.pageControl.inactiveImage = icon;
    [_pageControl setNumberOfPages:4];
    [_pageControl setCurrentPage:0];
    [self addSubview:_pageControl];
   
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    int index = scrollView1.contentOffset.x/320;
    [_pageControl setCurrentPage:index];
}
- (void)TapToHideSelf:(id)sender
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.alpha =0.0f;
                     }
                     completion:^(BOOL finish)
     {
         [self removeFromSuperview];
         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FirstUsedApp];
         
     }];
}

@end
