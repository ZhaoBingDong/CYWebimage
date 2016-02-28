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
   __block NSData *data = UIImageJPEGRepresentation(image,1);
    void (^complete)(UIImage *image) = self.blocks[operation.image_url];
    if (complete) {
        complete([UIImage imageWithData:data]);
    }
    [self.blocks removeObjectForKey:operation.image_url];
    [CYImageCache saveImageCacheToDiskWithData:data ForKey:operation.image_url];
    [CYImageCache saveImageCacheToMemoryWithData:data ForKey:operation.image_url];
}

@end
