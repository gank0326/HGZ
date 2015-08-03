//
//  SLNavigationViewController.h
//  Shanliao
//
//  Created by gsw on 8/13/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCNavigationViewController : UINavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completion;

- (UIViewController *)showingTopViewController;

- (void)changeSkin;

@end
