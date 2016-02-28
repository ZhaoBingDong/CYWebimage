//
//  CYImageCache.m
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "CYImageCache.h"
#import "CYWebImageDefine.h"

@interface CYImageCache ()
@property (nonatomic,strong) NSMutableDictionary *imageCaches;

@end

@implementation CYImageCache

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static CYImageCache *_imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageCache = [super allocWithZone:zone];
        [[NSNotificationCenter defaultCenter] addObserver:_imageCache selector:@selector(cleanImageChcheMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    });
    return _imageCache;
}

+ (instancetype)shareInstance
{
    return [[super alloc] init];
}

- (NSMutableDictionary *)imageCaches
{
    if (!_imageCaches) {
        _imageCaches = [NSMutableDictionary dictionary];
    }
    return _imageCaches;
}

+ (NSData*)cyImageCacheImageDiskForKey:(NSString*)key
{
    NSData *data = [NSData dataWithContentsOfFile:[[self shareInstance] createImagePathWithURL:key]];
    return data;
}
+ (NSData*)cyImageCacheImageMemoryForKey:(NSString*)key
{
    NSData *data = [[self shareInstance] imageCaches][[key md5]];
    return data;
}
+ (void)saveImageCacheToMemoryWithData:(NSData*)data ForKey:(NSString*)key
{
    if (!data) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self shareInstance] imageCaches][[key md5]] = data;
    });
}
+ (void)saveImageCacheToDiskWithData:(NSData*)data ForKey:(NSString*)key
{
    if (!data) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data writeToFile:[[self shareInstance] createImagePathWithURL:key] atomically:YES];
    });
}
- (void)cleanImageChcheFromDisk
{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:[CYImageCache createImageCacheDiretory] error:nil];
}
- (void)cleanImageChcheMemory
{
    [self.imageCaches removeAllObjects];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:[CYImageCache createImageCacheDiretory] error:nil];
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
@end
