//
//  CYImageCache.h
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYImageCache : NSObject

+ (instancetype)shareInstance;
/**
 *  获取磁盘中的缓存
 *
 *  @param key  key
 *
 *  @return  返回一个 NSData 对象
 */
- (NSData*)cyImageCacheImageDiskForKey:(NSString*)key;
/**
 *  获取内存中的缓存
 *
 *  @param key  key
 *
 *  @return  返回一个 NSData 对象
 */
- (NSData*)cyImageCacheImageMemoryForKey:(NSString*)key;
/**
 *  图片 url 作为 key 将图片保存到内存中
 *
 *  @param data 图片
 *  @param key  图片 url
 */
- (void)saveImageCacheToMemoryWithData:(NSData*)data forKey:(NSString*)key;
/**
 *  图片 url 作为 key 将图片保存到硬盘中
 *
 *  @param data 图片
 *  @param key  图片 url
 */
- (void)saveImageCacheToDiskWithData:(NSData*)data forKey:(NSString*)key;

/**
 *  清除磁盘中的缓存
 */
- (void)cleanImageCacheFromDisk;
/**
 *  清除内存中的缓存
 */
- (void)cleanImageCacheMemory;
/**
 *  缓存图片的个数
 */
@property (nonatomic,assign) NSInteger maxCacheCount;
/**
 *  缓存图片的最大尺寸
 */
@property (nonatomic,assign) NSInteger maxCacheSize;



@end
