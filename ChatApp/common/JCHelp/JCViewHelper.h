//
//  SLViewHelper.h
//  Shanliao
//
//  Created by gsw on 8/5/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLTabBarController.h"
#import "JCNavigationViewController.h"
#import "NSString+TM.h"
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM (NSInteger, SLNoDataTipImageType) {
	NO_DATA_DISPIRITED = 0,
	NO_DATA_SMILY
};

typedef NS_ENUM (NSInteger, SLImageUrlType) {
	SLImageUrlType_group_category = 68,
	SLImageUrlType_orinal = 0,
	SLImageUrlType_center_90_90 = 90,
	SLImageUrlType_center_160_160 = 160,
	SLImageUrlType_scale_90_90 = -90,
	SLImageUrlType_scale_160_160 = -160,
	SLImageUrlType_iphone6_plus = 1101,
	SLImageUrlType_iphone6 = 1102
};

@interface JCViewHelper : NSObject

+ (void)styleUITableViewCell:(UITableViewCell *)cell;

+ (void)styleGroupTableView:(UITableViewCell *)cell withTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath;

+ (UIColor *)getDefaultTableBackgroundColor;

+ (NSString *)fixImageUrl:(NSString *)url withType:(SLImageUrlType)type;

+ (UIView *)addNoDataTip:(UIView *)view withTextTip:(NSString *)text withImageType:(SLNoDataTipImageType)type withClickCallBack:(void (^)(void))touchCalback;
+ (UIView *)addNoDataTip:(UIView *)view withTextTip:(NSString *)text withImageType:(SLNoDataTipImageType)type withMargin:(UIEdgeInsets)insets withClickCallBack:(void (^)(void))touchCalback;

+ (void)removeDataTip:(UIView *)view;

+ (void)addLoadingMask:(UIView *)view withTip:(NSString *)tip;

+ (void)removeLoadingMask:(UIView *)view;

+ (NSString *)fixLocation:(double)distance;

+ (NSData *)adjustImageSize:(UIImage *)image;

+ (CGSize)getDisplaySize:(UIImage *)orinalImage withBoundSize:(CGSize)boundingSize limitLenght:(NSUInteger)length;

+ (CGSize)getDisplaySizebyOrinalSize:(CGSize)orinalSize withBoundSize:(CGSize)boundingSize limitLenght:(NSUInteger)length;

+ (NSData *)getOriginalImageDataByAsset:(ALAsset *)asset;

+ (NSData *)getUploadAlbumOrPostCreateImageData:(ALAsset *)asset;

+ (UIImage *)screenshot;

+ (void)relayoutBtnForVerticalLayout:(UIButton *)button;

+ (UIImage *)imageWithRoundedCornersSizeUsingImage:(UIImage *)original;

+ (BOOL)scrollToTableViewFoot:(UIScrollView *)scrollView;

+ (void)addCellSepLine:(UITableViewCell *)cell height:(CGFloat)cellHeight marginLeft:(CGFloat)left forHead:(BOOL)isHead;

+ (BOOL)isBackgroundMode;

+ (void)animationImageView:(UIImageView *)imageView;

+ (void)animationImageView:(UIImageView *)imageView withImageArr:(NSArray *)imageArr animateWithDuration:(NSTimeInterval)dur;

+ (BOOL)judgeCanFollowIsAddFriend:(BOOL)isAddFriends;

+ (void)showPokeWhenFirstEnterRoom;

+ (BOOL)myCreatedRoomsHas:(long long int)groupId;


@end

/**
 *  导航辅助方法
 */
@interface JCViewHelper (Navigation)

+ (void)popupToMainTab;

+ (HLTabBarController *)getMainView;

+ (void)navToMainView;

+ (UIViewController *)getEntranceView;

+ (void)pushViewController:(UIViewController *)controller showNavBar:(BOOL)show;

+ (void)popupTopViewController:(BOOL)animate;

+ (void)pushViewControllerAtFirstMainTab:(UIViewController *)controller animate:(BOOL)animate;

+ (void)presentModelViewController:(UIViewController *)controller;

+ (void)dismissModelViewController;

+ (void)setRootViewController:(UIViewController *)controller;

+ (UINavigationController *)getRootViewController;

+ (void)setMainTabNil;

+ (HLTabBarController *)mainTab;

+ (JCNavigationViewController *)currentNavigationController;

+ (JCNavigationViewController *)getNavViewController:(UIViewController *)root;

+ (BOOL)isCurrentViewControllerOnTop:(UIViewController *)controller;

@end


/**
 *  指示器辅助方法
 */
@interface JCViewHelper (HUD)

+ (void)showHudOnFrontWindowWithImage:(NSString *)imageName autoHide:(NSString *)text;

+ (void)showHudInView:(UIView *)view withText:(NSString *)text;

+ (void)showTextTipOnFrontWindowAutoHide:(NSString *)text;

+ (void)showTextTipInView:(UIView *)view withText:(NSString *)text delayHide:(float)duration;

+ (void)removeHudOnView:(UIView *)view;

+ (void)showHudOnFrontWindow:(NSString *)text delayHide:(float)duration;

+ (void)showHudOnFrontWindowWithText:(NSString *)text;

+ (void)showHudOnFrontWindowWithTextNoMask:(NSString *)text;

+ (void)hideHudOnFrontWindow;

+ (void)showSuccess:(NSString *)text;

+ (void)showError:(NSString *)text;

+ (void)showNetworkError;

@end

/**
 *  导航栏上面左右按钮辅助方法
 */
@interface JCViewHelper (UIBarButtonItem)

+ (UIBarButtonItem *)getRightUIBarBtnItemWithTitle:(NSString *)title
                                        withTarget:(id)target withSEL:(SEL)sel;

+ (UIBarButtonItem *)getRightUIBarBtnItemWithTitleAndBlock:(NSString *)title
                                                 withBlock:(void (^)())block;

+ (UIBarButtonItem *)getLeftUIBarBtnItemWithTarget:(id)target withSEL:(SEL)sel;

+ (UIBarButtonItem *)getLeftUIBarBtnItemWithTarget:(id)target withSEL:(SEL)sel withBadge:(NSString *)val;

+ (UIBarButtonItem *)getNavBtnNormal:(UIImage *)normalImageName hightlighit:(UIImage *)hImage
                          withTarget:(id)target withSEL:(SEL)sel;

+ (UIBarButtonItem *)getNavBtnWithImage:(UIImage *)icon
                             withTarget:(id)target withSEL:(SEL)sel;

+ (UIBarButtonItem *)getConfirmBtnItemWithTarget:(id)target withSEL:(SEL)sel;

+ (UIBarButtonItem *)getTextItemWithTarget:(NSString *)title forTarget:(id)target withSEL:(SEL)sel;

+ (UIBarButtonItem *)getLeftTextItemWithTarget:(NSString *)title forTarget:(id)target withSEL:(SEL)sel;

+ (UIBarButtonItem *)getNavBtn:(NSString *)imageName
                    withTarget:(id)target withSEL:(SEL)sel;

+ (UIBarButtonItem *)getRightUIBarBtnItemWithImage:(UIImage *)image
                                        withTarget:(id)target withSEL:(SEL)sel;

/*录音提示音乐*/

+ (void)deleteTempAudioFile:(NSString *)path;

+ (UIView *)generateHudBgView:(UIView *)hud;

/**
 *  加载app引导页
 *
 *  @param applicationWindown APP window
 *  @param imageArr           引导页图片名称数组
 *  @param iconImage          页码正常图
 *  @param selectedIconImage  页码选中图
 */
+(void)loadGuideViewToView:(UIWindow*)applicationWindown imageArr:(NSArray*)imageArr pageIconImage:(UIImage*)iconImage pageSelectedIconImage:(UIImage*)selectedIconImage;
@end
