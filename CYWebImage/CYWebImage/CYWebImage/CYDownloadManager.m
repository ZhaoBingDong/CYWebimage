//
//  CYDownloadManager.m
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "CYDownloadManager.h"
#import "CYDownloadOperation.h"
#import "CYOperationQueue.h"
#import "CYImageCache.h"

@interface CYDownloadManager   ()<CYDownloadOperationDelegate>
@property (nonatomic,strong) CYOperationQueue *queue;
@property (nonatomic,strong) NSMutableDictionary *opeartionQueues;
@property (nonatomic,strong) NSMutableDictionary *blocks;

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
        _queue = [[CYOperationQueue alloc] init];
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

- (NSMutableDictionary *)blocks
{
    if (!_blocks) {
        _blocks = [NSMutableDictionary dictionary];
    }
    return _blocks;
}

- (void)downImageWitthURL:(NSString*)url completeBlock:(void(^)(UIImage *image))completeBlock
{
    // 先读内存 再读本地 如果本地和内存都没有再从网络下载图片
    NSData *data = [CYImageCache cyImageCacheImageMemoryForKey:url];
    if (data) {
        completeBlock([UIImage imageWithData:data]);
    }else if ([CYImageCache cyImageCacheImageDiskForKey:url]){
        data = [CYImageCache cyImageCacheImageDiskForKey:url];
        [CYImageCache saveImageCacheToMemoryWithData:data ForKey:url];
        completeBlock([UIImage imageWithData:data]);
    }else{
        if (!completeBlock||!url) return;
        NSDictionary *dict = @{
                               @"url" : url,
                               @"block" : completeBlock
                               };
        [self performSelector:@selector(downLoadWithParams:) withObject:dict afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
        [self performSelector:@selector(suspended:) withObject:@(NO) afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
        [self performSelector:@selector(suspended:) withObject:@(YES) afterDelay:0 inModes:@[UITrackingRunLoopMode]];
    }
    

}

- (void)downLoadWithParams:(id)params {
    NSString *url = params[@"url"];
    void (^completeBlock) (UIImage *image) = params[@"block"];
    CYDownloadOperation *oldOpeartion = self.opeartionQueues[url];
    if (oldOpeartion) return;
    CYDownloadOperation *opeartion = [[CYDownloadOperation alloc] init];
    opeartion.image_url         = url;
    opeartion.delegate          = (id<CYDownloadOperationDelegate>)self;
    [self.queue addOperation:opeartion];
    [self.opeartionQueues setObject:opeartion forKey:url];
    [self.blocks setObject:completeBlock forKey:url];
}

- (void)downloadOperatioDidFinishedDownload:(CYDownloadOperation *)operation withImage:(UIImage *)image
{
    if (!image) return;
    [self.opeartionQueues removeObjectForKey:operation.image_url];
   __block NSData *data = UIImageJPEGRepresentation(image,0.5);
    void (^complete)(UIImage *image) = self.blocks[operation.image_url];
    if (complete) {
        complete([UIImage imageWithData:data]);
    }
    [self.blocks removeObjectForKey:operation.image_url];
    [CYImageCache saveImageCacheToDiskWithData:data ForKey:operation.image_url];
    [CYImageCache saveImageCacheToMemoryWithData:data ForKey:operation.image_url];
    
    NSLog(@"---->\n %@",self.opeartionQueues);
    
    
}

@end
