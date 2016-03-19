//
//  CYDownloadOperation.h
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYDownloadManager.h"

#import <UIKit/UIKit.h>
@class CYDownloadOperation;

@protocol CYDownloadOperationDelegate <NSObject>

@optional
/**
 *  下载完成返回图片
 *
 *  @param operation 任务
 *  @param image     下载好的图片
 */
- (void)downloadOperatioDidFinishedDownload:(CYDownloadOperation* _Nullable)operation withImage:(UIImage *_Nullable)image;

@end

@interface CYDownloadOperation : NSOperation

@property (nonatomic,copy,nullable) NSURL *image_url;

@property (nonatomic,weak,nullable) id<CYDownloadOperationDelegate>delegate;

@property (nonatomic, strong,nullable) NSIndexPath *indexPath;

@property (nonatomic,assign) CYWebImageOption options;

/** < porgressBlock > */
@property (nonatomic,copy,nullable) void (^progressBlock)(float receivedSize,float totalSize);
/**
 *  下载完成的 block
 */
@property (nonatomic,copy,nullable) void (^downloadCompleteBlock) (UIImage *_Nullable image);

@end
