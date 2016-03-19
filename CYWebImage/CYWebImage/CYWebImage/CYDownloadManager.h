//
//  CYDownloadManager.h
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CYWebImageOption) {
    CYWebImageOptionDefault = 0, // 默认
    CYWebImageOptionLowPriority = 1, // 低优先级
    CYWebImageOptionHighPriority = 2 , // 高优先级
    CYWebImageOptionCacheMemoryOnly = 3, // 缓存在内存中
};
/**
 *  下载图片进度的 block
 *
 *  @param receviedSize  接受到的图片内容大小
 *  @param totalSize     图片内容总大小
 */
typedef void(^CYDownloadProgressBlock)(float receviedSize,float totalSize);

@interface CYDownloadManager : NSObject


+ (_Nonnull instancetype)shareInstance;

/**
 *  根据 url 地址开始下载图片
 *
 *  @param url           图片 url 地址
 *  @param completeBlock 完成的回调
 */
- (void)downImageWitthURL:(NSURL *_Nullable)url  options:(CYWebImageOption)option progress:(nullable CYDownloadProgressBlock)progress completeBlock:(nullable void(^)(UIImage *_Nullable image))completeBlock;


@end
