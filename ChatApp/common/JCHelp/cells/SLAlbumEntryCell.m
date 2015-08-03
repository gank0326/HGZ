//
//  SLAlbumEntryCell.m
//  Shanliao
//
//  Created by dylan on 15/1/14.
//  Copyright (c) 2015年 6rooms. All rights reserved.
//

#import "SLAlbumEntryCell.h"
#import "NSString+TM.h"
#import "UIImageView+SLBrowseImageViewer.h"

#define albumImageWidth 69*kCurrentWidthScale
#define kSuitableRectOutput ([JCViewUtil suitableCountFitRect:(SLSuitableRectInputMake(MainWidth-20, 69, 8))])

@interface SLAlbumEntryCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabe;;
@property (nonatomic, strong) SLPhotoArrangeView *arrangeView;

@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * backUpDataSource;

@end

@implementation SLAlbumEntryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - property
- (UIImageView *)cretaImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.userInteractionEnabled = YES;
    return imageView;
}

- (SLPhotoArrangeView *)arrangeView {
    if (!_arrangeView) {
        _arrangeView = [[SLPhotoArrangeView alloc] initWithSuitableRectInput:SLSuitableRectInputMake(MainWidth - 20, 69, 8)];
        CGRect rect = _arrangeView.frame;
        rect.origin.x = 10;
        rect.origin.y = 40;
        _arrangeView.frame = rect;
        [self.contentView addSubview:_arrangeView];
    }
    return _arrangeView;
}

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    self.arrangeView.canEdit = canEdit;
}

- (void)setEditBtnClickBlock:(void (^)(void))editBtnClickBlock {
    _editBtnClickBlock = editBtnClickBlock;
    [self.arrangeView setEditBtnClickBlock:editBtnClickBlock];
}

- (void)setHasTitle:(BOOL)hasTitle {
    _hasTitle = hasTitle;
    CGRect rect = self.arrangeView.frame;
    rect.origin.x = 10;
    if (hasTitle) {
        self.titleLabel.hidden = NO;
        rect.origin.y = 40;
    }
    else {
        self.titleLabel.hidden = YES;
        rect.origin.y = 13;
    }
    self.arrangeView.frame = rect;
    self.countLabe.frame = CGRectMake(MainWidth - 10*kCurrentWidthScale - 49, [SLAlbumEntryCell getCellHeightWithHasTitle:hasTitle] - 31, 45, 15);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*kCurrentWidthScale, 13, 200, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [@"606060" toColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)countLabe {
    if (!_countLabe) {
        _countLabe = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 10*kCurrentWidthScale - 49, [SLAlbumEntryCell getCellHeightWithHasTitle:self.hasTitle] - 31, 45, 15)];
        _countLabe.textColor = [UIColor whiteColor];
        _countLabe.font = [UIFont systemFontOfSize:9];
        _countLabe.textAlignment = NSTextAlignmentCenter;
        _countLabe.backgroundColor = [JCViewUtil colorWithHexString:@"282828" alpha:0.57];
        [self.contentView addSubview:_countLabe];
    }
    return _countLabe;
}

#pragma mark - method
- (void)fillData:(NSArray *)data {
    self.dataSource = data;
    [self.arrangeView fillData:data];
    if (self.canEdit) {
        self.countLabe.hidden = YES;
    }
    else {
        if ([data count] > self.arrangeView.imageViewArray.count) {
            self.countLabe.hidden = NO;
            self.countLabe.text = [NSString stringWithFormat:NSLocalizedString(@"plaza_album_count", nil),[data count]];
        }
        else {
            self.countLabe.hidden = YES;
        }
    }
}

- (void)setAlbumCount:(int)count {
    if (count > [self.dataSource count]) {
        self.countLabe.text = [NSString stringWithFormat:NSLocalizedString(@"plaza_album_count", nil),count];
    }
}

+ (CGFloat)getCellHeightWithHasTitle:(BOOL)hasTitle {
    if (!hasTitle) {
        return 26+kSuitableRectOutput.suitableWidth;
    }
    else {
        return 53+kSuitableRectOutput.suitableWidth;
    }
}

@end

@interface SLPhotoArrangeView ()<BrowseImageViewerDatasource>

@property (nonatomic, strong) NSArray *imageViewArray;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) CGFloat yGap;
@property (nonatomic, assign) SLSuitableRectOutput suitableOutRect;
@property (nonatomic, strong) UIImage *defaultEditImage;
@property (nonatomic, strong) UITapGestureRecognizer *tapGer;

@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * backUpDataSource;
@end

@implementation SLPhotoArrangeView

- (instancetype)initWithSuitableRectInput:(SLSuitableRectInput)input {
    self = [super init];
    if (self) {
        self.suitableRectInput = input;
        self.row = 1;
        self.yGap = 10;
        self.canEdit = NO;
        self.canShowBrowse = YES;
        self.backgroundColor = [UIColor clearColor];
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.suitableOutRect = [JCViewUtil suitableCountFitRect:self.suitableRectInput];
    CGFloat heigth = self.row * (self.suitableOutRect.suitableWidth + self.yGap) - self.yGap;
    self.bounds = CGRectMake(0, 0, self.suitableRectInput.totalWidth, heigth);
    
    [self.imageViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.suitableOutRect.count * self.row; i ++) {
        int y = i / self.suitableOutRect.count;
        int x = i % self.suitableOutRect.count;
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x * (self.suitableOutRect.suitableWidth+self.suitableRectInput.gap), y*(self.suitableOutRect.suitableWidth + self.yGap), self.suitableOutRect.suitableWidth, self.suitableOutRect.suitableWidth)];
        [tempImageView setBackgroundColor:[UIColor clearColor]];
        [array addObject:tempImageView];
        [self addSubview:tempImageView];
    }
    self.imageViewArray = array;
}

- (void)fillData:(NSArray *)data {
    self.dataSource = data;
    if (self.canSave) {
        [self fillPostImageData];
    }
    else {
        if (!self.canShowBrowse || !self.canEdit) {
            [self fillDataWhenUnEditable];
        }
        else {
            [self fillDataWhenEditable];
        }
    }
}

- (UIImage *)defaultEditImage {
    if (!_defaultEditImage) {
        _defaultEditImage = [UIImage imageNamed:@"bg_photo_add.png"];
    }
    return _defaultEditImage;
}

- (UITapGestureRecognizer *)tapGer {
    if (!_tapGer) {
        _tapGer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    }
    return _tapGer;
}

- (void)tapHandle:(id)sender {
    if (self.editBtnClickBlock) {
        self.editBtnClickBlock();
    }
}

- (void)fillDataWhenEditable {
    NSUInteger countImageView = self.imageViewArray.count;
    NSUInteger editIndex = [self.dataSource count] > countImageView-1 ?countImageView-1:[self.dataSource count];
    for (int i = 0; i < self.imageViewArray.count; i++) {
        UIImageView *tImageView = [self.imageViewArray objectAtIndex:i];
        [tImageView removeImageViewer];
        if (editIndex == i) {
            tImageView.hidden = NO;
            tImageView.image = [self defaultEditImage];
            tImageView.userInteractionEnabled = YES;
            [tImageView addGestureRecognizer:self.tapGer];
        }
        else if (i < editIndex) {
            tImageView.hidden = NO;
            NSString *urlStr = [JCViewHelper fixImageUrl:[self.dataSource objectAtIndex:i] withType:SLImageUrlType_center_160_160];
            [tImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"bg_photo_144.png"]];
            WEAKSELF
            [tImageView setupImageViewerWithDatasource:self initialIndex:i willAppear:^{
                weakSelf.backUpDataSource = [weakSelf.dataSource copy];
            } withStyle:BrowseImageViewerNone];
        }
        else {
            tImageView.hidden = YES;
        }
    }
}

- (void)fillDataWhenUnEditable {
    for (int i = 0; i < self.imageViewArray.count; i++) {
        UIImageView *tImageView = [self.imageViewArray objectAtIndex:i];
        [tImageView removeImageViewer];
        
        if (i < [self.dataSource count]) {
            NSString *urlStr = [JCViewHelper fixImageUrl:[self.dataSource objectAtIndex:i] withType:SLImageUrlType_center_160_160];
            [tImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"bg_photo_144.png"]];
            tImageView.hidden = NO;
            if (self.canShowBrowse) {
                if (i == [self.dataSource count] - 1 || i == self.imageViewArray.count - 1) {
                    tImageView.userInteractionEnabled = YES;
                    [tImageView addGestureRecognizer:self.tapGer];
                }
                else {
                    WEAKSELF
                    [tImageView setupImageViewerWithDatasource:self initialIndex:i willAppear:^{
                        weakSelf.backUpDataSource = [weakSelf.dataSource copy];
                    } withStyle:BrowseImageViewerNone];
                }
            }
        }
        else {
            tImageView.hidden = YES;
        }
    }
}

- (void)fillPostImageData {
    for (int i = 0; i < self.imageViewArray.count; i++) {
        UIImageView *tImageView = [self.imageViewArray objectAtIndex:i];
        [tImageView removeImageViewer];
        if (i < [self.dataSource count]) {
            [tImageView setImageWithURL:[NSURL URLWithString:[self.dataSource objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"bg_photo_144.png"]];
            tImageView.hidden = NO;
            if (self.canShowBrowse) {
                WEAKSELF
                [tImageView setupImageViewerWithDatasource:self initialIndex:i willAppear:^{
                    weakSelf.backUpDataSource = [weakSelf.dataSource copy];
                } withStyle:BrowseImageViewerSave];
            }
        }
        else {
            tImageView.hidden = YES;
        }
    }
}

#pragma mark - BrowseImageViewerDatasource
- (NSInteger)numberImagesForImageViewer:(SLBrowseImageViewer *)imageViewer {
    return [self.backUpDataSource count];
}

- (NSURL *)imageURLAtIndex:(NSInteger)index imageViewer:(SLBrowseImageViewer *)imageViewer {
    if (index < [self.backUpDataSource count]) {
        NSString *imgUrl = [self.backUpDataSource objectAtIndex:index];
        return [NSURL URLWithString:imgUrl];
    }
    return nil;
}

- (UIImage *)imageDefaultAtIndex:(NSInteger)index imageViewer:(SLBrowseImageViewer *)imageViewer {
    if (index >= [self.backUpDataSource count]) {
        return [UIImage imageNamed:@"bg_photo_200"];
    }
    NSString *imgUrl = [self.backUpDataSource objectAtIndex:index];
    NSString *smallImgUrl = [JCViewHelper fixImageUrl:imgUrl withType:SLImageUrlType_center_160_160];
    UIImage *image = [[SDImageCache sharedImageCache] queryFromDiskDirectly:smallImgUrl];
    if (image) {
        return image;
    }
    else
        return [UIImage imageNamed:@"bg_photo_200.png"];
}
@end
