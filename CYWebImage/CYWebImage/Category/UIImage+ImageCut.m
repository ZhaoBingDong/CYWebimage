//
//  UIImage+ImageCut.m
//  Junengwan
//
//  Created by dabing on 15/12/5.
//  Copyright © 2015年 大兵布莱恩特. All rights reserved.
//

#import "UIImage+ImageCut.h"
#import "SDImageCache.h"
@implementation UIImage (ImageCut)
//截取部分图像
-(UIImage*)getSubImage:(CGSize)size
{
    CGRect rect = CGRectMake(self.size.width*(1-size.width), self.size.height*(1-size.height), self.size.width*size.width, self.size.height*size.height);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}

+ (CGSize)getScaleImageFromSize:(CGSize)fromSize width:(CGFloat)fromW
{
    CGFloat width = fromSize.width;
    CGFloat height = fromSize.height;
    CGFloat scale = height/width;
    height = fromW *scale;
    NSString *str = [NSString stringWithFormat:@"%f",height];
    if (str.integerValue ==0) {
        height = 0;
    }
    return CGSizeMake(fromW, height);
}
//对图片尺寸进行压缩--
-(UIImage*)scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

/**
 *  获取内存中已经缓存的图片 并根据限制的宽度 进行等比例缩放
 */
+ (CGSize)getCacheImageForkey:(NSString*)imageUrl andRestrict:(CGFloat)width
{
    UIImage *coverImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    return [UIImage getScaleImageFromSize:coverImage.size width:width];
}
/**
 *  将图片裁剪成圆形图片
 *
 *  @param image  传入的 iamge
 *  @param radius  圆角半径
 *
 */
- (UIImage*)cirleImage{
    
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *cirleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    
    
    return cirleImage;

}




@end
