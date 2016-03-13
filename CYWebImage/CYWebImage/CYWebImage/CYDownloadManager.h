//
//  CYDownloadManager.h
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CYDownloadManager : NSObject

+ (instancetype)shareInstance;

/**
 *  根据 url 地址开始下载图片
 *
 *  @param url           图片 url 地址
 *  @param completeBlock 完成的回调
 */
- (void)downImageWitthURL:(NSString*)url completeBlock:(void(^)(UIImage *image))completeBlock;


@end
