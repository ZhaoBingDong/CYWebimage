//
//  UIImageView+CYImageViewCache.h
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYDownloadManager.h"

@interface UIImageView (CYImageViewCache)

/**
 *  根据一个 url 获取图片
 *
 *  @param url url
 */
- (void)cyImageWithURL:(NSURL *_Nullable)url;
/**
 *  根据一个 url 获取图片
 *
 *  @param url          url
 *  @param placeHolder  占位图片
 */
- (void)cyImageWithURL:(NSURL *_Nullable)url placeHolder:(UIImage* _Nullable)placeHolder;
/**
 *  根据一个 url 获取图片
 *
 *  @param url          url
 *  @param placeHolder  占位图片
 *  @param complete    回调事件
 */
- (void)cyImageWithURL:(NSURL *_Nullable)url
            placeHolder:(UIImage* _Nullable)placeHolder
          completeBlock:(nullable void (^)(UIImage *_Nullable image))complete;

/**
 *   根据一个 url 来获取图片
 *
 *  @param url          url
 *  @param option       任务类型 比如失败重试 低优先级 高优先级
 *  @param placeHolder 占位图片
 *  @param complete    完成后的回调
 */
- (void)cyImageWithURL:(NSURL *_Nullable)url
                 option:(NSInteger)option
            placeHolder:(UIImage *_Nullable)placeHolder
          completeBlock:(nullable void (^)(UIImage * _Nullable image))complete;

/**
 *  根据一个 url 来获取图片 带进度
 *
 *  @param url          url
 *  @param option      option
 *  @param placeHolder  占位图片
 *  @param progress    进度条
 *  @param complete    完成后的回调
 */
- (void)cyImageWithURL:(NSURL *_Nullable)url
                 option:(NSInteger)option
            placeHolder:(UIImage *_Nullable)placeHolder
               progress:(nullable CYDownloadProgressBlock)progress
          completeBlock:(nullable void (^)(UIImage * _Nullable image))complete;

@end
