//
//  UIImageView+Extension.m
//  Junengwan
//
//  Created by 董招兵 on 16/3/7.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImage+ImageCut.h"

@implementation UIImageView (Extension)

/**
 *  设置一个圆角的图片
 *
 *  @param url         url
 *  @param placeHoder  默认占位图片
 */
- (void)setRoundImageWithURL:(NSURL*_Nonnull)url  placeHoder:(UIImage*_Nullable)placeHoder
{
    [self setRoundImageWithURL:url placeHoder:placeHoder cornerRadius:0];
}

/**
 *  不需要默认的图片
 */
- (void)setRoundImageWithURL:(NSURL *_Nonnull)url
{
    [self setRoundImageWithURL:url placeHoder:nil cornerRadius:0];
}

/**
 *  同时设置圆角半径和占位图
 */
- (void)setRoundImageWithURL:(NSURL *_Nonnull)url placeHoder:(UIImage *_Nullable)placeHoder cornerRadius:(CGFloat)radius
{
    NSString *urlStirng = [url absoluteString];
    NSString *imagenName = [NSString stringWithFormat:@"%@%@",urlStirng,@"roundImage"];
    __block NSString *path = [self base64String:imagenName];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:path];
    if (image) {
        [self setImage:image];
        return;
    }else if (placeHoder) {
        [self setImage:placeHoder];
    }
    __weak typeof(self)weakSelf = self;
    if (url) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed|SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            __strong typeof(weakSelf)stongSelf = weakSelf;
            if (!finished) return;
            if (!image) return;
            @synchronized(self) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    UIImage *cirleImage =  [image cirleImage];
                    [[SDImageCache sharedImageCache]storeImage:cirleImage forKey:path];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [stongSelf performSelector:@selector(reloadData:) withObject:cirleImage afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
                    });
                });
            }
        }];
    }
}

- (NSString*)base64String:(NSString*)str{
    NSData* originData = [str dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return [NSString stringWithFormat:@"%@.png",encodeResult];
}

- (void)reloadData:(UIImage*)image {
    
    [self setImage:image];
}

@end
