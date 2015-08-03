//
//  SLViewHelper.m
//  Shanliao
//
//  Created by gsw on 8/5/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "JCViewHelper.h"
#import "NSString+TM.h"
#import "JCNavigationViewController.h"
#import "JCViewUtil.h"
#import "SLGloble.h"
#import "AppDelegate.h"
#import "JCNavigationBar.h"
#import "UIWindow+SL.h"
#import "JCSkinManager.h"
#import "JCButtonBlock.h"
#import "UIImage+TM.h"
#import "JGProgressHUD.h"
#import "KVNProgress.h"
#import "BBBadgeBarButtonItem.h"
#import "JCGuideView.h"

static const NSString *IRRGULAR = @"irrgular";

typedef void (^ActionBlock)();

@interface UIBlockButton : UIButton {
	ActionBlock _actionBlock;
}

- (void)handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock)action;
@end

@implementation UIBlockButton

- (void)handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock)action {
	_actionBlock = action;
	[self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
	if (_actionBlock) {
		_actionBlock();
	}
}

@end


@implementation JCViewHelper

#pragma mark - UITableViewCell Helper

+ (void)styleUITableViewCell:(UITableViewCell *)cell {
	UIView *selectionColor = [[UIView alloc] init];
	selectionColor.backgroundColor = [JCViewUtil colorWithHexString:GRAY_BG alpha:1.f];
	cell.selectedBackgroundView = selectionColor;
	cell.textLabel.highlightedTextColor = [UIColor blackColor];
}

+ (void)styleGroupTableView:(UITableViewCell *)cell withTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
	UIView *backgroundView = [[UIView alloc] init];
	backgroundView.backgroundColor = [UIColor whiteColor];
	cell.backgroundView = backgroundView;
	if (cell.selectionStyle != UITableViewCellSelectionStyleNone) {
		UIView *selectBackgroundView = [[UIView alloc] init];
		selectBackgroundView.backgroundColor = [JCViewUtil colorWithHexString:BAR_TINT_COLOR alpha:1.f];
		cell.selectedBackgroundView = selectBackgroundView;
	}
	cell.textLabel.backgroundColor = [UIColor clearColor];
	[cell.textLabel setHighlightedTextColor:cell.textLabel.textColor];
	[cell.detailTextLabel setHighlightedTextColor:[UIColor grayColor]];
	cell.detailTextLabel.textColor = [UIColor grayColor];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
}

#pragma mark - Helper Functions

+ (UIColor *)getDefaultTableBackgroundColor {
	return [UIColor colorWithRed:0.96 green:0.94 blue:0.92 alpha:1];
}

+ (NSString *)fixImageUrl:(NSString *)url withType:(SLImageUrlType)type {
    NSString *endFix = nil;
    if (!url) {
        return @"";
    }
    int dotPosition = [url lastIndexOfString:@"."];
    if (dotPosition <= 0) {
        if ([JCViewUtil isTempLocalUrl:url]) {
            return [url stringByAppendingString:[JCViewHelper getImageType:type]];
        }
        return url;
    }
    endFix = [JCViewHelper getImageType:type];
    if (!endFix) {
        return url;
    }
    if (endFix && [url indexOfString:endFix] > 0) {
        return url;
    }
    NSString *prefixString = [url substringWithRange:NSMakeRange(0, dotPosition)];
    NSString *imageTypeString = [url substringWithRange:NSMakeRange(dotPosition, url.length - dotPosition)];
    NSString *result = [NSString stringWithFormat:@"%@%@%@", prefixString, endFix, imageTypeString];
    return result;
}

+ (NSString *)getImageType:(SLImageUrlType)type {
    NSString *endFix = @"";
    switch (type) {
        case SLImageUrlType_group_category:
            endFix = [NSString stringWithFormat:@"_%d_%d", abs(type), abs(type)];
            break;
            
        case SLImageUrlType_orinal:
        {
            endFix = @"-origin";
        }
            break;
            
        case SLImageUrlType_center_90_90:
        case SLImageUrlType_center_160_160:
        {
            endFix = [NSString stringWithFormat:@"_center_%d_%d", abs(type), abs(type)];
        }
            break;
            
        case SLImageUrlType_scale_90_90:
        case SLImageUrlType_scale_160_160:
        {
            endFix = [NSString stringWithFormat:@"_scale_%d_%d", abs(type), abs(type)];
        }
            break;
            
        case SLImageUrlType_iphone6:
        {
            endFix = [NSString stringWithFormat:@"_%d_%d", 1136, 640];
        }
            break;
            
        case SLImageUrlType_iphone6_plus:
        {
            endFix = [NSString stringWithFormat:@"_%d_%d", 2208, 1242];
        }
            break;
            
        default:
            break;
    }
    return endFix;
}

static const int NO_DATA_TIP_TAG = 1314;
//TODO
+ (UIView *)addNoDataTip:(UIView *)view withTextTip:(NSString *)text withImageType:(SLNoDataTipImageType)type withClickCallBack:(void (^)(void))touchCalback {
    return [self addNoDataTip:view withTextTip:text withImageType:type withMargin:UIEdgeInsetsZero withClickCallBack:touchCalback];
}

+ (UIView *)addNoDataTip:(UIView *)view withTextTip:(NSString *)text withImageType:(SLNoDataTipImageType)type withMargin:(UIEdgeInsets)insets withClickCallBack:(void (^)(void))touchCalback {
    [JCViewHelper removeDataTip:view];
    [JCViewHelper removeLoadingMask:view];
    UIView *maskViews = [view viewWithTag:NO_DATA_TIP_TAG];
    if (!maskViews) {
        CGRect rect;
        rect.origin.x = 0 + insets.right;
        rect.origin.y = 0 + insets.top;
        rect.size.width = CGRectGetWidth(view.frame) - insets.left - insets.right;
        rect.size.height = CGRectGetHeight(view.frame) - insets.top - insets.bottom;
        maskViews = [[UIView alloc] initWithFrame:rect];
        maskViews.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
         maskViews.tag = NO_DATA_TIP_TAG;
        [view addSubview:maskViews];
        
        JCButtonBlock *btn = [[JCButtonBlock alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), 200)];
//        btn.center = CGPointMake(rect.size.width/2, rect.size.height/2 - 32);
        btn.backgroundColor = [UIColor clearColor];
        UIImage *image = (type == NO_DATA_DISPIRITED) ? [UIImage imageNamed:@"load_nodata.png"] : [UIImage imageNamed:@"load_nodata_smile.png"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
        [btn setTitle:text forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTouchUpInsideBlock:^(JCButtonBlock *button) {
            if (touchCalback) {
                touchCalback();
            }
        }];
        [JCViewHelper relayoutBtnForVerticalLayout:btn];
        btn.titleEdgeInsets = UIEdgeInsetsMake(-40.0, btn.titleEdgeInsets.left, btn.titleEdgeInsets.bottom + 40, 0.0);
        [maskViews addSubview:btn];
    }
    maskViews.backgroundColor = colorWithGlobalThemeKey(@"controller_background_color");
    return maskViews;
}

+ (void)removeDataTip:(UIView *)view {
	if ([view viewWithTag:NO_DATA_TIP_TAG]) {
		[[view viewWithTag:NO_DATA_TIP_TAG] removeFromSuperview];
	}
}

+ (void)animationImageView:(UIImageView *)imageView {
	NSArray *imagesArray = [NSArray arrayWithObjects:
	                        [UIImage imageNamed:@"loading_mask_1.png"],
	                        [UIImage imageNamed:@"loading_mask_2.png"], nil];
	[JCViewHelper animationImageView:imageView withImageArr:imagesArray animateWithDuration:0.35];
}

+ (void)animationImageView:(UIImageView *)imageView withImageArr:(NSArray *)imageArr animateWithDuration:(NSTimeInterval)dur {
	imageView.animationImages = imageArr;
	imageView.animationDuration = dur;
	imageView.animationRepeatCount = 0;
	[imageView startAnimating];
}

static const int LOADING_VIEW_TAG = 1316;
+ (void)addLoadingMask:(UIView *)view withTip:(NSString *)tip {
	[self removeLoadingMask:view];
	[self removeDataTip:view];
	CGFloat height = [JCViewHelper currentNavigationController].navigationBar.translucent ? -32 : 32;
	CGFloat marginY = CGRectGetHeight(view.frame) > [[SLGloble shareInstance] getHeightExeceptStatusAndNav] ? 64 : height;
	if ([view viewWithTag:LOADING_VIEW_TAG] == nil) {
		UIView *maskViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
		maskViews.backgroundColor = colorWithGlobalThemeKey(@"controller_background_color");
		int indicatorWidth = 230;
		UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - indicatorWidth) / 2, (CGRectGetHeight(view.frame) - indicatorWidth) / 2 - marginY, indicatorWidth, indicatorWidth)];
		[JCViewHelper animationImageView:animationImageView];
		UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(animationImageView.frame) - 50, CGRectGetWidth(view.frame), 30)];
		tipLable.backgroundColor = [UIColor clearColor];
		tipLable.font = [UIFont systemFontOfSize:14];
		tipLable.textAlignment = NSTextAlignmentCenter;
		tipLable.textColor = [UIColor grayColor];
		tipLable.text = tip;
		[maskViews addSubview:tipLable];
		[maskViews addSubview:animationImageView];
		maskViews.tag = LOADING_VIEW_TAG;
		[view addSubview:maskViews];
	}
}

+ (void)removeLoadingMask:(UIView *)view {
	if ([view viewWithTag:LOADING_VIEW_TAG] != nil) {
		[[view viewWithTag:LOADING_VIEW_TAG] removeFromSuperview];
	}
}

+ (NSString *)fixLocation:(double)distance {
	NSString *result = @"";
	if (distance == -2) {
		return NSLocalizedString(@"distance_unknown", nil);
	}
	else if (distance == -1) {
		result = NSLocalizedString(@"user_invisible", nil);
	}
	else if (distance > 100) {
		result = [NSString stringWithFormat:@"%dkm", (int)distance];
	}
	else if (distance <= 100  && distance >= 1) {
		result = [NSString stringWithFormat:@"%0.1fkm", distance];
	}
	else if (distance < 1 && distance > 0.001) {
		result = [NSString stringWithFormat:@"%dm", (int)(distance * 100)];
	}
	else {
		return @"0m";
	}
	return result;
}

+ (NSData *)adjustImageSize:(UIImage *)image {
	int size = 100;
	CGFloat quality = 0.8;
	CGSize orinalSize = [image size];
	int orinalRectSize = orinalSize.width * orinalSize.height;
	if (orinalRectSize < 1000 * 1000) {
		size = 100;
	}
	else {
		size = orinalRectSize / 40000;
	}

	NSData *imageData = UIImageJPEGRepresentation(image, quality);
	if (imageData.length > 1024 * 200) { //大于200k 减小尺寸
		image = [image resizedImageToFitInSize:CGSizeMake(SEND_IMAGE_MAX_WIDTH, SEND_IMAGE_MAX_HEIGHT) scaleIfSmaller:NO];
	}
	if (imageData.length > 500 * 1024) {
		quality = 0.5;
	}
	while (imageData.length > 1024 * size && quality > 0.1) {
		quality -= 0.1;
		imageData = UIImageJPEGRepresentation(image, quality);
	}

	return imageData;
}

+ (NSData *)getUploadAlbumOrPostCreateImageData:(ALAsset *)asset {
    UIImage *fullScreenImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    return UIImageJPEGRepresentation(fullScreenImage, 0.8);
}

+ (CGSize)getDisplaySize:(UIImage *)orinalImage withBoundSize:(CGSize)boundingSize limitLenght:(NSUInteger)length {
	// get the image size (independant of imageOrientation)
	//CGImageRef imgRef = orinalImage.CGImage;
	CGSize srcSize = CGSizeMake(orinalImage.size.width, orinalImage.size.height); // not equivalent to self.size (which depends on the imageOrientation)!

	CGSize dstSize;
	BOOL scale = NO;
	if (!scale && (srcSize.width < boundingSize.width) && (srcSize.height < boundingSize.height)) {
		//NSLog(@"Image is smaller, and we asked not to scale it in this case (scaleIfSmaller:NO)");
		dstSize = srcSize; // no resize (we could directly return 'self' here, but we draw the image anyway to take image orientation into account)
	}
	else {
		CGFloat wRatio = boundingSize.width / srcSize.width;
		CGFloat hRatio = boundingSize.height / srcSize.height;

		if (wRatio < hRatio) {
			//NSLog(@"Width imposed, Height scaled ; ratio = %f",wRatio);
			dstSize = CGSizeMake(boundingSize.width, floorf(srcSize.height * wRatio));
		}
		else {
			//NSLog(@"Height imposed, Width scaled ; ratio = %f",hRatio);
			dstSize = CGSizeMake(floorf(srcSize.width * hRatio), boundingSize.height);
		}
	}
	if (dstSize.height < length) {
		dstSize.height = length;
	}
	if (dstSize.width < length) {
		dstSize.width = length;
	}
	return dstSize;
}

+ (CGSize)getDisplaySizebyOrinalSize:(CGSize)orinalSize withBoundSize:(CGSize)boundingSize limitLenght:(NSUInteger)length {
	// get the image size (independant of imageOrientation)
	//CGImageRef imgRef = orinalImage.CGImage;
	CGSize srcSize = CGSizeMake(orinalSize.width, orinalSize.height); // not equivalent to self.size (which depends on the imageOrientation)!

	CGSize dstSize;
	BOOL scale = NO;
	if (!scale && (srcSize.width < boundingSize.width) && (srcSize.height < boundingSize.height)) {
		//NSLog(@"Image is smaller, and we asked not to scale it in this case (scaleIfSmaller:NO)");
		dstSize = srcSize; // no resize (we could directly return 'self' here, but we draw the image anyway to take image orientation into account)
	}
	else {
		CGFloat wRatio = boundingSize.width / srcSize.width;
		CGFloat hRatio = boundingSize.height / srcSize.height;

		if (wRatio < hRatio) {
			//NSLog(@"Width imposed, Height scaled ; ratio = %f",wRatio);
			dstSize = CGSizeMake(boundingSize.width, floorf(srcSize.height * wRatio));
		}
		else {
			//NSLog(@"Height imposed, Width scaled ; ratio = %f",hRatio);
			dstSize = CGSizeMake(floorf(srcSize.width * hRatio), boundingSize.height);
		}
	}
	if (dstSize.height < length) {
		dstSize.height = length;
	}
	if (dstSize.width < length) {
		dstSize.width = length;
	}
	return dstSize;
}

+ (NSData *)getOriginalImageDataByAsset:(ALAsset *)asset {
	ALAssetRepresentation *rep = [asset defaultRepresentation];
	Byte *buf = malloc([rep size]);
	NSError *err = nil;
	NSUInteger bytes = [rep getBytes:buf fromOffset:0LL length:[rep size] error:&err];
	if (err || bytes == 0) {
		NSLog(@"eror bytes");
		return nil;
	}
	NSData *photoData = [[NSData alloc] initWithBytes:buf length:rep.size];
	return photoData;
}

+ (UIImage *)screenshot {
	// Create a graphics context with the target size
	// On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
	// On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
	CGSize imageSize = [[UIScreen mainScreen] bounds].size;
	if (NULL != UIGraphicsBeginImageContextWithOptions)
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
	else
		UIGraphicsBeginImageContext(imageSize);

	CGContextRef context = UIGraphicsGetCurrentContext();

	// Iterate over every window from back to front
	for (UIWindow *window in[[UIApplication sharedApplication] windows]) {
		if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
			// -renderInContext: renders in the coordinate space of the layer,
			// so we must first apply the layer's geometry to the graphics context
			CGContextSaveGState(context);
			// Center the context around the window's anchor point
			CGContextTranslateCTM(context, [window center].x, [window center].y);
			// Apply the window's transform about the anchor point
			CGContextConcatCTM(context, [window transform]);
			// Offset by the portion of the bounds left of and above the anchor point
			CGContextTranslateCTM(context,
			                      -[window bounds].size.width * [[window layer] anchorPoint].x,
			                      -[window bounds].size.height * [[window layer] anchorPoint].y);

			// Render the layer hierarchy to the current context
			[[window layer] renderInContext:context];

			// Restore the context
			CGContextRestoreGState(context);
		}
	}

	// Retrieve the screenshot image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return image;
}

+ (void)relayoutBtnForVerticalLayout:(UIButton *)button {
	// the space between the image and text
	CGFloat spacing = 6.0;

	// lower the text and push it left so it appears centered
	//  below the image
	CGSize buttonSize = button.frame.size;
	CGSize imageSize = button.imageView.frame.size;
	button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);

	// raise the image and push it right so it appears centered
	//  above the text
	CGSize titleSize = button.titleLabel.frame.size;
	button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), (buttonSize.width - imageSize.width) / 2, 0.0, (buttonSize.width - imageSize.width) / 2);
}

+ (UIImage *)imageWithRoundedCornersSizeUsingImage:(UIImage *)original {
	// Begin a new image that will be the new image with the rounded corners
	// (here with the size of an UIImageView)
	CGSize size = original.size;
	UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);

	// Add a clip before drawing anything, in the shape of an rounded rect
	[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height)
	                            cornerRadius:size.width / 2] addClip];
	// Draw your image
	[original drawInRect:CGRectMake(0, 0, size.width, size.height)];

	// Get the image, here setting the UIImageView image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

	// Lets forget about that we were drawing
	UIGraphicsEndImageContext();

	return image;
}

+ (BOOL)scrollToTableViewFoot:(UIScrollView *)scrollView {
	CGPoint offset = scrollView.contentOffset;
	CGRect bounds = scrollView.bounds;
	CGSize size = scrollView.contentSize;
	UIEdgeInsets inset = scrollView.contentInset;
	float y = offset.y + bounds.size.height - inset.bottom;
	float h = size.height;
	float reload_distance = 10;
	if (y > h + reload_distance) {
		return YES;
	}
	return NO;
}

+ (void)addCellSepLine:(UITableViewCell *)cell height:(CGFloat)cellHeight marginLeft:(CGFloat)left forHead:(BOOL)isHead {
	UIView *sepLine = [cell.contentView viewWithTag:9001];
	if (!sepLine) {
		sepLine = [[UIView alloc] init];
		[cell.contentView addSubview:sepLine];
	}
	CGRect frame = isHead ? CGRectMake(0, 0, MainWidth, 0.5) : CGRectMake(left, cellHeight - 0.5, MainWidth - left, 0.5);
	sepLine.frame = frame;
	sepLine.tag = 9001;
	sepLine.backgroundColor = colorWithGlobalThemeKey(@"table_selprateline_color");
}

+ (BOOL)isBackgroundMode {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	return appDelegate.isBackgroundMode;
}


@end

@implementation JCViewHelper (Navigation)

+ (void)popupToMainTab {
	[[JCViewHelper currentNavigationController] popToRootViewControllerAnimated:YES];
}

static HLTabBarController *mainTab = nil;

+ (HLTabBarController *)getMainView {
	if (!mainTab) {
		mainTab = [[HLTabBarController alloc] init];
	}
	return mainTab;
}

+ (void)navToMainView {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.window.rootViewController = [JCViewHelper getRootViewController];
}

+ (UINavigationController *)getRootViewController {
	return [JCViewHelper getNavViewController:[JCViewHelper getMainView]];
}

+ (BOOL)irrgularStyle {
	return [[JCSkinManager shared] irrgularStyle];
}

+ (UIViewController *)getEntranceView {
//	UIViewController *root = [[SLWelcomeViewController alloc] init];
//	SLNavigationViewController *nav = [SLViewHelper getNavViewController:root];
//	return nav;
    return nil;
}

+ (JCNavigationViewController *)currentNavigationController {
	UITabBarController *tabbarVc = (UITabBarController *)[JCViewHelper mainTab];
	UINavigationController *nav = tabbarVc.navigationController;
	return (JCNavigationViewController *)nav;
}

+ (JCNavigationViewController *)getNavViewController:(UIViewController *)root {
	JCNavigationViewController *nav = [[JCNavigationViewController alloc] initWithNavigationBarClass:[JCNavigationBar class] toolbarClass:nil];
	[nav pushViewController:root animated:NO];
	return nav;
}

#pragma mark - UINavigationController Helper

+ (void)pushViewController:(UIViewController *)controller showNavBar:(BOOL)show {
	UINavigationController *nav = [JCViewHelper currentNavigationController];
	nav.navigationBar.hidden = !show;
	UIViewController *pnav = [nav.topViewController presentedViewController];
	if (pnav) {
		if ([pnav isKindOfClass:[UINavigationController class]]) {
			UINavigationController *root = (UINavigationController *)pnav;
			[root pushViewController:controller animated:YES];
			return;
		}
	}
	[nav pushViewController:controller animated:YES];
}

+ (void)pushViewControllerAtFirstMainTab:(UIViewController *)controller animate:(BOOL)animate {
	JCNavigationViewController *nav = (JCNavigationViewController *)[JCViewHelper currentNavigationController];
	if ([JCViewHelper mainTab].selectedIndex == 0) {
        [nav popToRootViewControllerAnimated:NO];
        [nav pushViewController:controller animated:animate];
	}
	else {
		[nav pushViewController:controller animated:animate completion: ^{
		    [JCViewHelper mainTab].selectedIndex = 0;
            [JCViewHelper mainTab].selectedIndex = 0;
		    nav.viewControllers = @[[JCViewHelper mainTab], controller];
		}];
	}
}

+ (void)popupTopViewController:(BOOL)animate {
	UINavigationController *nav = [JCViewHelper currentNavigationController];
	[nav popViewControllerAnimated:animate];
}

+ (void)setRootViewController:(UIViewController *)controller {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.window.rootViewController = controller;
}

+ (void)presentModelViewController:(UIViewController *)controller {
	UINavigationController *nav = [JCViewHelper currentNavigationController];
    [nav.topViewController presentViewController:controller animated:YES completion:^{
    }];
}

+ (void)dismissModelViewController {
	UINavigationController *nav = [JCViewHelper currentNavigationController];
	[nav.topViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

+ (void)setMainTabNil {
	mainTab = nil;
}

+ (HLTabBarController *)mainTab {
	return mainTab;
}

+ (BOOL)isCurrentViewControllerOnTop:(UIViewController *)controller {
	return [(JCNavigationViewController *)[JCViewHelper currentNavigationController] showingTopViewController] == controller;
}

@end


@implementation JCViewHelper (HUD)

#pragma mark - HUD


#define kImageHudTag  3323
+ (void)showHudOnFrontWindowWithImage:(NSString *)imageName autoHide:(NSString *)text {
	if (![[[[UIApplication sharedApplication] keyWindow] viewWithTag:kImageHudTag] superview]) {
		JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
		hud.tag = kImageHudTag;
		hud.indicatorView = nil;
		hud.textLabel.text = text;
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
		imageView.image = [UIImage imageNamed:imageName];
		hud.tipImageView = imageView;
		[hud showInView:[[UIApplication sharedApplication] keyWindow]];
		[hud dismissAfterDelay:3.0];
	}
}

#define HUD_TAG 1234

+ (KVNProgressConfiguration *)customKVNProgressUIConfiguration
{
    KVNProgressConfiguration *configuration = [KVNProgressConfiguration defaultConfiguration];
    configuration.tapBlock = ^(KVNProgress *progress) {
        [KVNProgress dismiss];
    };
    configuration.circleSize = 0.0f;
    return configuration;
}

+ (void)showTextTipInView:(UIView *)view withText:(NSString *)text delayHide:(float)duration {
    [KVNProgress setConfiguration:[JCViewHelper customKVNProgressUIConfiguration]];
    [KVNProgress showWithStatus:text onView:view];
    dispatch_main_after(duration, ^{
        [KVNProgress dismiss];
    });
}

+ (void)showTextTipOnFrontWindowAutoHide:(NSString *)text {
	[JCViewHelper showTextTipInView:[[UIApplication sharedApplication] keyWindow] withText:text delayHide:2];
}

+ (void)removeHudOnView:(UIView *)view {
    [KVNProgress dismiss];
}

+ (void)showHudInView:(UIView *)view withText:(NSString *)text {
    [KVNProgress setConfiguration:[KVNProgressConfiguration defaultConfiguration]];
    [KVNProgress showWithStatus:text onView:view];
}

+ (void)showHudOnFrontWindowWithText:(NSString *)text {
    [JCViewHelper showHudInView:[[UIApplication sharedApplication] keyWindow] withText:text];
}

+ (void)showHudOnFrontWindowWithTextNoMask:(NSString *)text {
	[JCViewHelper showHudInView:[JCViewHelper currentNavigationController].topViewController.view withText:text];
}

+ (void)hideHudOnFrontWindow {
    [JCViewHelper removeHudOnView:[JCViewHelper currentNavigationController].topViewController.view];
    [JCViewHelper removeHudOnView:[[UIApplication sharedApplication] keyWindow]];
}

+ (void)showSuccess:(NSString *)text {
    KVNProgressConfiguration *configuration = [KVNProgressConfiguration defaultConfiguration];
    configuration.tapBlock = ^(KVNProgress *progress) {
        [KVNProgress dismiss];
    };
    [KVNProgress setConfiguration:configuration];
    [KVNProgress showSuccessWithStatus:text];
}

+ (void)showError:(NSString *)text {
    KVNProgressConfiguration *configuration = [KVNProgressConfiguration defaultConfiguration];
    configuration.tapBlock = ^(KVNProgress *progress) {
        [KVNProgress dismiss];
    };
    [KVNProgress setConfiguration:configuration];
    [KVNProgress showErrorWithStatus:text];
}

+ (void)showHudOnFrontWindow:(NSString *)text delayHide:(float)duration {
    [JCViewHelper showHudInView:[[UIApplication sharedApplication] keyWindow] withText:text];
    dispatch_main_after(duration, ^{
        [JCViewHelper hideHudOnFrontWindow];
    });
}

+ (void)showNetworkError {
	[JCViewHelper showError:NSLocalizedString(@"网络异常", nil)];
}

@end


@implementation JCViewHelper (UIBarButtonItem)

#pragma mark - UIBarButtonItem Helper

+ (UIBarButtonItem *)getRightUIBarBtnItemWithImage:(UIImage *)image
                                        withTarget:(id)target withSEL:(SEL)sel {
	int width = 50;
	CGRect frameimg = CGRectMake(0, 0, width, image.size.height);
	UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
	[someButton setImage:image forState:UIControlStateNormal];
	[someButton setImage:image forState:UIControlStateHighlighted];
	if (IOS7_ABOVE) {
		[someButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
	}
	[someButton addTarget:target action:sel
	     forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
	return barItem;
}

+ (UIBarButtonItem *)getRightUIBarBtnItemWithTitle:(NSString *)title
                                        withTarget:(id)target withSEL:(SEL)sel {
	UIFont *font = [UIFont boldSystemFontOfSize:15.0];
	UIImage *image3 = [[UIImage imageNamed:@"btn_title_edit_on.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 32, 20)];
	CGSize size = [title sizeWithFont:font constrainedToSize:CGSizeMake(100, 20)];
	int width = size.width + 12;
	if (width < 50) {
		width = 50;
	}
	CGRect frameimg = CGRectMake(0, 0, width, image3.size.height);
	UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
	[someButton setBackgroundImage:image3 forState:UIControlStateNormal];
	[someButton setBackgroundImage:image3 forState:UIControlStateHighlighted];
	[someButton setBackgroundImage:[UIImage imageNamed:@"btn_title_edit_off.png"] forState:UIControlStateHighlighted];
	[someButton addTarget:target action:sel
	     forControlEvents:UIControlEventTouchUpInside];
	[someButton setTitle:title forState:UIControlStateNormal];
	[someButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	someButton.showsTouchWhenHighlighted = NO;
	someButton.titleLabel.font = font;
	someButton.accessibilityHint = @"UIBarButtonItem_Right";
	UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
	return barItem;
}

+ (UIBarButtonItem *)getRightUIBarBtnItemWithTitleAndBlock:(NSString *)title
                                                 withBlock:(void (^)())block {
	UIFont *font = [UIFont boldSystemFontOfSize:12];
	UIImage *image3 = [[UIImage imageNamed:@"btn_title_edit_on.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 32, 20)];
	CGSize size = [title sizeWithFont:font constrainedToSize:CGSizeMake(100, 20)];
	int width = size.width + 12;
	if (width < 50) {
		width = 50;
	}
	CGRect frameimg = CGRectMake(0, 0, width, image3.size.height);
	UIBlockButton *someButton = [[UIBlockButton alloc] initWithFrame:frameimg];
	[someButton setBackgroundImage:image3 forState:UIControlStateNormal];
	[someButton setBackgroundImage:image3 forState:UIControlStateHighlighted];
	[someButton setBackgroundImage:[UIImage imageNamed:@"btn_title_edit_off.png"] forState:UIControlStateHighlighted];

	[someButton handleControlEvent:UIControlEventTouchUpInside withBlock:block];
	someButton.accessibilityHint = @"UIBarButtonItem_Right";
	[someButton setTitle:title forState:UIControlStateNormal];
	someButton.showsTouchWhenHighlighted = NO;
	someButton.titleLabel.font = font;
	UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
	return barItem;
}

+ (UIBarButtonItem *)getNavBtn:(NSString *)imageName
                    withTarget:(id)target withSEL:(SEL)sel {
	UIImage *icon = [UIImage imageNamed:imageName];
	return [JCViewHelper getNavBtnWithImage:icon withTarget:target withSEL:sel];
}

+ (UIBarButtonItem *)getNavBtnWithImage:(UIImage *)icon
                             withTarget:(id)target withSEL:(SEL)sel {
	int width = 50;
	CGRect frameimg = CGRectMake(0, 0, width, icon.size.height);
	UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
	[someButton setImage:icon forState:UIControlStateNormal];
	[someButton setImage:icon forState:UIControlStateHighlighted];
	if (IOS7_ABOVE) {
		[someButton setImageEdgeInsets:UIEdgeInsetsMake(0, 18, 0, -18)];
	}
	else {
		[someButton setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
	}
	[someButton addTarget:target action:sel
	     forControlEvents:UIControlEventTouchUpInside];
	someButton.showsTouchWhenHighlighted = NO;
	UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
	return barItem;
}

+ (UIBarButtonItem *)getNavBtnNormal:(UIImage *)normalImageName hightlighit:(UIImage *)hImage
                          withTarget:(id)target withSEL:(SEL)sel {
	int width = 50;
	CGRect frameimg = CGRectMake(0, 0, width, normalImageName.size.height);
	UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
	[someButton setImage:normalImageName forState:UIControlStateNormal];
	[someButton setImage:hImage forState:UIControlStateHighlighted];
	[someButton addTarget:target action:sel
	     forControlEvents:UIControlEventTouchUpInside];
	someButton.showsTouchWhenHighlighted = NO;
	UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
	return barItem;
}

+ (UIBarButtonItem *)getLeftUIBarBtnItemWithTarget:(id)target withSEL:(SEL)sel {
	UIButton *someButtom = [JCViewHelper getNavButtonWithNormalImage:[UIImage imageNamed:@"navBarBack.png"] withHighLightImage:[UIImage imageNamed:@"navBarBack.png"] withTarget:target withSEL:sel];
	UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:someButtom];
	return barItem;
}

+ (UIBarButtonItem *)getLeftUIBarBtnItemWithTarget:(id)target withSEL:(SEL)sel withBadge:(NSString *)val {
	UIButton *someButtom = [JCViewHelper getNavButtonWithNormalImage:[UIImage imageNamed:@"navBarBack.png"] withHighLightImage:[UIImage imageNamed:@"navBarBack.png"] withTarget:target withSEL:sel];
	return [JCViewHelper generateUIBarBtnItemWithButton:someButtom withBadge:val];
}

+ (UIBarButtonItem *)generateUIBarBtnItemWithButton:(UIButton *)someButtom withBadge:(NSString *)val {
	BBBadgeBarButtonItem *barItem = [[BBBadgeBarButtonItem alloc] initWithCustomView:someButtom];
	barItem.badgeValue = val;
	barItem.badgeBGColor = [UIColor colorWithRed:0xe5 / 255.0 green:0x22 / 255.0 blue:0x1b / 255.0 alpha:1];
	barItem.badgeTextColor = [UIColor whiteColor];
	if (!IOS7_ABOVE) {
		barItem.badgeOriginX = 15;
	}
	else {
		barItem.badgeOriginX = 10;
	}
	barItem.badgeOriginY = 6;
	barItem.badgePadding = -3;
	barItem.badgeFont = [UIFont systemFontOfSize:12];
	return barItem;
}

+ (UIButton *)getNavButtonWithNormalImage:(UIImage *)image withHighLightImage:(UIImage *)hightLightImage
                               withTarget:(id)target withSEL:(SEL)sel {
	int width = 50;
	CGRect frameimg = CGRectMake(0, 0, width, image.size.height);
	UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
	[someButton setImage:image forState:UIControlStateNormal];
	[someButton setImage:hightLightImage forState:UIControlStateHighlighted];
	[someButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
	if (IOS7_ABOVE) {
		[someButton setImageEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
	}
	else {
		[someButton setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
	}
	[someButton addTarget:target action:sel
	     forControlEvents:UIControlEventTouchUpInside];
	someButton.accessibilityHint = @"UIBarButtonItem_Left";
    [someButton setShowsTouchWhenHighlighted:NO];
	return someButton;
}

+ (UIBarButtonItem *)getConfirmBtnItemWithTarget:(id)target withSEL:(SEL)sel {
	int width = 50;
	CGRect frameimg = CGRectMake(0, 0, width, 40);
	UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
	[someButton setTitle:NSLocalizedString(@"confirm", nil) forState:UIControlStateNormal];
	[someButton setTitle:NSLocalizedString(@"confirm", nil) forState:UIControlStateHighlighted];
	[someButton setTitleColor:colorWithGlobalThemeKey(@"right_btn_title_color_normal") forState:UIControlStateNormal];
	[someButton setTitleColor:colorWithGlobalThemeKey(@"right_btn_title_color_highlight") forState:UIControlStateHighlighted];
	[someButton addTarget:target action:sel
	     forControlEvents:UIControlEventTouchUpInside];
	if (IOS7_ABOVE) {
		[someButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
	}
	[someButton setShowsTouchWhenHighlighted:NO];
	UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
	return barItem;
}

+ (UIBarButtonItem *)getTextItemWithTarget:(NSString *)title forTarget:(id)target withSEL:(SEL)sel {
	int width = [title sizeWithFont:[UIFont systemFontOfSize:14.0]].width + 20;
	CGRect frameimg = CGRectMake(0, 0, width, 40);
	UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
	[someButton setTitle:title forState:UIControlStateNormal];
	[someButton setTitle:title forState:UIControlStateHighlighted];
	[someButton setTitleColor:colorWithGlobalThemeKey(@"right_btn_title_color_normal") forState:UIControlStateNormal];
	[someButton setTitleColor:colorWithGlobalThemeKey(@"right_btn_title_color_highlight") forState:UIControlStateHighlighted];
	[someButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
	[someButton addTarget:target action:sel
	     forControlEvents:UIControlEventTouchUpInside];
	if (IOS7_ABOVE) {
		[someButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
	}
	[someButton setShowsTouchWhenHighlighted:NO];
	UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
	return barItem;
}

+ (UIBarButtonItem *)getLeftTextItemWithTarget:(NSString *)title forTarget:(id)target withSEL:(SEL)sel {
	int width = [title sizeWithFont:[UIFont systemFontOfSize:15]].width + 20;
	CGRect frameimg = CGRectMake(0, 0, width, 40);
	UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
	[someButton setTitle:title forState:UIControlStateNormal];
	[someButton setTitle:title forState:UIControlStateHighlighted];
	[someButton setTitleColor:colorWithGlobalThemeKey(@"right_btn_title_color_normal") forState:UIControlStateNormal];
	[someButton setTitleColor:colorWithGlobalThemeKey(@"right_btn_title_color_highlight") forState:UIControlStateHighlighted];
	[someButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
	[someButton addTarget:target action:sel
	     forControlEvents:UIControlEventTouchUpInside];
	if (IOS7_ABOVE) {
		[someButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
	}
	[someButton setShowsTouchWhenHighlighted:NO];
	UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
	return barItem;
}

+ (void)deleteTempAudioFile:(NSString *)path {
    dispatch_async(kGlobalQueue, ^(void) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        BOOL fileExists = [fileManager fileExistsAtPath:path];
        if (fileExists) {
            BOOL success = [fileManager removeItemAtPath:path error:&error];
            if (!success) NSLog(@"Error: %@", [error localizedDescription]);
        }
    });
}

+ (UIView *)generateHudBgView:(UIView *)hud {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
        
        temp = statusBarFrame.size.width;
        statusBarFrame.size.width = statusBarFrame.size.height;
        statusBarFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    
    CGFloat posY = floor(activeHeight * 0.45);
    CGFloat posX = orientationFrame.size.width / 2;
    
    CGPoint newCenter;
    //CGFloat rotateAngle;
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            //rotateAngle = M_PI;
            newCenter = CGPointMake(posX, orientationFrame.size.height - posY);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            //rotateAngle = -M_PI/2.0f;
            newCenter = CGPointMake(posY, posX);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            //rotateAngle = M_PI/2.0f;
            newCenter = CGPointMake(orientationFrame.size.height - posY, posX);
            break;
            
        default: // as UIInterfaceOrientationPortrait
            //rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
            break;
    }
    hud.center = newCenter;
    return hud;
}

+(void)loadGuideViewToView:(UIWindow*)applicationWindown imageArr:(NSArray*)imageArr pageIconImage:(UIImage*)iconImage pageSelectedIconImage:(UIImage*)selectedIconImage
{
    NSString *FirstUsedApp =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:FirstUsedApp])
    {
        JCGuideView *guideView = [[JCGuideView alloc]initWithFrame:applicationWindown.frame];
        [guideView initSubviews:applicationWindown picArr:imageArr pageIcon:iconImage pageSelectedIcon:selectedIconImage];
    }
}

@end
