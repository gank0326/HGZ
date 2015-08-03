//
//  BrowseImageViewerDatasource.h
//  Shanliao
//
//  Created by gsw on 14/12/2.
//  Copyright (c) 2014年 6rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SLBrowseImageViewer;
@protocol BrowseImageViewerDatasource <NSObject>
@required
- (NSInteger)numberImagesForImageViewer:(SLBrowseImageViewer *)imageViewer;
- (NSURL *)imageURLAtIndex:(NSInteger)index imageViewer:(SLBrowseImageViewer *)imageViewer;
- (UIImage *)imageDefaultAtIndex:(NSInteger)index imageViewer:(SLBrowseImageViewer *)imageViewer;

@optional
- (NSInteger)initialIndexForImageViewer:(NSString *)initialUrl;
- (NSString *)originalImageUrlAtIndex:(NSUInteger)index;
- (long long)originalImageSizeAtIndex:(NSUInteger)index;
@end
