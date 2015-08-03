//
//  engineerCell.m
//  MXR
//
//  Created by joychuang on 15/4/10.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "engineerCell.h"

@interface engineerCell()

@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UIImageView *sexIcon;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *reputablyLab;
@property(nonatomic,strong) UILabel *orderLab;
@property(nonatomic,strong) UILabel *distanceLab;

@end

@implementation engineerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        _headImageView.backgroundColor = [UIColor yellowColor];
    }
    return _headImageView;
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+15, 10, 160, 15)];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _nameLab.textColor = [@"282828" toColor];
    }
    return _nameLab;
}

- (UIImageView *)sexIcon {
    if (!_sexIcon) {
        _sexIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLab.frame), 10, 20, 20)];
        _sexIcon.backgroundColor = [UIColor redColor];
    }
    return _sexIcon;
}

- (UILabel *)reputablyLab {
    if (!_reputablyLab) {
        _reputablyLab = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 200, 10, 180, 15)];
        _reputablyLab.backgroundColor = [UIColor clearColor];
        _reputablyLab.textAlignment = NSTextAlignmentRight;
        _reputablyLab.textColor = [@"282828" toColor];
    }
    return _reputablyLab;
}

- (UILabel *)orderLab {
    if (!_orderLab) {
        _orderLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+15, 10, 160, 15)];
        _orderLab.backgroundColor = [UIColor clearColor];
        _orderLab.textAlignment = NSTextAlignmentLeft;
        _orderLab.textColor = [@"282828" toColor];
    }
    return _nameLab;
}

- (UILabel *)distanceLab {
    if (!_distanceLab) {
        _distanceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+15, 10, 160, 15)];
        _distanceLab.backgroundColor = [UIColor clearColor];
        _distanceLab.textAlignment = NSTextAlignmentLeft;
        _distanceLab.textColor = [@"282828" toColor];
    }
    return _distanceLab;
}

- (void)initUI {
    
}

- (void)fillData:(Engineer *)data {
   
}

@end
