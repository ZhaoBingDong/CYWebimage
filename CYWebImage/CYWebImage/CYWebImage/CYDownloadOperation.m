//
//  CYDownloadOperation.m
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "CYDownloadOperation.h"

@interface CYDownloadOperation ()<NSURLSessionDownloadDelegate>

@property (nonatomic,strong) NSURLSession *session;

@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;

@end

@implementation CYDownloadOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self performSelector:@selector(pause) withObject:nil afterDelay:0 inModes:@[UITrackingRunLoopMode]];
        [self performSelector:@selector(resume) withObject:nil afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
    }
    return self;
}
- (void)main
{
    @autoreleasepool {
        [self startDownloadImage];
    }
}

- (void)pause
{
    [self.downloadTask suspend];
}

- (void)resume{
    [self.downloadTask resume];
}

/**
 *  开始下载图片
 */
- (void)startDownloadImage
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.image_url];
    self.session  = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    self.downloadTask = [self.session downloadTaskWithRequest:request];
    [self.downloadTask resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    UIImage *image = [UIImage imageWithData:data];
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(downloadOperatioDidFinishedDownload:withImage:)]) {
            [weakSelf.delegate downloadOperatioDidFinishedDownload:self withImage:image];
        }
    });
    [self.session invalidateAndCancel];
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (self.progressBlock) {
        self.progressBlock((float)totalBytesWritten,(float)totalBytesExpectedToWrite);
    }
}
- (void)dealloc
{
    self.downloadTask = nil;
    self.session = nil;
}
@end
