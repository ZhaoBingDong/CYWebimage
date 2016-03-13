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
    static CYImageCache *_imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageCache = [super allocWithZone:zone];
        [[NSNotificationCenter defaultCenter] addObserver:_imageCache selector:@selector(cleanImageCacheMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    });
    return _imageCache;
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
- (void)saveImageCacheToMemoryWithData:(NSData*)data ForKey:(NSString*)key
{
    if (!data) return;
    [self.imageCache setObject:data forKey:[key md5]];
}
- (void)saveImageCacheToDiskWithData:(NSData*)data ForKey:(NSString*)key
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
    
}
@end
