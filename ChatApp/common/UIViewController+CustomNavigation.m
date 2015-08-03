//
//  UIViewController+CustomNavigation.m
//  OrderApp
//
//  Created by howard on 14-8-28.
//  Copyright (c) 2014年 howard. All rights reserved.
//

#import "UIViewController+CustomNavigation.h"
#define tagNavgitionItem   1001
#define tagNavgitionItem2   2001
@implementation UIViewController (CustomNavigation)
- (void)setNavigationItemCostomView:(NSArray *)arrayBtnStr
{
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    UIView *navigationItemTitleView =[[UIView alloc] initWithFrame:CGRectMake(0, 0,80*[arrayBtnStr count], 32)];
    navigationItemTitleView.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView =navigationItemTitleView;
    //=[UIColor blackColor];
    
    for (int i=0; i<[arrayBtnStr count]; i++)
    {
        UIButton *btnItem =[[UIButton alloc] initWithFrame:CGRectMake(i*70+10, 0, 80, 30)];
        btnItem.tag =tagNavgitionItem +i;
        btnItem.selected=NO;
        //UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*70+33, 30, 33, 1)];
        //lineImageView.backgroundColor = ThemeDefaultColor;
        //lineImageView.tag = tagNavgitionItem2+i;

        //[navigationItemTitleView addSubview:lineImageView];
//        if(i==0) {
//            lineImageView.hidden =NO;
//        } else {
//            lineImageView.hidden = YES;
//        }
        [navigationItemTitleView addSubview:btnItem];
        [btnItem setTitle:[arrayBtnStr objectAtIndex:i] forState:UIControlStateNormal];
//        UIImage *backimage =[self backGroundImageForNavigationItemAtIndex:i counts:[arrayBtnStr count]];
//        [btnItem setBackgroundImage:backimage forState:UIControlStateNormal];
        [btnItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btnItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btnItem setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        btnItem.titleLabel.font =[UIFont systemFontOfSize:18];
//        UIImage *backimageSelect =[self backGroundImageSelectForNavigationItemAtIndex:i counts:[arrayBtnStr count]];
        [btnItem addTarget:self action:@selector(navigationItemBtnItem:) forControlEvents:UIControlEventTouchUpInside];
//        [btnItem setBackgroundImage:backimageSelect forState:UIControlStateSelected];
        
    }
    
    ((UIButton *)[self.navigationItem.titleView viewWithTag:tagNavgitionItem]).selected =YES;
    
    
}

//- (UIImage *)backGroundImageSelectForNavigationItemAtIndex:(NSInteger)index  counts:(NSInteger)counts
//{
//    UIImage *image=nil;
//    if (index==0)
//    {
//        image =[UIImage imageNamed:@"navigationLS"];
//    }
//    else if(index+1==counts)
//    {
//        image =[UIImage imageNamed:@"navigationRS"];
//    }
//    else
//    {
//        image =[UIImage imageNamed:@"navigationMS"];
//    }
//    return image;
//}
- (void)navigationItemBtnItem:(UIButton *)sender
{
    for (int i=tagNavgitionItem; i<tagNavgitionItem +5; i++)
    {
        ((UIButton *)[self.navigationItem.titleView viewWithTag:i]).selected =NO;
        [self.navigationItem.titleView viewWithTag:i+1000].hidden=YES;
    }
    sender.selected =YES;
    [self.navigationItem.titleView viewWithTag:sender.tag+1000].hidden = NO;
}
- (void)setNavLeftItemWith:(NSString *)str andImage:(UIImage *)image
{
    if ([str isEqualToString:@""])
    {
        UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick:)];
        rightItem.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = rightItem;
    }
    else
    {
        UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick:)];
        rightItem.tintColor = ThemeDefaultColor;
        self.navigationItem.leftBarButtonItem = rightItem;
    }
    
}
-(void)leftItemClick:(id)sender
{
    
}
- (void)setNavRightItemWith:(NSString *)str andImage:(UIImage *)image
{
    if ([str isEqualToString:@""])
    {
        UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:@selector(rightItemClick:)];
        rightItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    else
    {
        UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStyleBordered target:self action:@selector(rightItemClick:)];
        rightItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
}
- (void)rightItemClick:(id)sender
{
    
}
-(void)setNavTitle:(NSString*)title
{
    UILabel *labelTitle =[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, 44)];
    labelTitle.text =title;
    labelTitle.backgroundColor =[UIColor clearColor];
    labelTitle.font =[UIFont systemFontOfSize:20];
    labelTitle.textColor =[UIColor whiteColor];
    labelTitle.textAlignment =NSTextAlignmentCenter;
    
    self.navigationItem.titleView =labelTitle;
}
@end
