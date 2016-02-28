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

- (void)setImageWithURL:(NSString*)url placeHolder:(UIImage*)placeHolder
{
    if (placeHolder) {
        self.image = placeHolder;
    }
    __weak typeof(self)weakSelf = self;
    NSData *data = [CYImageCache cyImageCacheImageMemoryForKey:url];
    if (!data) {
        data = [CYImageCache cyImageCacheImageDiskForKey:url];
        if (!data) {
            [[CYDownloadManager shareInstance] downImageWitthURL:url completeBlock:^(UIImage *image) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.image = image;
            }];
        }else
        {
            [CYImageCache saveImageCacheToMemoryWithData:data ForKey:url];
            [self setImageWithData:data];
        }
    }else
    {
        [self setImageWithData:data];
    }
}

- (void)setImageWithData:(NSData*)data
{
    UIImage *image = [UIImage imageWithData:data];
    self.image = image;
}



@end
