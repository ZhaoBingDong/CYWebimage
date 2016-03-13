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
- (void)downloadOperatioDidFinishedDownload:(CYDownloadOperation*)operation withImage:(UIImage*)image;

@end

@interface CYDownloadOperation : NSOperation
@property (nonatomic,copy) NSURL *image_url;
@property (nonatomic,weak) id<CYDownloadOperationDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic,assign) CYWebImageOption options;

/** < porgressBlock > */
@property (nonatomic,copy) void (^progressBlock)(float receivedSize,float totalSize);

@end
