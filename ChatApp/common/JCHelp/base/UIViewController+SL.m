//
//  UIViewController+SL.m
//  Shanliao
//
//  Created by gsw on 8/13/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "UIViewController+SL.h"
#import "JCViewHelper.h"

@implementation UIViewController (SL)

- (void)popupMyself {
	[self.navigationController popViewControllerAnimated:YES];
	[JCViewHelper hideHudOnFrontWindow];
}

@end
