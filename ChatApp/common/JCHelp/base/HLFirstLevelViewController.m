//
//  SLFirstLevelViewController.m
//  Shanliao
//
//  Created by gsw on 3/7/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "HLFirstLevelViewController.h"
#import "JCSkinManager.h"

@interface HLFirstLevelViewController ()
{
    UILabel *lableTitleView;
}
@end

@implementation HLFirstLevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    self.autoCreateBackButtonItem = NO;
}

/**
 *  第一个级别的 navigationItem 需要复写了，只有最顶层一个UINavigationViewController
 *
 *  @return
 */
- (UINavigationItem *)navigationItem {
    return [JCViewHelper mainTab].navigationItem;
}

/**
 *  强迫显示状态栏，因为某些页面没有状态栏，收到震通知会导致状态栏消失
 *
 *  @param animated 
 */

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    if (self.navigationController.navigationBarHidden) {
        [[JCViewHelper currentNavigationController] setNavigationBarHidden:NO animated:NO];
    }
}

#pragma mark - Slot

- (void)setTitle:(NSString *)title {
    if (!lableTitleView
        || ![lableTitleView isKindOfClass:[UILabel class]]) {
        lableTitleView = [[UILabel alloc] initWithFrame:CGRectZero];
        lableTitleView.backgroundColor = [UIColor clearColor];
        lableTitleView.font = [UIFont boldSystemFontOfSize:17.0];
    }
    lableTitleView.textColor = [UIColor whiteColor];
    lableTitleView.text = title;
    [lableTitleView sizeToFit];
    [self setTitleView:lableTitleView];
}

#pragma --mark skin beign

- (void)applySkin:(NSDictionary *)properties {
    lableTitleView.textColor = colorWithGlobalThemeKey(@"title_text_attributes_color");
    lableTitleView.text = lableTitleView.text;
}


- (NSString *)skinKey {
	return @"HLFirstLevelViewController";
}

#pragma --mark skin end
@end
