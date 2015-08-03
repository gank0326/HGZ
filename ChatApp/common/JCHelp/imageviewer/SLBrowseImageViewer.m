//
//  SLBrowseImageViewer.m
//  Shanliao
//
//  Created by gsw on 14/12/2.
//  Copyright (c) 2014年 6rooms. All rights reserved.
//

#import "SLBrowseImageViewer.h"
#import "SLBrowseImageViewerCell.h"

@interface SLBrowseImageViewer () <UIGestureRecognizerDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray *_gestures;

	UITableView *_tableView;
	UIView *_blackMask;
	UIImageView *_imageView;
	UIButton *_saveBtn;
    UIButton *_selectBtn;

	UIView *_superView;
	CGPoint _panOrigin;
	CGRect _originalFrameRelativeToScreen;
	UILabel *currentIndexLbl;
	UIImageView *countBgImageView;
	BOOL _isAnimating;
	BOOL _isDoneAnimating;

	UIStatusBarStyle _statusBarStyle;
}

@end

@implementation SLBrowseImageViewer
@synthesize rootViewController = _rootViewController;
@synthesize imageURL = _imageURL;
@synthesize openingBlock = _openingBlock;
@synthesize closingBlock = _closingBlock;
@synthesize senderView = _senderView;
@synthesize initialIndex = _initialIndex;
@synthesize initialUrl = _initialUrl;

#pragma mark - TableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Just to retain the old version
	if (!self.imageDatasource) return 1;
	return [self.imageDatasource numberImagesForImageViewer:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
	NSString *cellID = @"browseImageViewerCell";
	SLBrowseImageViewerCell *imageViewerCell = nil;
	if (imageViewerCell.isDownloadingOrinalImage || self.style == BrowseImageViewerSelect) {
		cellID = [cellID stringByAppendingFormat:@"_%d", (int)indexPath.row];
	}
	imageViewerCell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!imageViewerCell) {
		CGRect windowFrame = [[UIScreen mainScreen] bounds];
		imageViewerCell = [[SLBrowseImageViewerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
		imageViewerCell.transform = CGAffineTransformMakeRotation(M_PI_2);
		imageViewerCell.frame = CGRectMake(0, 0, windowFrame.size.width, windowFrame.size.height);
		imageViewerCell.originalFrameRelativeToScreen = _originalFrameRelativeToScreen;
		imageViewerCell.viewController = self;
		imageViewerCell.blackMask = _blackMask;
		imageViewerCell.rootViewController = _rootViewController;
		imageViewerCell.closingBlock = _closingBlock;
		imageViewerCell.openingBlock = _openingBlock;
		imageViewerCell.superView = _senderView.superview;
		imageViewerCell.senderView = _senderView;
		imageViewerCell.initialIndex = _initialIndex;
		imageViewerCell.statusBarStyle = _statusBarStyle;
		imageViewerCell.imageDatasource = self.imageDatasource;
        imageViewerCell.imageSelected = YES;
		[imageViewerCell loadAllRequiredViews];
		imageViewerCell.backgroundColor = [UIColor clearColor];
	}
	if (!self.imageDatasource) {
		// Just to retain the old version
		[imageViewerCell setImageURL:_imageURL defaultImage:_senderView.image imageIndex:0];
	}
	else {
		[imageViewerCell setImageURL:[self.imageDatasource imageURLAtIndex:indexPath.row imageViewer:self] defaultImage:[self.imageDatasource imageDefaultAtIndex:indexPath.row imageViewer:self] imageIndex:indexPath.row];
	}
    _selectBtn.selected = imageViewerCell.imageSelected;
	return imageViewerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return _rootViewController.view.bounds.size.width;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)loadView {
	[super loadView];
	_statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
	CGRect windowBounds = [[UIScreen mainScreen] bounds];

	// Compute Original Frame Relative To Screen
	CGRect newFrame = [_senderView convertRect:windowBounds toView:nil];
	newFrame.origin = CGPointMake(newFrame.origin.x, newFrame.origin.y);
	newFrame.size = _senderView.frame.size;
	_originalFrameRelativeToScreen = newFrame;

	self.view = [[UIView alloc] initWithFrame:windowBounds];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	if (self.initialUrl) {
		_initialIndex = [self.imageDatasource initialIndexForImageViewer:self.initialUrl];
	}
	// Add a Tableview
	_tableView = [[UITableView alloc]initWithFrame:windowBounds style:UITableViewStylePlain];
	[self.view addSubview:_tableView];
	//rotate it -90 degrees
	_tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
	_tableView.frame = CGRectMake(0, 0, windowBounds.size.width, windowBounds.size.height);
	_tableView.pagingEnabled = YES;
	_tableView.dataSource = self;
	_tableView.delegate = self;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_tableView.backgroundColor = [UIColor clearColor];
	[_tableView setShowsVerticalScrollIndicator:NO];
	[_tableView setContentOffset:CGPointMake(0, _initialIndex * windowBounds.size.width)];

	_blackMask = [[UIView alloc] initWithFrame:windowBounds];
	_blackMask.backgroundColor = [UIColor blackColor];
	_blackMask.alpha = 0.0f;
	_blackMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self.view insertSubview:_blackMask atIndex:0];

	[self addBar];
}

- (void)addSaveBtn {
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveBtn setBackgroundImage:[UIImage imageNamed:@"fullscreen_image_save.png"] forState:UIControlStateNormal];
    [_saveBtn setBackgroundImage:[UIImage imageNamed:@"fullscreen_image_save.png"] forState:UIControlStateHighlighted];
    _saveBtn.frame = CGRectMake(10, ScreenHeight - 40.0f, 30.0f, 30.0f);
    [_saveBtn addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    _saveBtn.hidden = YES;
    [self.view addSubview:_saveBtn];
}

- (void)addSelectBtn {
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.selected = YES;
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"AssetsPickerUnChecked.png"] forState:UIControlStateNormal];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"AssetsPickerChecked.png"] forState:UIControlStateSelected];
    _selectBtn.frame = CGRectMake(10, ScreenHeight - 40.0f, 30.0f, 30.0f);
    [_selectBtn addTarget:self action:@selector(deSelectImage:) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.hidden = YES;
    [self.view addSubview:_selectBtn];
}


- (void)addBar {
	currentIndexLbl = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 60, ScreenHeight - 40.0f, 50, 30)];
	currentIndexLbl.textAlignment = NSTextAlignmentCenter;
	currentIndexLbl.backgroundColor = [UIColor clearColor];
	currentIndexLbl.font = [UIFont boldSystemFontOfSize:16];
	currentIndexLbl.textColor = [UIColor whiteColor];
	currentIndexLbl.text = @"1/1";
	currentIndexLbl.hidden = YES;
	countBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fullscreen_image_count_bg.png"]];
	countBgImageView.frame = currentIndexLbl.frame;
	[self.view addSubview:countBgImageView];
	[self refreshTitle];

    switch (self.style) {
        case BrowseImageViewerSave:
            [self addSaveBtn];
            break;
        case BrowseImageViewerSelect:
            [self addSelectBtn];
            break;
        case BrowseImageViewerNone:
            break;
        default:
            [self addSaveBtn];
            break;
    }
	[self.view addSubview:currentIndexLbl];
	[UIView animateWithDuration:0.25 animations: ^{
	    currentIndexLbl.hidden = NO;
	    _saveBtn.hidden = NO;
        _selectBtn.hidden = NO;
	}];
}

- (void)hideBar {
	[UIView animateWithDuration:0.25 animations: ^{
	    currentIndexLbl.hidden = YES;
	    _saveBtn.hidden = YES;
        _selectBtn.hidden = YES;
	    countBgImageView.hidden = YES;
	}];
}

#pragma mark - bar Button
- (void)saveImage:(UIButton *)sender {
	CGPoint point = [_tableView contentOffset];
	int currentPage = point.y / CGRectGetWidth(self.view.frame);
	//indexPathForItem replace by indexPathForRow for crash in ios 5;
	SLBrowseImageViewerCell *cell = (SLBrowseImageViewerCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0]];
	[cell saveImageFromRemote];
}

- (void)deSelectImage:(UIButton *)sender {
    sender.selected = !sender.selected;

    // 反选删除选中的图片
    CGPoint point = [_tableView contentOffset];
    int currentPage = point.y / CGRectGetWidth(self.view.frame);
    //indexPathForItem replace by indexPathForRow for crash in ios 5;
    SLBrowseImageViewerCell *cell = (SLBrowseImageViewerCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0]];

    cell.imageSelected = sender.selected;

    // 反选删除选中的图片
    [cell deSelectImageFromRemote];
}

- (void)dismissBtnClick:(UIButton *)sender {
	CGPoint point = [_tableView contentOffset];
	int currentPage = point.y / CGRectGetWidth(self.view.frame);
	//indexPathForItem replace by indexPathForRow for crash in ios 5;
	SLBrowseImageViewerCell *cell = (SLBrowseImageViewerCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0]];
	[cell dismissMyself];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self refreshTitle];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
	[self refreshTitle];
}

- (void)refreshTitle {
	CGPoint point = [_tableView contentOffset];
	int currentPage = point.y / CGRectGetWidth(self.view.frame);
    //indexPathForItem replace by indexPathForRow for crash in ios 5;
    if (self.style == BrowseImageViewerSelect) {
        SLBrowseImageViewerCell *cell = (SLBrowseImageViewerCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0]];
        _selectBtn.selected = cell.imageSelected;
    }
	NSUInteger totalPages;
	//if(!self.imageDatasource) totalPages = 1;
	totalPages = [self.imageDatasource numberImagesForImageViewer:self];
	if (totalPages == 0) {
		currentIndexLbl.hidden = YES;
	}
	else {
		NSString *val = [NSString stringWithFormat:@"%d/%d", currentPage + 1, (int)totalPages];
		currentIndexLbl.text = val;
	}
	[currentIndexLbl sizeToFit];
	CGSize size = currentIndexLbl.frame.size;
	if (size.width < 30) {
		size.width = 30;
	}
	currentIndexLbl.frame = CGRectMake(ScreenWidth - 10 - size.width, ScreenHeight - 40.0f, size.width, 30);
	countBgImageView.frame = currentIndexLbl.frame;
}

#pragma mark - Show
- (void)presentFromRootViewController {
	if ([self.imageDatasource numberImagesForImageViewer:self] == 0 && !self.imageURL) {
		return;
	}
	UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        rootViewController = ((UINavigationController *)rootViewController).topViewController;
    }
	[self presentFromViewController:rootViewController];
}

- (void)presentFromViewController:(UIViewController *)controller {
	_rootViewController = controller;
	[[[[UIApplication sharedApplication]windows] objectAtIndex:0] addSubview:self.view];
	[controller addChildViewController:self];
	[self didMoveToParentViewController:controller];
	[self performSelector:@selector(hideStatusBar) withObject:nil afterDelay:0.24];
}

- (void)hideStatusBar {
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)dealloc {
	_rootViewController = nil;
	_imageURL = nil;
	_senderView = nil;
	_imageDatasource = nil;
}

@end
