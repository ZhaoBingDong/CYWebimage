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
