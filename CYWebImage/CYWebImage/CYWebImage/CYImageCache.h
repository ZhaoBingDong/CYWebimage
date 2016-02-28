//
//  CYImageCache.h
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYImageCache : NSObject

+ (NSData*)cyImageCacheImageDiskForKey:(NSString*)key;
+ (NSData*)cyImageCacheImageMemoryForKey:(NSString*)key;
+ (void)saveImageCacheToMemoryWithData:(NSData*)data ForKey:(NSString*)key;
+ (void)saveImageCacheToDiskWithData:(NSData*)data ForKey:(NSString*)key;
- (void)cleanImageChcheFromDisk;
- (void)cleanImageChcheMemory;
@end
