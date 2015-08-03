//
//  XJTabBarController.m
//  ChatApp
//
//  Created by howard on 14/11/18.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import "HLTabBarController.h"
#import "JCNetworkChecker.h"
#import "JCSkinManager.h"
#import "HLFirstLevelViewController.h"
#import "HLHomeViewController.h"
#import "HLMeViewController.h"
#import "HLOptionViewController.h"
#import "HLAptitudesViewController.h"
#import "HLTradeViewController.h"

@interface HLTabBarController () <UITabBarControllerDelegate>
{
    UIViewController *lastSelectedViewController;
    NSDate *lastClickTabDate;
}
@end

@implementation HLTabBarController

@synthesize appearCallback;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self connect:@selector(changeSkin) from:[EventBus shared] with:@selector(changeSkin)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SLGloble shareInstance].tabbarHeight = self.tabBar.frame.size.height;
    [self setupNavController];
    [self setupAppearance];
    [self setUpSearchBarApperance];
}


- (void)setupNavController {
    HLHomeViewController *home = [HLHomeViewController new];
    HLOptionViewController *option = [HLOptionViewController new];
    HLAptitudesViewController *apt = [HLAptitudesViewController new];
    HLTradeViewController *trade = [HLTradeViewController new];
    HLMeViewController *me = [HLMeViewController new];
    self.viewControllers = @[home,option,apt,trade,me];
    self.delegate = self;
}

- (void)setupAppearance {
    
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tab_main_background.png"];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
        UIImage *tab1 = [UIImage imageNamed:@"tabHome.png"];
        UIImage *tab1s = [UIImage imageNamed:@"tabHomeS.png"];
        tab1 = [tab1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tab1s = [tab1s imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ((UIViewController *)[self.viewControllers objectAtIndex:0]).tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"", nil) image:tab1 selectedImage:tab1s];
        
        tab1 = [UIImage imageNamed:@"tabCircle.png"];
        tab1s = [UIImage imageNamed:@"tabCircleS.png"];
        tab1 = [tab1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tab1s = [tab1s imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ((UIViewController *)[self.viewControllers objectAtIndex:1]).tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"", nil) image:tab1 selectedImage:tab1s];
    
        
        tab1 = [UIImage imageNamed:@"tabDiscover.png"];
        tab1s = [UIImage imageNamed:@"tabDiscoverS.png"];
        tab1 = [tab1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tab1s = [tab1s imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ((UIViewController *)[self.viewControllers objectAtIndex:2]).tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"", nil) image:tab1 selectedImage:tab1s];
        
        tab1 = [UIImage imageNamed:@"tabMe.png"];
        tab1s = [UIImage imageNamed:@"tabMeS.png"];
        tab1 = [tab1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tab1s = [tab1s imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ((UIViewController *)[self.viewControllers objectAtIndex:3]).tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"", nil) image:tab1 selectedImage:tab1s];
    
    tab1 = [UIImage imageNamed:@"tabMe.png"];
    tab1s = [UIImage imageNamed:@"tabMeS.png"];
    tab1 = [tab1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tab1s = [tab1s imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ((UIViewController *)[self.viewControllers objectAtIndex:4]).tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"", nil) image:tab1 selectedImage:tab1s];
    
    [(UITabBarItem *)[self.tabBar.items objectAtIndex:0] setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    [(UITabBarItem *)[self.tabBar.items objectAtIndex:1] setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    [(UITabBarItem *)[self.tabBar.items objectAtIndex:2] setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    [(UITabBarItem *)[self.tabBar.items objectAtIndex:3] setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:4] setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
}


- (void)setUpSearchBarApperance {
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  colorWithGlobalThemeKey(@"search_cancel_title_color"),
                                                                                                  NSForegroundColorAttributeName,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  colorWithGlobalThemeKey(@"search_cancel_title_color_on"),
                                                                                                  NSForegroundColorAttributeName,
                                                                                                  nil]
                                                                                        forState:UIControlStateHighlighted];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.appearCallback) {
        self.appearCallback();
        self.appearCallback = nil;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == lastSelectedViewController) {
        //tab same view contoller
        NSTimeInterval interval = [lastClickTabDate timeIntervalSinceNow];
        if (abs(interval) < 1) {
            [self doubleClickTab:viewController];
        }
    }
    if (tabBarController.selectedIndex == 1) {
        
        
    }else if (tabBarController.selectedIndex == 2){
        
    }
    lastClickTabDate = [NSDate date];
    lastSelectedViewController = viewController;
}

- (void)doubleClickTab:(UIViewController *)controller {
    if (self.selectedIndex == 0) {
        
    }
}

- (void)dealloc {
    self.viewControllers = nil;
}

#pragma --mark skin beign

- (void)applySkin:(NSDictionary *)properties {
        [self setupAppearance];
}

- (NSString *)skinKey {
    return NSStringFromClass([self class]);
}

- (void)changeSkin {
    [self applySkin:[[JCSkinManager shared] getSkin:[self skinKey]]];
}

@end