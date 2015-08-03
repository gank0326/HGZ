//
//  SLBrowseImageViewer.h
//  Shanliao
//
//  Created by gsw on 14/12/2.
//  Copyright (c) 2014年 6rooms. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIImageView+SLBrowseImageViewer.h"

@interface SLBrowseImageViewer : UIViewController

@property (weak, readonly, nonatomic) UIViewController *rootViewController;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImageView *senderView;
@property (nonatomic, weak) BrowseImageViewerOpeningBlock openingBlock;
@property (nonatomic, weak) BrowseImageViewerClosingBlock closingBlock;
@property (nonatomic, weak) id <BrowseImageViewerDatasource> imageDatasource;
@property (nonatomic, assign) NSInteger initialIndex;
@property (nonatomic, strong) NSString *initialUrl;
@property (nonatomic) BrowseImageViewerType style;

- (void)presentFromRootViewController;
- (void)presentFromViewController:(UIViewController *)controller;
- (void)hideBar;
@end
