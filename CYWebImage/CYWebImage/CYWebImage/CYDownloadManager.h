//
//  CYDownloadManager.h
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CYDownloadManager;
@protocol CYDownloadManagerDelegate <NSObject>
@optional

- (void)downloadManagerOperatioDidFinishedDownload:(CYDownloadManager*)downloadManager withImage:(UIImage*)image;

@end
@interface CYDownloadManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,weak) id<CYDownloadManagerDelegate>delegate;

- (void)downImageWitthURL:(NSString*)url completeBlock:(void(^)(UIImage *image))completeBlock;



@end
