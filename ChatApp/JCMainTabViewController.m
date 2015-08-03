//
//  JCMainTabViewController.m
//  ChatApp
//
//  Created by joychuang on 15/3/10.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCMainTabViewController.h"

static const NSUInteger tabBackgroundTag = 101;

static const NSUInteger tabFirstHightLightImageTag = 1021;
static const NSUInteger tabSecondHightLightImageTag = 1022;
static const NSUInteger tabThirdHightLightImageTag = 1023;

static const NSUInteger tabThirdRedIcon = 103;
static const NSUInteger tabSecondRedIcon = 104;

@interface JCMainTabViewController () <UITabBarControllerDelegate>
{
    UIViewController *lastSelectedViewController;
    NSDate *lastClickTabDate;
    BOOL irrgularStyle;
}
@end

@implementation JCMainTabViewController

@synthesize appearCallback;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SLGloble shareInstance].tabbarHeight = self.tabBar.frame.size.height;
    [self setupNavController];
    
    if (irrgularStyle) {
        [self setupIrrgularAppearance];
    }
    else {
        [self setupAppearance];
    }
    [self setUpSearchBarApperance];
}

- (void)setupNavController {
//    SLMessageViewController *messageViewController = [[SLMessageViewController alloc] init];
//    
//    SLContactViewViewController *contactVC = [[SLContactViewViewController alloc] init];
//    
//    SLDiscoverViewController *findGroup = [[SLDiscoverViewController alloc] init];
//    
//    self.viewControllers = [NSArray arrayWithObjects:messageViewController, contactVC, findGroup, nil];
    self.delegate = self;
//    lastSelectedViewController = messageViewController;
    lastClickTabDate = [NSDate date];
}

- (void)setupAppearance {
    [[self.tabBar viewWithTag:tabFirstHightLightImageTag] removeFromSuperview];
    [[self.tabBar viewWithTag:tabSecondHightLightImageTag] removeFromSuperview];
    [[self.tabBar viewWithTag:tabThirdHightLightImageTag] removeFromSuperview];
    [[self.tabBar viewWithTag:tabBackgroundTag] removeFromSuperview];
    
//    self.tabBar.backgroundImage = imageWithThemeKey(@"tab_background_image");
    if (IOS6_ABOVE) {
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:@"AmericanTypewriter" size:12.0f], UITextAttributeFont,
                                                       [UIColor whiteColor], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:@"AmericanTypewriter" size:12.0f], UITextAttributeFont,
                                                       [UIColor whiteColor], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
    
    
    if (IOS7_ABOVE) {
        UIImage *tab1 =  [UIImage imageNamed:@"tab_1_image_off"];//imageWithThemeKey(@"tab_1_image_off");
        UIImage *tab1s = [UIImage imageNamed:@"tab_1_image_off"];
        tab1 = [tab1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tab1s = [tab1s imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ((UIViewController *)[self.viewControllers objectAtIndex:0]).tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"main_tab_chat", nil) image:tab1 selectedImage:tab1s];
        
        tab1 = [UIImage imageNamed:@"tab_1_image_off"];
        tab1s = [UIImage imageNamed:@"tab_1_image_off"];
        tab1 = [tab1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tab1s = [tab1s imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ((UIViewController *)[self.viewControllers objectAtIndex:1]).tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"friend", nil) image:tab1 selectedImage:tab1s];
        
        tab1 = [UIImage imageNamed:@"tab_1_image_off"];
        tab1s = [UIImage imageNamed:@"tab_1_image_off"];
        tab1 = [tab1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tab1s = [tab1s imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ((UIViewController *)[self.viewControllers objectAtIndex:2]).tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"find_all", nil) image:tab1 selectedImage:tab1s];
    }else {
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage : [UIImage imageNamed:@"tab_1_image_off"]withFinishedUnselectedImage : [UIImage imageNamed:@"tab_1_image_off"]];
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:0] setTitle : NSLocalizedString(@"main_tab_chat", nil)];
        
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage : [UIImage imageNamed:@"tab_1_image_off"] withFinishedUnselectedImage : [UIImage imageNamed:@"tab_1_image_off"]];
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:1] setTitle : NSLocalizedString(@"friend", nil)];
        
        [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage : [UIImage imageNamed:@"tab_1_image_off"] withFinishedUnselectedImage : [UIImage imageNamed:@"tab_1_image_off"]];
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:2] setTitle : NSLocalizedString(@"find_all", nil)];
    }
    [(UITabBarItem *)[self.tabBar.items objectAtIndex:0] setTitlePositionAdjustment : UIOffsetMake(0, -3)];
    [(UITabBarItem *)[self.tabBar.items objectAtIndex:1] setTitlePositionAdjustment : UIOffsetMake(0, -3)];
    [(UITabBarItem *)[self.tabBar.items objectAtIndex:2] setTitlePositionAdjustment : UIOffsetMake(0, -3)];
}

static UIImage *tab1Off;
static UIImage *tab1On;
static UIImage *tab2Off;
static UIImage *tab2On;
static UIImage *tab3Off;
static UIImage *tab3On;

- (void)setupIrrgularAppearance {
    [[self.tabBar viewWithTag:tabFirstHightLightImageTag] removeFromSuperview];
    [[self.tabBar viewWithTag:tabSecondHightLightImageTag] removeFromSuperview];
    [[self.tabBar viewWithTag:tabThirdHightLightImageTag] removeFromSuperview];
    [[self.tabBar viewWithTag:tabBackgroundTag] removeFromSuperview];
    
    tab1Off = [UIImage imageNamed:@"tab_1_image_off"];//imageWithThemeKey(@"btn_chat_off");
    tab1On = [UIImage imageNamed:@"tab_1_image_off"];//imageWithThemeKey(@"btn_chat_on");
    tab2Off = [UIImage imageNamed:@"tab_1_image_off"];//imageWithThemeKey(@"btn_friend_off");
    tab2On = [UIImage imageNamed:@"tab_1_image_off"];//imageWithThemeKey(@"btn_friend_on");
    tab3Off = [UIImage imageNamed:@"tab_1_image_off"];//imageWithThemeKey(@"btn_find_off");
    tab3On = [UIImage imageNamed:@"tab_1_image_off"];//imageWithThemeKey(@"btn_find_on");
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_1_image_off"]];
    backgroundView.tag = tabBackgroundTag;
    UIImageView *tab1ImageView = [[UIImageView alloc] initWithImage:tab1Off];
    tab1ImageView.tag = tabFirstHightLightImageTag;
    UIImageView *tab2ImageView = [[UIImageView alloc] initWithImage:tab2Off];
    tab2ImageView.tag = tabSecondHightLightImageTag;
    UIImageView *tab3ImageView = [[UIImageView alloc] initWithImage:tab3Off];
    tab3ImageView.tag = tabThirdHightLightImageTag;
    
    [self.tabBar addSubview:backgroundView];
    [self.tabBar addSubview:tab1ImageView];
    [self.tabBar addSubview:tab2ImageView];
    [self.tabBar addSubview:tab3ImageView];
    backgroundView.frame = CGRectMake(0, CGRectGetHeight(self.tabBar.frame) - backgroundView.image.size.height, MainWidth, backgroundView.image.size.height);
//    tab1ImageView.center = CGPointMake(MainWidth/6.0f, (CGRectGetHeight(self.tabBar.frame) - tab1ImageView.image.size.height/2)/2);
//    tab2ImageView.center = CGPointMake(tab1ImageView.center.x + MainWidth/3.0f, (CGRectGetHeight(self.tabBar.frame) - tab2ImageView.image.size.height/2)/2);
//    tab3ImageView.center = CGPointMake(tab2ImageView.center.x +  MainWidth/3.0f, (CGRectGetHeight(self.tabBar.frame) - tab3ImageView.image.size.height/2)/2);
//    tab1ImageView.center = CGPointMake(tab1ImageView.center.x + [[currentSkinMap objectForKey:@"btn_chat_offset_x"] integerValue], tab1ImageView.center.y);
//    tab2ImageView.center = CGPointMake(tab2ImageView.center.x + [[currentSkinMap objectForKey:@"btn_find_offset_x"] integerValue], tab2ImageView.center.y);
//    tab3ImageView.center = CGPointMake(tab3ImageView.center.x + [[currentSkinMap objectForKey:@"btn_friend_offset_x"] integerValue], tab3ImageView.center.y);
    if (IOS6_ABOVE) {
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage alloc]];
    if (!IOS7_ABOVE) {
        self.tabBar.superview.backgroundColor = [UIColor whiteColor];//colorWithGlobalThemeKey(@"controller_background_color");
    }
    self.tabBar.backgroundColor = [UIColor clearColor];
    [[self tabBar] setTintColor:[UIColor clearColor]];
    if (IOS7_ABOVE) {
        self.tabBar.barTintColor = [UIColor clearColor];
        self.tabBar.barStyle = UIBarStyleBlackOpaque;
    }
    self.tabBar.backgroundImage = [UIImage new];
    for (UIViewController *child in self.viewControllers) {
        child.tabBarItem.title = nil;
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:@"AmericanTypewriter" size:12.0f], UITextAttributeFont,
                                                       [UIColor clearColor], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:@"AmericanTypewriter" size:12.0f], UITextAttributeFont,
                                                       [UIColor clearColor], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
    if (IOS7_ABOVE) {
        ((UIViewController *)[self.viewControllers objectAtIndex:0]).tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"main_tab_chat", nil) image:nil selectedImage:nil];
        
        ((UIViewController *)[self.viewControllers objectAtIndex:1]).tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"friend", nil) image:nil selectedImage:nil];
        
        ((UIViewController *)[self.viewControllers objectAtIndex:2]).tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"find_all", nil) image:nil selectedImage:nil];
    }else {
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage : nil withFinishedUnselectedImage : nil];
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:0] setTitle : nil];
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage : nil withFinishedUnselectedImage : nil];
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:1] setTitle : nil];
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage : nil withFinishedUnselectedImage : nil];
        [(UITabBarItem *)[self.tabBar.items objectAtIndex:2] setTitle : nil];
    }
    [self setHightLightTabbarImage:self];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    if (irrgularStyle) {
        [self setHightLightTabbarImage:self];
    }
}

- (void)setUpSearchBarApperance {
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor redColor],
                                                                                                  UITextAttributeTextColor,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor redColor],
                                                                                                  UITextAttributeTextColor,
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
//            [self doubleClickTab:viewController];
        }
    }
    if (tabBarController.selectedIndex == 1) {
//        [[SLMobileMyRelUserNewsUpdater get] reset];
        [[self.tabBar viewWithTag:tabSecondRedIcon] removeFromSuperview];
        
    }else if (tabBarController.selectedIndex == 2){
//        [[SLMobileFacade get] hideOutermostRedDot];
        [[self.tabBar viewWithTag:tabThirdRedIcon] removeFromSuperview];
    }
    lastClickTabDate = [NSDate date];
    lastSelectedViewController = viewController;
    [self setHightLightTabbarImage:tabBarController];
}

- (void)setHightLightTabbarImage:(UITabBarController *)tabBarController {
    if (irrgularStyle) {
        switch (tabBarController.selectedIndex) {
            case 0:
            {
                ((UIImageView *)[self.tabBar viewWithTag:tabFirstHightLightImageTag]).image = tab1On;
                ((UIImageView *)[self.tabBar viewWithTag:tabSecondHightLightImageTag]).image = tab2Off;
                ((UIImageView *)[self.tabBar viewWithTag:tabThirdHightLightImageTag]).image = tab3Off;
            }
                break;
            case 1:
            {
                ((UIImageView *)[self.tabBar viewWithTag:tabFirstHightLightImageTag]).image = tab1Off;
                ((UIImageView *)[self.tabBar viewWithTag:tabSecondHightLightImageTag]).image = tab2On;
                ((UIImageView *)[self.tabBar viewWithTag:tabThirdHightLightImageTag]).image = tab3Off;
            }
                break;
            case 2:
            {
                ((UIImageView *)[self.tabBar viewWithTag:tabFirstHightLightImageTag]).image = tab1Off;
                ((UIImageView *)[self.tabBar viewWithTag:tabSecondHightLightImageTag]).image = tab2Off;
                ((UIImageView *)[self.tabBar viewWithTag:tabThirdHightLightImageTag]).image = tab3On;
            }
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.viewControllers = nil;
}

#pragma mark - addRightItem

- (void)tabMeMenu:(id)sender {
    
}

- (void)addRightItem:(NSDictionary *)properties WithNew:(BOOL)isNew {
    int width = 50;
    UIBarButtonItem *barItem = nil;
    if (properties) {
        UIImage *normalImage = [UIImage imageNamed:@""];//imageWithTheme([properties objectForKey:@"right_menu_image"]);
        CGRect frameimg = CGRectMake(0, 0, width, normalImage.size.height);
        UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
        [someButton setImage:normalImage forState:UIControlStateNormal];
        [someButton setImage:normalImage forState:UIControlStateHighlighted];
        if (IOS7_ABOVE) {
            [someButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
        }
        [someButton addTarget:self action:@selector(tabMeMenu:)
             forControlEvents:UIControlEventTouchUpInside];
        someButton.showsTouchWhenHighlighted = NO;
        barItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
        if (isNew) {
            UIImageView *newtag = [[UIImageView alloc] initWithFrame:CGRectMake(46.5, 3, 7, 7)];
            newtag.image = [UIImage imageNamed:@""];//imageWithGlobalThemeKey(@"bg_red_point");
            [someButton addSubview:newtag];
        }
    }
    self.navigationItem.rightBarButtonItem = barItem;
}

@end
