//
//  SLPopoverDelegate.h
//  Shanliao
//
//  Created by gsw on 3/17/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCPopoverDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

@end

@interface SLPopupCell : UITableViewCell
@property (nonatomic, strong) UIImageView *cellImage;
@property (nonatomic, strong) UILabel *cellTitle;

@end
