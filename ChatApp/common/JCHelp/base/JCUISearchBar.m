//
//  SLUISearchBar.m
//  Shanliao
//
//  Created by gsw on 12/26/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import "JCUISearchBar.h"
#import "JCViewUtil.h"
#import "EventBus.h"
#import "JCSkinManager.h"

@interface JCUISearchBar ()
{
}
@end

@implementation JCUISearchBar

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self custom];
	}
	return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
}

- (void)custom {
	self.backgroundImage = [JCViewUtil imageWithColor:[UIColor clearColor]];
	[self connect:@selector(changeSkin) from:[EventBus shared] with:@selector(changeSkin)];
	[self changeSkin];
	if (!IOS7_ABOVE) {
		for (UIView *subview in self.subviews) {
			if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
				[subview removeFromSuperview];
			}
			else if ([subview isKindOfClass:[UITextField class]]) {
				UITextField *textField = (UITextField *)subview;
				textField.borderStyle = UITextBorderStyleNone;
				textField.layer.borderWidth = 0.5f;
				textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
				textField.layer.cornerRadius = 4.0f;
				textField.layer.shadowOffset = CGSizeMake(0, 0);
				textField.background = nil;
				textField.backgroundColor = [UIColor whiteColor];
				textField.frame = CGRectMake(10, 10, 90, 40);
			}
		}
		CGRect rect = self.frame;
		UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height - 2, rect.size.width, 2)];
		lineView.backgroundColor = [UIColor whiteColor];
		[self addSubview:lineView];
	}
	if (IOS7_ABOVE) {
		self.searchTextPositionAdjustment = UIOffsetMake(8, 0);
	}
	if (IOS7_ABOVE) {
		if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 70100) {
			[[[[self.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
		}
		else {
			self.barTintColor = [UIColor clearColor];
		}
	}
	else {
		self.tintColor = [UIColor clearColor];
	}
}

- (void)fixStyle {
	if (!IOS7_ABOVE) {
		for (id subview in[self subviews]) {
			if ([subview isKindOfClass:[UIButton class]]) {
				UIButton *btn = (UIButton *)subview;
				[btn setTitle:@""  forState:UIControlStateNormal];

				UILabel *lbl = [[UILabel alloc] initWithFrame:btn.bounds];
				lbl.backgroundColor = [JCViewUtil colorWithHexString:@"121212" alpha:1.f];
				lbl.textAlignment = NSTextAlignmentCenter;
				lbl.text = NSLocalizedString(@"group_create_table_titie_alert_cancel", nil);
                lbl.textColor = [JCViewUtil colorWithHexString:@"121212" alpha:1.f];
				[btn addSubview:lbl];
				break;
			}
		}
	}
}

- (void)changeSkin {
	UIImage *bgImage = [UIImage imageNamed:@"add_friends_search.png"];
	[self setSearchFieldBackgroundImage:bgImage forState:UIControlStateNormal];
	self.backgroundColor = colorWithGlobalThemeKey(@"search_bg_color");
}

@end
