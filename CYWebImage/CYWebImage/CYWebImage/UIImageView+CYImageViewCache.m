//
//  UIImageView+CYImageViewCache.m
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "UIImageView+CYImageViewCache.h"
#import "CYDownloadOperation.h"
#import "CYDownloadManager.h"
#import "CYImageCache.h"

@implementation UIImageView (CYImageViewCache)
/**
 *  根据一个 url 获取图片
 *
 *  @param url url
 */
- (void)cyImageWithURL:(NSURL *_Nullable)url {
    [self cyImageWithURL:url option:0 placeHolder:nil completeBlock:nil];
}
/**
 *  根据一个 url 获取图片
 *
 *  @param url          url
 *  @param placeHolder  占位图片
 */
- (void)cyImageWithURL:(NSURL *_Nullable)url placeHolder:(UIImage* _Nullable)placeHolder
{
    [self cyImageWithURL:url option:0 placeHolder:placeHolder completeBlock:nil];
}
/**
 *  根据一个 url 获取图片
 *
 *  @param url          url
 *  @param placeHolder  占位图片
 *  @param complete    回调事件
 */
- (void)cyImageWithURL:(NSURL *_Nullable)url placeHolder:(UIImage* _Nullable)placeHolder completeBlock:(nullable void (^)(UIImage *_Nullable image))complete
{
    [self cyImageWithURL:url option:0 placeHolder:placeHolder completeBlock:complete];
}
/**
 *   根据一个 url 来获取图片
 *
 *  @param url          url
 *  @param option       任务类型 比如失败重试 低优先级 高优先级
 *  @param placeHolder 占位图片
 *  @param complete    完成后的回调
 */
- (void)cyImageWithURL:(NSURL *_Nullable)url  option:(NSInteger)option placeHolder:(UIImage *_Nullable)placeHolder completeBlock:(nullable void (^)(UIImage * _Nullable image))complete{
    [self cyImageWithURL:url option:option placeHolder:placeHolder progress:nil completeBlock:complete];
}

/**
 *  缓存图片带进度
 *
 *  @param url          url
 *  @param option      option
 *  @param placeHolder  占位图片
 *  @param progress    进度条
 *  @param complete    完成后的回调
 */
- (void)cyImageWithURL:(NSURL *_Nullable)url  option:(NSInteger)option placeHolder:(UIImage *_Nullable)placeHolder progress:(nullable CYDownloadProgressBlock)progress completeBlock:(nullable void (^)(UIImage * _Nullable image))complete {
    if (placeHolder) {
        self.image = placeHolder;
    }
    __weak typeof(self)weakSelf = self;
    
    [[CYDownloadManager shareInstance]downImageWitthURL:url options:option progress:^(float receviedSize, float totalSize) {
        if (progress) {
            progress(receviedSize,totalSize);
        }
    } completeBlock:^(UIImage * _Nullable image) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.image = image;
        if (complete) {
            complete(image);
        }
    }];

}
@end
