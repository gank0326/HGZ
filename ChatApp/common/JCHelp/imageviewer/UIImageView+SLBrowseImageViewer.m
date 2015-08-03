//
//  UIImageView+SLBrowseImageViewer.m
//  Shanliao
//
//  Created by gsw on 14/12/2.
//  Copyright (c) 2014年 6rooms. All rights reserved.
//

#import "UIImageView+SLBrowseImageViewer.h"
#import "EventBus.h"
#import "SLBrowseImageViewer.h"

@implementation BrowseImageViewerTapGestureRecognizer

@end

@implementation UIImageView (SLBrowseImageViewer)

#pragma mark - Initializer for UIImageView
- (void)setupImageViewer {
	[self setupImageViewerWithCompletionOnOpen:nil onClose:nil];
}

- (void)setupImageViewerWithCompletionOnOpen:(BrowseImageViewerOpeningBlock)open onClose:(BrowseImageViewerClosingBlock)close {
	[self setupImageViewerWithImageURL:nil onOpen:open onClose:close];
}

- (void)setupImageViewerWithImageURL:(NSURL *)url {
	[self setupImageViewerWithImageURL:url onOpen:nil onClose:nil];
}

- (void)setupImageViewerWithImageURL:(NSURL *)url onOpen:(BrowseImageViewerOpeningBlock)open onClose:(BrowseImageViewerClosingBlock)close {
    [self removeImageViewer];
	self.userInteractionEnabled = YES;
	BrowseImageViewerTapGestureRecognizer *tapGesture = [[BrowseImageViewerTapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
	tapGesture.imageURL = url;
	tapGesture.openingBlock = open;
	tapGesture.closingBlock = close;
	[self addGestureRecognizer:tapGesture];
	tapGesture = nil;
}

- (void)setupImageViewerWithDatasource:(id <BrowseImageViewerDatasource> )imageDatasource onOpen:(BrowseImageViewerOpeningBlock)open onClose:(BrowseImageViewerClosingBlock)close {
	[self setupImageViewerWithDatasource:imageDatasource initialIndex:0 onOpen:open onClose:close];
}

- (void)setupImageViewerWithDatasource:(id <BrowseImageViewerDatasource> )imageDatasource initialIndex:(NSInteger)initialIndex onOpen:(BrowseImageViewerOpeningBlock)open onClose:(BrowseImageViewerClosingBlock)close {
    [self removeImageViewer];
	self.userInteractionEnabled = YES;
	BrowseImageViewerTapGestureRecognizer *tapGesture = [[BrowseImageViewerTapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
	tapGesture.imageDatasource = imageDatasource;
	tapGesture.openingBlock = open;
	tapGesture.closingBlock = close;
	tapGesture.initialIndex = initialIndex;
	[self addGestureRecognizer:tapGesture];
	tapGesture = nil;
}

- (void)setupImageViewerWithDatasource:(id <BrowseImageViewerDatasource> )imageDatasource initialIndex:(NSInteger)initialIndex onOpen:(BrowseImageViewerOpeningBlock)open onClose:(BrowseImageViewerClosingBlock)close withStyle:(BrowseImageViewerType)style {
    [self removeImageViewer];
    self.userInteractionEnabled = YES;
    BrowseImageViewerTapGestureRecognizer *tapGesture = [[BrowseImageViewerTapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGesture.imageDatasource = imageDatasource;
    tapGesture.openingBlock = open;
    tapGesture.closingBlock = close;
    tapGesture.initialIndex = initialIndex;
    tapGesture.style = style;
    [self addGestureRecognizer:tapGesture];
    tapGesture = nil;
}

- (void)setupImageViewerWithDatasource:(id<BrowseImageViewerDatasource>)imageDatasource initialIndex:(NSInteger)initialIndex willAppear:(void (^)(void))block withStyle:(BrowseImageViewerType)style {
    [self removeImageViewer];
    self.userInteractionEnabled = YES;
    BrowseImageViewerTapGestureRecognizer *tapGesture = [[BrowseImageViewerTapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGesture.imageDatasource = imageDatasource;
    tapGesture.browseImageViewerWiillAppearBlock = block;
    tapGesture.initialIndex = initialIndex;
    tapGesture.style = style;
    [self addGestureRecognizer:tapGesture];
}

- (void)setupImageViewerWithDatasource:(id <BrowseImageViewerDatasource> )imageDatasource initialUrl:(NSString *)initialUrl onOpen:(BrowseImageViewerOpeningBlock)open onClose:(BrowseImageViewerClosingBlock)close {
    [self removeImageViewer];
	self.userInteractionEnabled = YES;
	BrowseImageViewerTapGestureRecognizer *tapGesture = [[BrowseImageViewerTapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
	tapGesture.imageDatasource = imageDatasource;
	tapGesture.openingBlock = open;
	tapGesture.closingBlock = close;
	tapGesture.initialUrl = initialUrl;
	[self addGestureRecognizer:tapGesture];
	tapGesture = nil;
}

#pragma mark - Handle Tap
- (void)didTap:(BrowseImageViewerTapGestureRecognizer *)gestureRecognizer {
	[[EventBus shared] emit:@selector(hideKeyBoard) withArguments:@[]];
    if (gestureRecognizer.browseImageViewerWiillAppearBlock) {
        gestureRecognizer.browseImageViewerWiillAppearBlock();
    }
	SLBrowseImageViewer *imageBrowser = [[SLBrowseImageViewer alloc]init];
	imageBrowser.senderView = self;
	imageBrowser.imageURL = gestureRecognizer.imageURL;
	imageBrowser.openingBlock = gestureRecognizer.openingBlock;
	imageBrowser.closingBlock = gestureRecognizer.closingBlock;
	imageBrowser.imageDatasource = gestureRecognizer.imageDatasource;
	imageBrowser.initialIndex = gestureRecognizer.initialIndex;
	imageBrowser.initialUrl = gestureRecognizer.initialUrl;
    imageBrowser.style = gestureRecognizer.style;
	if (self.image)
		[imageBrowser presentFromRootViewController];
}

#pragma mark Removal
- (void)removeImageViewer {
	for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
		if ([gesture isKindOfClass:[BrowseImageViewerTapGestureRecognizer class]]) {
			[self removeGestureRecognizer:gesture];

			BrowseImageViewerTapGestureRecognizer *tapGesture = (BrowseImageViewerTapGestureRecognizer *)gesture;
			tapGesture.imageURL = nil;
			tapGesture.openingBlock = nil;
			tapGesture.closingBlock = nil;
		}
	}
}

@end
