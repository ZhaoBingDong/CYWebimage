//
//  UIButton+Extension.m
//  Junengwan
//
//  Created by 董招兵 on 16/3/7.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "UIButton+Extension.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImage+ImageCut.h"

typedef NS_ENUM(NSInteger,CYButtonImageType) {
    CYButtonImageTypeImage,
    CYButtonImageTypeBackgroundImage
};

@implementation UIButton (Extension)

/**
 *  设置按钮的backgroundImage 带占位图片
 */
- (void)setBackRoundImage:(NSURL*_Nonnull)url  forState:(UIControlState)state placeHoder:(UIImage *_Nullable)placeHoder
{
    [self downImageWithURL:url forState:state placeHoder:placeHoder setImageType:CYButtonImageTypeBackgroundImage];
}
/**
 *  设置按钮的backgroundImage 不带占位图片
 */
- (void)setBackRoundImage:(NSURL*_Nonnull)url forState:(UIControlState)state
{
    [self setBackRoundImage:url forState:state placeHoder:nil];
}
/**
 *  设置一个圆角的图片
 *
 *  @param url         url
 *  @param placeHoder  默认占位图片
 */
- (void)setRoundImageWithURL:(NSURL*_Nonnull)url forState:(UIControlState)state
{
    [self setRoundImageWithURL:url forState:state placeHoder:nil];
}

/**
 *  同时设置圆角半径和占位图
 */
- (void)setRoundImageWithURL:(NSURL *_Nonnull)url  forState:(UIControlState)state placeHoder:(UIImage *_Nullable)placeHoder
{
    [self downImageWithURL:url forState:state placeHoder:placeHoder setImageType:CYButtonImageTypeImage];
}

- (void)downImageWithURL:(NSURL *_Nonnull)url forState:(UIControlState)state placeHoder:(UIImage *_Nullable)placeHoder setImageType:(CYButtonImageType)type
{
    NSString *urlStirng = [url absoluteString];
    NSString *imagenName = [NSString stringWithFormat:@"%@%@",urlStirng,@"roundImage"];
    __block NSString *path = [self base64String:imagenName];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:path];
    if (image) {
        [self setImage:image imageType:type state:state];
        return;
    }else if (placeHoder) {
        [self setImage:placeHoder imageType:type state:state];
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
                    NSDictionary *params = @{@"image":cirleImage,@"imageType":@(type),@"state":@(state)};
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [stongSelf performSelector:@selector(reloadData:) withObject:params afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
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

- (void)reloadData:(NSDictionary*)params {
    
    UIImage *image = params[@"image"];
    UIControlState state = [params[@"state"] integerValue];
    CYButtonImageType imageType = [params[@"imageType"] integerValue];
    [self setImage:image imageType:imageType state:state];
}

- (void)setImage:(UIImage*)image imageType:(CYButtonImageType)imageType state:(UIControlState)state
{
    if (imageType == CYButtonImageTypeImage) {
        [self setImage:image forState:state];
    }else{
        [self setBackgroundImage:image forState:state];
    }
}

@end
