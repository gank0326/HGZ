//
//  SLBrowseImageViewerCell.m
//  Shanliao
//
//  Created by gsw on 14/12/2.
//  Copyright (c) 2014年 6rooms. All rights reserved.
//

#import "SLBrowseImageViewerCell.h"
#import "SVProgressHUD.h"
#import "SLImageCacheFetcher.h"
#import "DACircularProgressView.h"
#import "SLBrowseImageViewer.h"
#import "EventBus.h"

static const CGFloat kMinBlackMaskAlpha = 0.3f;
static const CGFloat kMaxImageScale = 2.5f;
static const CGFloat kMinImageScale = 1.0f;
static const int kProgressViewTag = 1001;

@implementation SLBrowseImageViewerCell

- (void)loadAllRequiredViews {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	CGRect frame = [UIScreen mainScreen].bounds;
	__scrollView = [[UIScrollView alloc]initWithFrame:frame];
	__scrollView.delegate = self;
	__scrollView.backgroundColor = [UIColor clearColor];
	[self addSubview:__scrollView];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:APPLICATION_WILL_RESIGN_MSG object:nil];
}

- (void)enterBackground {
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
	__imageView.clipsToBounds = YES;
	CGFloat screenHeight =  [[UIScreen mainScreen] bounds].size.height;
	CGFloat imageYCenterPosition = __imageView.frame.origin.y + __imageView.frame.size.height / 2;
	BOOL isGoingUp =  imageYCenterPosition < screenHeight / 2;
	if (_imageIndex == _initialIndex) {
		__imageView.frame = _originalFrameRelativeToScreen;
	}
	else {
		__imageView.frame = CGRectMake(__imageView.frame.origin.x, isGoingUp ? -screenHeight : screenHeight, __imageView.frame.size.width, __imageView.frame.size.height);
	}

	_blackMask.alpha = 0.0f;

	[_viewController.view removeFromSuperview];
	[_viewController removeFromParentViewController];
	_senderView.alpha = 1.0f;

	[UIApplication sharedApplication].statusBarStyle = _statusBarStyle;

	_isAnimating = NO;
	if (_closingBlock)
		_closingBlock();
}

- (void)saveImageFromRemote {
	UIImage *cachedImage;
	if (checkNotNull(_originalUrl)) {
		cachedImage = [[SLImageCacheFetcher shared] fetcherImage:[NSURL URLWithString:_originalUrl] fromMemory:NO];
		if (!cachedImage) {
			cachedImage = [[SLImageCacheFetcher shared] fetcherImage:[NSURL URLWithString:urlAbsoluteString] fromMemory:NO];
		}
	}
	else {
		cachedImage = [[SLImageCacheFetcher shared] fetcherImage:[NSURL URLWithString:urlAbsoluteString] fromMemory:NO];
	}
	if (cachedImage) {
		UIImageWriteToSavedPhotosAlbum(cachedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	}
}

//反选删除
- (void)deSelectImageFromRemote {
    [[EventBus shared] emit:@selector(deSelectImageForRemove:withSelected:) withArguments:@[urlAbsoluteString, @(self.imageSelected)]];
}

- (void)dismissMyself {
	[self dismissViewController];
}

- (void)  image:(UIImage *)image didFinishSavingWithError:(NSError *)error
    contextInfo:(void *)contextInfo {
	if (error != NULL) {
		[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"保存失败", nil)];
	}
	else {
		[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"保存成功", nil)];
	}
}

- (UIImage *)getImageFromURL:(NSString *)fileURL {
	UIImage *result;
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
	result = [UIImage imageWithData:data];
	return result;
}

- (UIButton *)originBtn {
	if (!_originBtn) {
		_originBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_originBtn.frame = CGRectMake(105, ScreenHeight - 35, 108, 24);
		_originBtn.layer.borderWidth = 1;
		_originBtn.backgroundColor = [UIColor blackColor];
		_originBtn.layer.borderColor = [UIColor whiteColor].CGColor;
		_originBtn.layer.cornerRadius = 4;
		_originBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
		_originBtn.hidden = YES;
		_originBtn.center = CGPointMake(MainWidth / 2, ScreenHeight - 35);
		[_originBtn addTarget:self action:@selector(seeOriginImage) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_originBtn];
	}
	return _originBtn;
}

- (void)seeOriginImage {
	WEAKSELF
	if (!self.originalUrl) {
		return;
	}
	self.isDownloadingOrinalImage = YES;
	__weak __block UIImageView *_imageViewInTheBlock = __imageView;
	[[SLWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_originalUrl] options:(0) progress: ^(NSInteger receivedSize, NSInteger expectedSize) {
	    float percent = (float)receivedSize * 100 / expectedSize;
	    if (percent > 0) {
	        [weakSelf.originBtn setTitle:[NSString stringWithFormat:@"%.0f%%", percent] forState:UIControlStateNormal];
		}
	} completed: ^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
	    weakSelf.isDownloadingOrinalImage = NO;
	    [weakSelf.originBtn setTitle:NSLocalizedString(@"done", nil) forState:UIControlStateNormal];
	    [UIView animateWithDuration:0.3 animations: ^{
	        weakSelf.originBtn.hidden = YES;
		}];
	    //将图缩小大一定尺寸显示。
	    if (_size < 3 * 1024 * 1024 && image) {
	        _imageViewInTheBlock.image = image;
		}
	    if (data) {
	        dispatch_sync(kGlobalQueue, ^{
                [[SDImageCache sharedImageCache] storeImage:nil recalculateFromImage:NO imageData:data forKey:_originalUrl toDisk:YES];
			});
		}
	}];
}

- (void)setOrginalButtonTitle:(NSNumber *)page {
	self.originBtn.hidden = YES;
	if ([self.imageDatasource respondsToSelector:@selector(originalImageUrlAtIndex:)]) {
		self.originalUrl = [self.imageDatasource originalImageUrlAtIndex:[page integerValue]];
	}
	if (!self.originalUrl) {
		return;
	}
	else {
		BOOL isExistInMemory = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:self.originalUrl] != nil;
		if (isExistInMemory) {
			self.originBtn.hidden = YES;
		}
		else {
			BOOL isExistInDisk = [[SDImageCache sharedImageCache] diskImageExistsWithKey:self.originalUrl];
			self.originBtn.hidden = isExistInDisk;
		}
	}
	if (self.originBtn.hidden) {
		return;
	}
	long long size = 0;
	if ([self.imageDatasource respondsToSelector:@selector(originalImageSizeAtIndex:)]) {
		size = [self.imageDatasource originalImageSizeAtIndex:[page integerValue]];
	}

	NSString *sizeString = nil;
	if (size > 1024 * 1024) {
		sizeString = [NSString stringWithFormat:@"(%.1fMB)", size / (1024 * 1024.00)];
	}
	else if (size > 1024) {
		sizeString = [NSString stringWithFormat:@"(%.1fKB)", size / 1024.00];
	}
	else {
		sizeString = [NSString stringWithFormat:@"%lldB", size];
	}
	[self.originBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"see_origin_image", nil), sizeString] forState:UIControlStateNormal];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setImageURL:(NSURL *)imageURL defaultImage:(UIImage *)defaultImage imageIndex:(NSInteger)imageIndex {
	_imageIndex = imageIndex;
	if (!self.isDownloadingOrinalImage && _originBtn) {
		_originBtn.hidden = YES;
	}
	if (!self.isDownloadingOrinalImage) {
		[self performSelector:@selector(setOrginalButtonTitle:) withObject:@(self.imageIndex) afterDelay:0.3];
	}
	if (defaultImage == nil) {
		defaultImage = [UIImage imageNamed:@"bg_photo_200.png"];
	}
	_defaultImage = defaultImage;
	urlAbsoluteString = [imageURL absoluteString];
	dispatch_async(dispatch_get_main_queue(), ^{
	    if (!__imageView) {
	        __imageView = [[UIImageView alloc]init];
	        [__scrollView addSubview:__imageView];
	        __imageView.contentMode = UIViewContentModeScaleAspectFill;
		}
	    __block UIImageView *_imageViewInTheBlock = __imageView;
	    __block SLBrowseImageViewerCell *_justMeInsideTheBlock = self;
	    __block UIScrollView *_scrollViewInsideBlock = __scrollView;
	    __block NSInteger __initIndex = _initialIndex;
	    __imageView.image = defaultImage;
	    int rectLength = 30;
	    DACircularProgressView *progressView = (DACircularProgressView *)[self viewWithTag:kProgressViewTag];
	    UIImage *cachedImage = [[SLImageCacheFetcher shared] fetcherImage:imageURL fromMemory:YES];
	    if (cachedImage) {
	        [_scrollViewInsideBlock setZoomScale:1.0f animated:YES];
	        [_imageViewInTheBlock setImage:cachedImage];
	        _imageViewInTheBlock.frame = [_justMeInsideTheBlock centerFrameFromImage:_imageViewInTheBlock.image];
		}
	    else {
	        int defaultPercent = 0.05;
	        if (!progressView) {
	            progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake((CGRectGetHeight(self.frame) - rectLength) / 2, (CGRectGetWidth(self.frame) - rectLength) / 2, rectLength, rectLength)];
	            progressView.roundedCorners = YES;
	            progressView.trackTintColor = [UIColor grayColor];
	            progressView.hidden = YES;
	            progressView.tag = kProgressViewTag;
	            [self addSubview:progressView];
	            [progressView setProgress:defaultPercent];
			}

	        __imageView.image = defaultImage;
	        _imageViewInTheBlock.frame = [_justMeInsideTheBlock centerFrameFromImage:_imageViewInTheBlock.image];
	        [__imageView setImageWithURL:imageURL placeholderImage:defaultImage options:(SLWebImageRetryFailed) progress: ^(NSInteger receivedSize, NSInteger expectedSize) {
	            float percent = receivedSize * (1.0) / expectedSize;
	            percent = percent < defaultPercent ? defaultPercent : percent;
	            if (percent >= 1) {
	                [progressView removeFromSuperview];
				}
	            else {
	                if (imageIndex != __initIndex) {
	                    progressView.hidden = NO;
					}
	                [progressView setProgress:percent];
				}
			} completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
	            [progressView removeFromSuperview];
	            [[_justMeInsideTheBlock viewWithTag:kProgressViewTag] removeFromSuperview];
	            if (error != nil) {
	                [_imageViewInTheBlock setImage:[UIImage imageNamed:@"bg_photo_load_fail.png"]];
	                _imageViewInTheBlock.frame = [_justMeInsideTheBlock centerFrameFromImage:_imageViewInTheBlock.image];
				}
	            else {
	                [_scrollViewInsideBlock setZoomScale:1.0f animated:YES];
	                [_imageViewInTheBlock setImage:image];
	                [UIView animateWithDuration:.3 animations: ^{
	                    _imageViewInTheBlock.frame = [_justMeInsideTheBlock centerFrameFromImage:_imageViewInTheBlock.image];
					}];
	                [_justMeInsideTheBlock addMultipleGesture];
				}
			}];
		}

	    if (_imageIndex == _initialIndex && !_isLoaded) {
	        __imageView.frame = _originalFrameRelativeToScreen;
	        [UIView animateWithDuration:0.4f delay:0.0f options:0 animations: ^{
	            __imageView.frame = [self centerFrameFromImage:__imageView.image];
	            _blackMask.alpha = 1;
			}   completion: ^(BOOL finished) {
	            if (finished) {
	                if (progressView) {
	                    progressView.hidden = NO;
					}
	                _isAnimating = NO;
	                _isLoaded = YES;
	                if (_openingBlock)
						_openingBlock();
				}
			}];
		}
	    __imageView.userInteractionEnabled = YES;
	    [self addMultipleGesture];
	});
}

#pragma mark - Add Pan Gesture
- (void)addPanGestureToView:(UIView *)view {
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
	                                                                             action:@selector(gestureRecognizerDidPan:)];
	panGesture.cancelsTouchesInView = YES;
	panGesture.delegate = self;
	[view addGestureRecognizer:panGesture];
	[_gestures addObject:panGesture];
	panGesture = nil;
}

# pragma mark - Avoid Unwanted Horizontal Gesture
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
	CGPoint translation = [panGestureRecognizer translationInView:__scrollView];
	return fabs(translation.y) > fabs(translation.x);
}

#pragma mark - Gesture recognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	_panOrigin = __imageView.frame.origin;
	gestureRecognizer.enabled = YES;
	return !_isAnimating;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

#pragma mark - Handle Panning Activity
- (void)gestureRecognizerDidPan:(UIPanGestureRecognizer *)panGesture {
	if (__scrollView.zoomScale != 1.0f || _isAnimating) return;
	if (_imageIndex == _initialIndex) {
		if (_senderView.alpha != 0.0f)
			_senderView.alpha = 0.0f;
	}
	else {
		if (_senderView.alpha != 1.0f)
			_senderView.alpha = 1.0f;
	}
	// Hide the Done Button
	__scrollView.bounces = NO;
	CGSize windowSize = _blackMask.bounds.size;
	CGPoint currentPoint = [panGesture translationInView:__scrollView];
	CGFloat y = currentPoint.y + _panOrigin.y;
	CGRect frame = __imageView.frame;
	frame.origin = CGPointMake(0, y);
	__imageView.frame = frame;

	CGFloat yDiff = abs((y + __imageView.frame.size.height / 2) - windowSize.height / 2);
	_blackMask.alpha = MAX(1 - yDiff / (windowSize.height / 2), kMinBlackMaskAlpha);

	if ((panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) && __scrollView.zoomScale == 1.0f) {
		if (_blackMask.alpha < 0.7) {
			[self dismissViewController];
		}
		else {
			[self rollbackViewController];
		}
	}
}

#pragma mark - Just Rollback
- (void)rollbackViewController {
	_isAnimating = YES;
	[UIView animateWithDuration:0.2f delay:0.0f options:0 animations: ^{
	    __imageView.frame = [self centerFrameFromImage:__imageView.image];
	    _blackMask.alpha = 1;
	}   completion: ^(BOOL finished) {
	    if (finished) {
	        _isAnimating = NO;
		}
	}];
}

#pragma mark - Dismiss
- (void)dismissViewController {
	SLBrowseImageViewer *parentController =  (SLBrowseImageViewer *)_viewController;
	[parentController hideBar];

	[__imageView cancelCurrentImageLoad];
	self.userInteractionEnabled = NO;
	_isAnimating = YES;
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
	dispatch_async(dispatch_get_main_queue(), ^{
	    __imageView.clipsToBounds = YES;
	    CGFloat screenHeight =  [[UIScreen mainScreen] bounds].size.height;
	    CGFloat imageYCenterPosition = __imageView.frame.origin.y + __imageView.frame.size.height / 2;
	    BOOL isGoingUp =  imageYCenterPosition < screenHeight / 2;
	    [UIView animateWithDuration:0.4f delay:0.0f options:0 animations: ^{
	        if (_imageIndex == _initialIndex) {
	            __imageView.frame = _originalFrameRelativeToScreen;
			}
	        else {
	            __imageView.frame = CGRectMake(__imageView.frame.origin.x, isGoingUp ? -screenHeight : screenHeight, __imageView.frame.size.width, __imageView.frame.size.height);
			}
	        _blackMask.alpha = 0.0f;
		} completion: ^(BOOL finished) {
	        if (finished) {
	            if (_viewController) {
	                @try {
	                    [_viewController.view removeFromSuperview];
	                    [_viewController removeFromParentViewController];
					}
	                @catch (NSException *exception)
	                {
					}
	                @finally
	                {
					}
				}
	            if (_senderView) {
	                _senderView.alpha = 1.0f;
				}
	            _isAnimating = NO;
	            if (_closingBlock)
					_closingBlock();
			}
		}];
	});
}

#pragma mark - Compute the new size of image relative to width(window)
- (CGRect)centerFrameFromImage:(UIImage *)image {
	if (!image) return CGRectZero;

	CGRect windowBounds = _rootViewController.view.bounds;
	CGSize newImageSize = [self imageResizeBaseOnWidth:windowBounds
	                       .size.width        oldWidth:image
	                       .size.width       oldHeight:image.size.height];
	// Just fit it on the size of the screen
	newImageSize.height = newImageSize.height;
	return CGRectMake(windowBounds.size.width / 2 - newImageSize.width / 2, windowBounds.size.height / 2 - newImageSize.height / 2, newImageSize.width, newImageSize.height);
}

- (CGSize)imageResizeBaseOnWidth:(CGFloat)newWidth oldWidth:(CGFloat)oldWidth oldHeight:(CGFloat)oldHeight {
	if (newWidth < oldWidth) {
		CGFloat scaleFactor = newWidth / oldWidth;
		CGFloat newHeight = oldHeight * scaleFactor;
		return CGSizeMake(newWidth, newHeight);
	}
	else {
		return CGSizeMake(oldWidth, oldHeight);
	}
}

# pragma mark - UIScrollView Delegate
- (void)centerScrollViewContents {
	CGSize boundsSize = _rootViewController.view.bounds.size;
	CGRect contentsFrame = __imageView.frame;

	if (contentsFrame.size.width < boundsSize.width) {
		contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
	}
	else {
		contentsFrame.origin.x = 0.0f;
	}

	if (contentsFrame.size.height < boundsSize.height) {
		contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
	}
	else {
		contentsFrame.origin.y = 0.0f;
	}
	__imageView.frame = contentsFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return __imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	_isAnimating = YES;
	[self centerScrollViewContents];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
	_isAnimating = NO;
}

- (void)addMultipleGesture {
	UITapGestureRecognizer *twoFingerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTwoFingerTap:)];
	twoFingerTapGesture.numberOfTapsRequired = 1;
	twoFingerTapGesture.numberOfTouchesRequired = 2;
	[__scrollView addGestureRecognizer:twoFingerTapGesture];

	UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
	singleTapRecognizer.numberOfTapsRequired = 1;
	singleTapRecognizer.numberOfTouchesRequired = 1;
	[__scrollView addGestureRecognizer:singleTapRecognizer];

	UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDobleTap:)];
	doubleTapRecognizer.numberOfTapsRequired = 2;
	doubleTapRecognizer.numberOfTouchesRequired = 1;
	[__scrollView addGestureRecognizer:doubleTapRecognizer];

	[singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];

	__scrollView.minimumZoomScale = kMinImageScale;
	__scrollView.maximumZoomScale = kMaxImageScale;
	__scrollView.zoomScale = 1;
	[self centerScrollViewContents];
}

#pragma mark - For Zooming
- (void)didTwoFingerTap:(UITapGestureRecognizer *)recognizer {
	CGFloat newZoomScale = __scrollView.zoomScale / 1.5f;
	newZoomScale = MAX(newZoomScale, __scrollView.minimumZoomScale);
	[__scrollView setZoomScale:newZoomScale animated:YES];
}

#pragma mark - Showing of Done Button if ever Zoom Scale is equal to 1
- (void)didSingleTap:(UITapGestureRecognizer *)recognizer {
	[self dismissMyself];
}

#pragma mark - Zoom in or Zoom out
- (void)didDobleTap:(UITapGestureRecognizer *)recognizer {
	CGPoint pointInView = [recognizer locationInView:__imageView];
	[self zoomInZoomOut:pointInView];
}

- (void)zoomInZoomOut:(CGPoint)point {
	// Check if current Zoom Scale is greater than half of max scale then reduce zoom and vice versa
	CGFloat newZoomScale = __scrollView.zoomScale > (__scrollView.maximumZoomScale / 2) ? __scrollView.minimumZoomScale : __scrollView.maximumZoomScale;

	CGSize scrollViewSize = __scrollView.bounds.size;
	CGFloat w = scrollViewSize.width / newZoomScale;
	CGFloat h = scrollViewSize.height / newZoomScale;
	CGFloat x = point.x - (w / 2.0f);
	CGFloat y = point.y - (h / 2.0f);
	CGRect rectToZoomTo = CGRectMake(x, y, w, h);
	[__scrollView zoomToRect:rectToZoomTo animated:YES];
}

@end
