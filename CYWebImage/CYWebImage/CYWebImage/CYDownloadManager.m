//
//  CYDownloadManager.m
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "CYDownloadManager.h"
#import "CYDownloadOperation.h"
#import "CYImageCache.h"

@interface CYDownloadManager   ()<CYDownloadOperationDelegate>

@property (nonatomic,strong) NSOperationQueue *queue;

@property (nonatomic,strong) NSMutableDictionary <NSString *,CYDownloadOperation *>*opeartionQueues;

@end

@implementation CYDownloadManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static CYDownloadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}
/**
 *  监听滚动事件如果发现 scrollView 开始滚动就暂停下载任务
 *
 *  @param isSuspended 是否暂停
 */
- (void)suspended:(NSNumber*)isSuspended{
    BOOL suspended = [isSuspended boolValue];
    [self.queue setSuspended:suspended];
}

+ (instancetype)shareInstance
{
    return [[super alloc] init];
}
- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}
- (NSMutableDictionary *)opeartionQueues
{
    if (!_opeartionQueues) {
        _opeartionQueues = [NSMutableDictionary dictionary];
    }
    return _opeartionQueues;
}

/**
 *  根据 url 地址开始下载图片
 *
 *  @param url           图片 url 地址
 *  @param completeBlock 完成的回调
 */
- (void)downImageWitthURL:(NSURL *_Nullable)url  options:(CYWebImageOption)option progress:(nullable CYDownloadProgressBlock)progress completeBlock:(nullable void(^)(UIImage *_Nullable image))completeBlock
{
    // 先读内存 再读本地 如果本地和内存都没有再从网络下载图片
   __block NSData *data = [[CYImageCache shareInstance] cyImageCacheImageMemoryForKey:url.absoluteString];
    if (data) {
        completeBlock([UIImage imageWithData:data]);
        progress(1,1);
    }else if ([[CYImageCache shareInstance] cyImageCacheImageDiskForKey:url.absoluteString]){
        data = [[CYImageCache shareInstance] cyImageCacheImageDiskForKey:url.absoluteString];
        completeBlock([UIImage imageWithData:data]);
        progress(1,1);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[CYImageCache shareInstance] saveImageCacheToMemoryWithData:data forKey:url.absoluteString];
        });
    } else {
        if (!completeBlock||!url) return;
        NSDictionary *dict = @{
                               @"url" : url,
                               @"block" : completeBlock ,
                               @"progress" : progress ,
                               @"option" : @(option)
                               };
        if (option != CYWebImageOptionHighPriority) {
            [self performSelector:@selector(downLoadWithParams:) withObject:dict afterDelay:0 inModes:@[NSRunLoopCommonModes]];
            [self performSelector:@selector(suspended:) withObject:@(NO) afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
            [self performSelector:@selector(suspended:) withObject:@(YES) afterDelay:0 inModes:@[UITrackingRunLoopMode]];
        }else{
            [self downLoadWithParams:dict];
        }
    }
}
- (void)downLoadWithParams:(id)params {
    
    NSURL *url = params[@"url"];
   __block void (^completeBlock) (UIImage *image) = params[@"block"];
    void (^progressBlock) (float receivedSize , float totalSize) = params[@"progress"];
    CYDownloadOperation *oldOpeartion = self.opeartionQueues[url.absoluteString];
    if (oldOpeartion) return;
    CYDownloadOperation *opeartion = [[CYDownloadOperation alloc] init];
    opeartion.image_url         = url;
    opeartion.delegate          = (id<CYDownloadOperationDelegate>)self;
    opeartion.progressBlock     = progressBlock;
    opeartion.options           = [params[@"option"] integerValue];
    opeartion.downloadCompleteBlock = completeBlock;
    [self.queue addOperation:opeartion];
    [self.opeartionQueues setObject:opeartion forKey:url];

}
/**
 *  单个下载图片的任务完成后在这里对图片进行缓存,并回调给出去
 *
 *  @param operation 下载任务
 *  @param image     图片
 */
- (void)downloadOperatioDidFinishedDownload:(CYDownloadOperation *)operation withImage:(UIImage *)image
{
    if (!image) return;
    
    __block NSData *data = UIImageJPEGRepresentation(image,1);
    if (operation.downloadCompleteBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            operation.downloadCompleteBlock([UIImage imageWithData:data]);
        });
    }
    // 保存下图片
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[CYImageCache shareInstance] saveImageCacheToMemoryWithData:data forKey:operation.image_url.absoluteString];
        if (operation.options != CYWebImageOptionCacheMemoryOnly) {
            [[CYImageCache shareInstance] saveImageCacheToDiskWithData:data forKey:operation.image_url.absoluteString];
        }
        [self.opeartionQueues removeObjectForKey:operation.image_url.absoluteString];
    });
}


@end
