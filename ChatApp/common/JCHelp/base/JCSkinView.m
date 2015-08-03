//
//  JCSkinVIew.m
//  Shanliao
//
//  Created by gsw on 4/16/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "JCSkinView.h"
#import "CMSignals.h"

@implementation JCSkinView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
	}
	return self;
}

- (void)applySkin:(NSDictionary *)properties {
}

- (NSString *)skinKey {
	return NSStringFromClass(self.class);
}

- (void)dealloc {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)subView;
            tableView.delegate = nil;
            tableView.dataSource = nil;
        }
    }
}

@end
