//
//  UIImage+ImageCut.h
//  Junengwan
//
//  Created by dabing on 15/12/5.
//  Copyright © 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIImage (ImageCut)

//截取部分图像
-(UIImage*)getSubImage:(CGSize)size;

+ (CGSize)getScaleImageFromSize:(CGSize)fromSize width:(CGFloat)fromW;
/// 对图片尺寸进行压缩
-(UIImage*)scaledToSize:(CGSize)newSize;
/**
 *  获取内存中已经缓存的图片 并根据限制的宽度 进行等比例缩放
 */
+ (CGSize)getCacheImageForkey:(NSString*)imageUrl andRestrict:(CGFloat)width;
/**
 *  将图片裁剪成圆形图片
 *
 */
- (UIImage*)cirleImage;
@end
NS_ASSUME_NONNULL_END