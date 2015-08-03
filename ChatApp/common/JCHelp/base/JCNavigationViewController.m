//
//  SLNavigationViewController.m
//  Shanliao
//
//  Created by gsw on 8/13/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "JCNavigationViewController.h"
#import "CMSignals.h"
#import "JCViewUtil.h"
#import "Colors.h"
#import "HLViewController.h"
#import "JCSkinUtil.h"
#import "JCNavigationBar.h"
#import "EventBus.h"
#import "JCSkinManager.h"

@interface JCNavigationViewController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
}

@property (nonatomic, weak) UIViewController *currentShowVC;
@property (nonatomic, copy) dispatch_block_t completionBlock;
@property (nonatomic, weak) UIViewController *pushedVC;

@end

@implementation JCNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = colorWithGlobalThemeKey(@"controller_background_color");
	[self connect:@selector(changeSkin) from:[EventBus shared] with:@selector(changeSkin)];
	[self changeSkin];
	if (IOS7_ABOVE) {
		self.navigationBar.translucent = NO;
	}
	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
		__weak JCNavigationViewController *weakSelf = self;
		self.interactivePopGestureRecognizer.delegate = weakSelf;
	}
	self.delegate = self;
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(popupTopViewController)];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
}

- (void)popupTopViewController {
    if ([self.topViewController isKindOfClass:[HLViewController class]]) {
        HLViewController *topViewController = (HLViewController *)self.topViewController;
        if ([self.viewControllers count] > 1 && topViewController.enableSwapToPop) {
            [self popViewControllerAnimated:YES];
        }
    }
}

// Hijack the push method to disable the gesture

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completion {
    self.pushedVC = viewController;
    self.completionBlock = completion;
    [self pushViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.pushedVC != viewController) {
        self.pushedVC = nil;
        self.completionBlock = nil;
    }
	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
		self.interactivePopGestureRecognizer.enabled = NO;
	}
	BOOL isTopViewControllerSLViewController = [self.topViewController isKindOfClass:[HLViewController class]];
	if (isTopViewControllerSLViewController) {
		HLViewController *topViewController = (HLViewController *)self.topViewController;
		if (topViewController.animating) {
			return;
		}
	}
	if ([viewController isKindOfClass:[HLViewController class]]) {
		HLViewController *castViewController = (HLViewController *)viewController;
		castViewController.animating = animated;
		if (isTopViewControllerSLViewController) {
			HLViewController *topViewController = (HLViewController *)self.topViewController;
			topViewController.animating = animated;
		}
	}
	[super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	if ([self.topViewController isKindOfClass:[HLViewController class]]) {
		HLViewController *castViewController = (HLViewController *)self.topViewController;
		castViewController.animating = animated;
        [castViewController willPopupFromNavigation];
	}
	return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    for (NSUInteger i = self.viewControllers.count - 1; i > 0; i--) {
        if ([self.viewControllers[i] isKindOfClass:[HLViewController class]]) {
            HLViewController *castViewController = (HLViewController *)self.viewControllers[i];
            castViewController.animating = animated;
            [castViewController willPopupFromNavigation];
        }
    }
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
	// Enable the gesture again once the new controller is shown

	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
		self.interactivePopGestureRecognizer.enabled = YES;
	}
	if (navigationController.viewControllers.count == 1) {
		self.currentShowVC = nil;
	}
	else {
		self.currentShowVC = viewController;
	}
    
    if (self.completionBlock && self.pushedVC == viewController) {
        self.completionBlock();
        self.completionBlock = nil;
        self.pushedVC = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if ([self.topViewController isKindOfClass:[HLViewController class]]) {
            HLViewController *castViewController = (HLViewController *)self.topViewController;
            if (!castViewController.enableEdgeSwapToPop) {
                return NO;
            }
        }
		return (self.currentShowVC == self.topViewController) && !self.navigationBarHidden && self.navigationBar.frame.origin.y == StateBarHeight;
	}
	return YES;
}

- (void)changeSkin {
    JCNavigationBar *bar = (JCNavigationBar *)self.navigationBar;
    if (bar && [bar isKindOfClass:[JCNavigationBar class]]) {
        [bar setCustomBarTintColor:kThemeColor];
        [bar setShadowImage:[UIImage new]];
    }
    NSDictionary *navbarTitleTextAttributes
    = @{ UITextAttributeTextColor : [UIColor whiteColor],
         UITextAttributeTextShadowColor : [UIColor clearColor],
         UITextAttributeFont : [UIFont boldSystemFontOfSize:17],
         UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] };
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    self.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
	self = [super initWithNavigationBarClass:[JCNavigationBar class] toolbarClass:nil];
	if (self) {
		self.viewControllers = @[rootViewController];
	}
	return self;
}

- (UIViewController *)showingTopViewController {
	if (self.currentShowVC) {
		return _currentShowVC;
	}
	return [self topViewController];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
