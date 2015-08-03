//
//  SLAlbumEntryCell.h
//  Shanliao
//
//  Created by dylan on 15/1/14.
//  Copyright (c) 2015年 6rooms. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  相册入口的cell
 *  相册入口需求 见 《相册入口样式变更（4.0.0）》
 *  行数为1 列数为4
 */
@class SLPhotoArrangeView;
@interface SLAlbumEntryCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) SLPhotoArrangeView *arrangeView;
@property (nonatomic, strong, readonly) UILabel *countLabe;
@property (nonatomic, copy) void (^editBtnClickBlock)(void);

@property (nonatomic, assign) BOOL hasTitle;
@property (nonatomic, assign) BOOL canEdit;

- (void)fillData:(NSArray *)data;
- (void)setAlbumCount:(int)count;

+ (CGFloat)getCellHeightWithHasTitle:(BOOL)hasTitle;

@end

@interface SLPhotoArrangeView : UIView
@property (nonatomic, strong, readonly) NSArray *imageViewArray;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, assign) BOOL canSave;
@property (nonatomic, assign) BOOL canShowBrowse;
@property (nonatomic, assign) SLSuitableRectInput suitableRectInput;
@property (nonatomic, copy) void (^editBtnClickBlock)(void);
- (void)fillData:(NSArray *)data;
- (void)buildUI;

- (instancetype)initWithSuitableRectInput:(SLSuitableRectInput)input;
@end

