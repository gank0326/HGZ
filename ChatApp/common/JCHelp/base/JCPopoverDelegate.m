//
//  SLPopoverDelegate.m
//  Shanliao
//
//  Created by gsw on 3/17/14.
//  Copyright (c) 2014 6rooms. All rights reserved.
//

#import "JCPopoverDelegate.h"
#import "JCSkinManager.h"

@implementation SLPopupCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self.contentView addSubview:self.cellImage];
		[self.contentView addSubview:self.cellTitle];
        self.contentView.backgroundColor = [@"313131" toColor];
	}
	return self;
}

- (UIImageView *)cellImage {
	if (!_cellImage) {
		_cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(7, 10, 14, 14)];
	}
	return _cellImage;
}

- (UILabel *)cellTitle {
	if (!_cellTitle) {
		_cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(60 / 2, 7, 200, 20)];
		_cellTitle.backgroundColor = [UIColor clearColor];
		_cellTitle.font = [UIFont systemFontOfSize:13];
        _cellTitle.textColor = [UIColor whiteColor];
	}
	return _cellTitle;
}

@end


@implementation JCPopoverDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
		SLPopupCell *cell = [[SLPopupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"popcell"];
		cell.cellTitle.text = NSLocalizedString(@"添加朋友", nil);
        cell.cellImage.image = [UIImage imageNamed:@"contactMore.png"];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [@"535353" toColor];
        cell.selectedBackgroundView = selectionColor;
		return cell;
	}
    else if (indexPath.row == 1) {
        SLPopupCell *cell = [[SLPopupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"popcell"];
        cell.cellTitle.text = NSLocalizedString(@"扫一扫", nil);
        cell.cellImage.image = [UIImage imageNamed:@"contactScan.png"];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [@"535353" toColor];
        cell.selectedBackgroundView = selectionColor;
        return cell;
    }
    else if (indexPath.row == 2) {
        SLPopupCell *cell = [[SLPopupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"popcell"];
        cell.cellTitle.text = NSLocalizedString(@"发起群聊", nil);
        cell.cellImage.image = [UIImage imageNamed:@"contactMore.png"];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [@"535353" toColor];
        cell.selectedBackgroundView = selectionColor;
        return cell;
    }
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	switch (indexPath.row) {
		default:
			break;
	}
	[[EventBus shared] emit:@selector(dismissPopoverMenu) withArguments:[NSArray array]];
}

@end
