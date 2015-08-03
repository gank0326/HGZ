//
//  SLCustomSubtitleCell.m
//  Shanliao
//
//  Created by lu gang on 8/18/13.
//  Copyright (c) 2013 6rooms. All rights reserved.
//

#define CELLSUBTITLEMAXWIDTH  (MainWidth - 60)
#define CELL_EDIT_MODE_WIDTH (MainWidth - 50)
#define CELLSUBTITLEMAXWIDTHWITHACCESS  (MainWidth - 60)
#define CELLSUBTITLEMAXHEIGHT 1000

#import "SLCustomSubtitleCell.h"
@interface SLCustomSubtitleCell ()
@property (nonatomic) UILabel *cTitleLabel;
@end

@implementation SLCustomSubtitleCell

@synthesize title, detailTitle, cTitleLabel, cDetailLabel;

@synthesize editMood;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.title = @"";
		self.detailTitle = @"";
		// Initialization code
		self.cTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, 200, 30)];
		[self addSubview:self.cTitleLabel];
		self.cTitleLabel.font = [UIFont systemFontOfSize:CELL_TITLE_FONT_SIZE];
		self.cTitleLabel.backgroundColor = [UIColor clearColor];

		self.cDetailLabel = [[UILabel alloc] initWithFrame:CGRectNull];
		[self addSubview:self.cDetailLabel];
		self.cDetailLabel.numberOfLines = 0;
		self.cDetailLabel.lineBreakMode = NSLineBreakByCharWrapping;
		self.cDetailLabel.font = [UIFont systemFontOfSize:CELL_DETAIL_FONT_SIZE];
		self.cDetailLabel.backgroundColor = [UIColor clearColor];
		self.cDetailLabel.textColor = [UIColor grayColor];
        self.cDetailLabel.textAlignment = NSTextAlignmentLeft;
	}
	return self;
}

- (void)setTitle:(NSString *)title_ {
	self.cTitleLabel.text = title_;
}

+ (CGFloat)detailWidth:(BOOL)editMood {
	if (editMood) {
		return CELLSUBTITLEMAXWIDTH;
	}
	else {
		return CELL_EDIT_MODE_WIDTH;
	}
}

- (void)setDetailTitle:(NSString *)detailTitle_ {
	self.cDetailLabel.text = detailTitle_;
	CGSize subtitleSize = [detailTitle_ sizeWithFont:[UIFont systemFontOfSize:CELL_DETAIL_FONT_SIZE]  constrainedToSize:CGSizeMake([SLCustomSubtitleCell detailWidth:editMood], CELLSUBTITLEMAXHEIGHT) lineBreakMode:NSLineBreakByCharWrapping];

	self.cDetailLabel.frame = CGRectMake(17, 35, [SLCustomSubtitleCell detailWidth:editMood], subtitleSize.height);
}

+ (CGFloat)calcCellHeigh:(NSString *)detailString withEditMode:(BOOL)iseditMood {
	return 35 + [detailString sizeWithFont:[UIFont systemFontOfSize:CELL_DETAIL_FONT_SIZE]  constrainedToSize:CGSizeMake([self detailWidth:iseditMood], CELLSUBTITLEMAXHEIGHT) lineBreakMode:NSLineBreakByCharWrapping].height + 10;
}

@end


@implementation SLCustomPlainCell
@synthesize title = _title, detailTitle = _detailTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		_title = [[UILabel alloc] initWithFrame:CGRectMake(16 * Scale_Relative_320, 7, 120, 30)];
		_title.font = [UIFont systemFontOfSize:CELL_TITLE_FONT_SIZE];
		_title.backgroundColor = [UIColor clearColor];
		_title.textColor = [UIColor blackColor];
		[self addSubview:_title];

		_detailTitle = [[HTCopyableLabel alloc] initWithFrame:CGRectMake(MainWidth - 195, 7, 180, 30)];
		_detailTitle.font = [UIFont systemFontOfSize:CELL_DETAIL_FONT_SIZE];
		_detailTitle.backgroundColor = [UIColor clearColor];
		_detailTitle.textAlignment = NSTextAlignmentRight;
		_detailTitle.textColor = [UIColor grayColor];
		[self addSubview:_detailTitle];
	}
	return self;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
	[super setAccessoryType:accessoryType];
	if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
		_detailTitle.frame = CGRectMake(MainWidth - 225, 7, 190, 30);
	}
	else {
		_detailTitle.frame = CGRectMake(MainWidth - 205, 7, 190, 30);
	}
}

@end
