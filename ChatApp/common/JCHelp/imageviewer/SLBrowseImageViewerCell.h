//
//  SLBrowseImageViewerCell.h
//  Shanliao
//
//  Created by gsw on 14/12/2.
//  Copyright (c) 2014年 6rooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+SLBrowseImageViewer.h"

@interface SLBrowseImageViewerCell : UITableViewCell <UIGestureRecognizerDelegate, UIScrollViewDelegate> {
	UIImageView *__imageView;
	UIScrollView *__scrollView;

	NSMutableArray *_gestures;
	NSString *urlAbsoluteString;
	CGPoint _panOrigin;

	BOOL _isAnimating;
	BOOL _isDoneAnimating;
	BOOL _isLoaded;
}

@property (nonatomic) CGRect originalFrameRelativeToScreen;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UIView *blackMask;
@property (nonatomic, weak) UIImageView *senderView;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, weak) UIImage *defaultImage;
@property (nonatomic, assign) NSInteger initialIndex;
@property (nonatomic, strong) UIButton *originBtn;
@property (nonatomic) BOOL isDownloadingOrinalImage;
@property (nonatomic, weak) id <BrowseImageViewerDatasource> imageDatasource;
@property (nonatomic) BOOL imageSelected;

@property (nonatomic, weak) BrowseImageViewerOpeningBlock openingBlock;
@property (nonatomic, weak) BrowseImageViewerClosingBlock closingBlock;

@property (nonatomic, weak) UIView *superView;

@property (nonatomic) UIStatusBarStyle statusBarStyle;

@property (nonatomic, strong) NSString *originalUrl;

@property (nonatomic, assign) long long size;
- (void)loadAllRequiredViews;
- (void)setImageURL:(NSURL *)imageURL defaultImage:(UIImage *)defaultImage imageIndex:(NSInteger)imageIndex;
- (void)saveImageFromRemote;
- (void)deSelectImageFromRemote;
- (void)dismissMyself;


@end
