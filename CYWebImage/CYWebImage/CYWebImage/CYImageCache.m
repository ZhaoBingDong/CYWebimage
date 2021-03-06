//
//  CYImageCache.m
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "CYImageCache.h"
#import "CYWebImageDefine.h"

@interface CYImageCache () <NSCacheDelegate>

@property (nonatomic,strong) NSCache *imageCache;


@end

@implementation CYImageCache

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static CYImageCache *_cyImageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cyImageCache = [super allocWithZone:zone];
        _cyImageCache.imageCache.countLimit = 30;
        _cyImageCache.imageCache.totalCostLimit = 100000;
        [[NSNotificationCenter defaultCenter] addObserver:_cyImageCache selector:@selector(cleanImageCacheMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    });
    return _cyImageCache;
}
+ (instancetype)shareInstance
{
    return [[super alloc] init];
}
- (NSCache *)imageCache
{
    if (!_imageCache) {
        _imageCache = [[NSCache alloc] init];
        _imageCache.delegate = self;
    }
    return _imageCache;
}
- (NSData*)cyImageCacheImageDiskForKey:(NSString*)key
{
    NSData *data = [NSData dataWithContentsOfFile:[self createImagePathWithURL:key]];
    return data;
}
- (NSData*)cyImageCacheImageMemoryForKey:(NSString*)key
{
    NSData *data = [self.imageCache objectForKey:[key md5]];
    return data;
}
- (void)saveImageCacheToMemoryWithData:(NSData*)data forKey:(NSString*)key
{
    if (!data) return;
    [self.imageCache setObject:data forKey:[key md5]];
}
- (void)saveImageCacheToDiskWithData:(NSData*)data forKey:(NSString*)key
{
    if (!data) return;
    [data writeToFile:[self createImagePathWithURL:key] atomically:YES];
}
/**
 *  清除磁盘中的缓存
 */
- (void)cleanImageCacheFromDisk
{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:[CYImageCache createImageCacheDiretory] error:nil];
}
/**
 *  清除内存中的缓存
 */
- (void)cleanImageCacheMemory
{
    [self.imageCache removeAllObjects];
}
- (NSString*)createImagePathWithURL:(NSString*)image_url
{
    NSString *cachePath = [CYImageCache createImageCacheDiretory];
    NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[image_url md5]]];
    return path;
}

+ (NSString*)createImageCacheDiretory
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [cachePath stringByAppendingPathComponent:@"cyImageCaches"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
/**
 *  清除缓存后的代理
 *
 *  @param cache 缓存管理者
 *  @param obj   被清除的缓存对象
 */
- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    //    NSLog(@"----%p",obj);
    
}

- (void)setMaxCacheCount:(NSInteger)maxCacheCount{
    _maxCacheCount = maxCacheCount;
    self.imageCache.countLimit = maxCacheCount;
}

- (void)setMaxCacheSize:(NSInteger)maxCacheSize{
    _maxCacheSize   = maxCacheSize;
    self.imageCache.totalCostLimit = _maxCacheSize;
    
}
@end
