//
//  SLViewController.h
//  Shanliao
//
//  Created by gsw on 7/22/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventBus.h"
#import "JCViewUtil.h"
#import "JCViewHelper.h"
#import "JCSkinUtil.h"
#import "JCSkinManager.h"
#import "UIViewController+SL.h"
#import "SLGloble.h"
#import "JCSkinDelegate.h"

#define TABLE_VIEW_GAP 11
#define BOTTOM_BOTTOM_HEIGHT 63
#define TABLE_VIEW_TREE_LINE_HEIGHT 82
#define UPLOAD_AVATAR_SIZE 720
#define USER_TELEPHONE @"userTelephone"
#define INTEREST_LOCATION_EXPIRE_TIME_VALUE 300

@interface SLMethodInvoke : NSObject

@property (nonatomic, strong) NSString *methodDesc;
@property (nonatomic, strong) void (^callback)(id);
@end

@interface HLViewController : UIViewController<JCSkinDelegate>

@property (nonatomic) BOOL autoCreateBackButtonItem;

@property (nonatomic) BOOL animating;

@property (nonatomic) BOOL isAppear;

@property (nonatomic) BOOL enableSwapToPop;

@property (nonatomic) BOOL enableEdgeSwapToPop;

- (UIView *)getRootView;

- (CGFloat)marginTop;

- (void)setTitleView:(UIView *)titleView;

- (void)setNavLeftBarButtonItem:(UIBarButtonItem *)item;

- (void)setNavRightBarButtonItem:(UIBarButtonItem *)item;

- (UIBarButtonItem *)currentLeftUIBarButtonItem;

- (void)willPopupFromNavigation;

@end
