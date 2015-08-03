//
//  SLCustomSubtitleCell.h
//  Shanliao
//
//  Created by lu gang on 8/18/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCopyableLabel.h"

#define CELL_TITLE_FONT_SIZE 15
#define CELL_DETAIL_FONT_SIZE 13

@interface SLCustomSubtitleCell : UITableViewCell
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detailTitle;
@property (nonatomic) UILabel *cDetailLabel;
+ (CGFloat)calcCellHeigh:(NSString *)detailString withEditMode:(BOOL)iseditMood;

@property (nonatomic) BOOL editMood;

@end


@interface SLCustomPlainCell : UITableViewCell
@property (nonatomic) UILabel *title;
@property (nonatomic) HTCopyableLabel *detailTitle;
@end
