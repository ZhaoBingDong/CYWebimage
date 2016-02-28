//
//  CYDownloadOperation.h
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CYDownloadOperation;
@protocol CYDownloadOperationDelegate <NSObject>
@optional

- (void)downloadOperatioDidFinishedDownload:(CYDownloadOperation*)operation withImage:(UIImage*)image;

@end

@interface CYDownloadOperation : NSOperation
@property (nonatomic,copy) NSString *image_url;
@property (nonatomic,weak) id<CYDownloadOperationDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;
@end
