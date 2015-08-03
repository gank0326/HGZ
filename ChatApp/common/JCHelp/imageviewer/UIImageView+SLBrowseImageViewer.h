//
//  UIImageView+SLBrowseImageViewer.h
//  Shanliao
//
//  Created by gsw on 14/12/2.
//  Copyright (c) 2014年 6rooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseImageViewerDatasource.h"

typedef void (^BrowseImageViewerOpeningBlock)(void);
typedef void (^BrowseImageViewerClosingBlock)(void);
typedef enum : NSUInteger {
    BrowseImageViewerNone = 0,
    BrowseImageViewerSave = 1,
    BrowseImageViewerSelect,
} BrowseImageViewerType;

#pragma mark - Custom Gesture Recognizer that will Handle imageURL
@interface BrowseImageViewerTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) BrowseImageViewerOpeningBlock openingBlock;
@property (nonatomic, strong) BrowseImageViewerClosingBlock closingBlock;
@property (nonatomic, weak) id <BrowseImageViewerDatasource> imageDatasource;
@property (nonatomic, assign) NSInteger initialIndex;
@property (nonatomic, strong) NSString *initialUrl;
@property (nonatomic) BrowseImageViewerType style;
@property (nonatomic, copy) void (^browseImageViewerWiillAppearBlock)(void);
@end

@interface UIImageView (SLBrowseImageViewer)
- (void)setupImageViewer;
- (void)setupImageViewerWithCompletionOnOpen:(BrowseImageViewerOpeningBlock)open onClose:(BrowseImageViewerClosingBlock)close;
- (void)setupImageViewerWithImageURL:(NSURL *)url;
- (void)setupImageViewerWithImageURL:(NSURL *)url onOpen:(BrowseImageViewerOpeningBlock)open onClose:(BrowseImageViewerClosingBlock)close;
- (void)setupImageViewerWithDatasource:(id <BrowseImageViewerDatasource> )imageDatasource onOpen:(BrowseImageViewerOpeningBlock)open onClose:(BrowseImageViewerClosingBlock)close;
- (void)setupImageViewerWithDatasource:(id <BrowseImageViewerDatasource> )imageDatasource initialIndex:(NSInteger)initialIndex onOpen:(BrowseImageViewerOpeningBlock)open onClose:(BrowseImageViewerClosingBlock)close;
- (void)setupImageViewerWithDatasource:(id <BrowseImageViewerDatasource> )imageDatasource initialUrl:(NSString *)initialUrl onOpen:(BrowseImageViewerOpeningBlock)open onClose:(BrowseImageViewerClosingBlock)close;
- (void)setupImageViewerWithDatasource:(id <BrowseImageViewerDatasource> )imageDatasource initialIndex:(NSInteger)initialIndex onOpen:(BrowseImageViewerOpeningBlock)open onClose:(BrowseImageViewerClosingBlock)close withStyle:(BrowseImageViewerType)style;
- (void)setupImageViewerWithDatasource:(id<BrowseImageViewerDatasource>)imageDatasource initialIndex:(NSInteger)initialIndex willAppear:(void (^)(void))block withStyle:(BrowseImageViewerType)style;
- (void)removeImageViewer;
@end
