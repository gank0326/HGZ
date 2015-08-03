//
//  SLViewController.m
//  Shanliao
//
//  Created by gsw on 7/22/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "HLViewController.h"
#import "UIWindow+SL.h"
#import "JCSkinManager.h"
#import "JCLoginViewController.h"
#import "MobClick.h"

@implementation SLMethodInvoke
@end

@interface HLViewController ()
{
    BOOL viewDidloadCalled; //标志是不是已经call 了viewdidload
	UIView *rootView;
    UIBarButtonItem *leftButtonItem;
    UIBarButtonItem *rightButtonItem;
}
@property (nonatomic,strong)UIView *titleView;
@end

@implementation HLViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.animating = NO;
    self.isAppear = NO;
    self.enableSwapToPop = YES;
    self.enableEdgeSwapToPop = YES;
    
    viewDidloadCalled = YES;
    self.autoCreateBackButtonItem = YES;
//	self.view.backgroundColor = colorWithGlobalThemeKey(@"controller_background_color");
    [self connect:@selector(changeSkin) from:[EventBus shared] with:@selector(changeSkin)];
    self.view.backgroundColor = [@"f0f0f0" toColor];
    
    [JCViewHelper showError:@"失败"];
    [JCViewHelper showSuccess:@"成功"];
    [JCViewHelper showHudOnFrontWindowWithTextNoMask:@"加载中"];
    [JCViewHelper hideHudOnFrontWindow];//隐藏hud
    [JCViewUtil alert:@"hah"];
    [JCViewHelper showNetworkError];//网络不行
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)setTitleView:(UIView *)titleView_{
    _titleView = titleView_;
    if (self.isAppear) {
        self.navigationItem.titleView = self.titleView;
    }
}

- (void)setNavLeftBarButtonItem:(UIBarButtonItem *)item {
    if (self.isAppear) {
        self.navigationItem.leftBarButtonItem = item;
    }
    leftButtonItem = item;
}

- (UIBarButtonItem *)currentLeftUIBarButtonItem {
    return leftButtonItem;
}

- (void)setNavRightBarButtonItem:(UIBarButtonItem *)item {
    if (self.isAppear) {
        self.navigationItem.rightBarButtonItem = item;
    }
    rightButtonItem = item;
}
 
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    if (title) {
        _titleView = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView setAnimationsEnabled:YES];
    if (self.navigationController && self.autoCreateBackButtonItem && !self.navigationItem.leftBarButtonItem) {
        UIBarButtonItem *item = [JCViewHelper getLeftUIBarBtnItemWithTarget:self withSEL:@selector(popupMyself)];
        self.navigationItem.leftBarButtonItem = item;
        leftButtonItem = item;
    }
    [self resetNav];
    [MobClick beginLogPageView:[self skinKey]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.animating = NO;
    self.isAppear = YES;
    [self resetNav];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isAppear = NO;
    [MobClick endLogPageView:[self skinKey]];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.animating = NO;
}

- (void)resetNav {
    if (self.titleView) {
        self.navigationItem.titleView = self.titleView;
    }
    if (rightButtonItem) {
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    if (leftButtonItem) {
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
}

- (UIView *)getRootView {
	if (!IOS7_ABOVE) {
		self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), [SLGloble shareInstance].getHeightExeceptStatusAndNav);
		return self.view;
	}
	else {
		if (!rootView) {
			int y = 0;
			rootView = [[UIView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.frame), [SLGloble shareInstance].getHeightExeceptStatusAndNav)];
			[self.view addSubview:rootView];
		}
        rootView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), [SLGloble shareInstance].getHeightExeceptStatusAndNav);
		return rootView;
	}
}

- (CGFloat)marginTop{
    if (!IOS7_ABOVE) {
        return 0;
    }
    UINavigationController *nav = self.navigationController;
    if (nav && nav.navigationBar.hidden) {
        return 0;
    }
    return [SLGloble shareInstance].statusBarHeight + [SLGloble shareInstance].navigatorBarHeight;
}

- (void)dealloc {
   
}

- (void)willPopupFromNavigation {
    if (viewDidloadCalled) {
        [self removeScrollViewDelegate:self.view];
    }
    [[CMSignals sharedSingleton] removeObserverBindOnSender:self];
}

-(void)removeScrollViewDelegate:(UIView *)subView
{
    if ([subView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *tableView = (UIScrollView *)subView;
        tableView.delegate = nil;
    }
    if (subView.subviews.count > 0) {
        for (UIView *subViews in subView.subviews) {
            [self removeScrollViewDelegate:subViews];
        }
    }
}

#pragma --mark skin beign
- (NSString *)skinKey {
    return NSStringFromClass(self.class);
}

- (void)changeSkin {
    [self applySkin:[[JCSkinManager shared] getSkin:[self skinKey]]];
}

- (void)applySkin:(NSDictionary *)properties {
}

#pragma --mark skin end

@end
