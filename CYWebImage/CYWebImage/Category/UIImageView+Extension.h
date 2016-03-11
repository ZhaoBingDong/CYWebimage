//
//  UIImageView+Extension.h
//  Junengwan
//
//  Created by 董招兵 on 16/3/7.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

/**
 *  设置一个圆角的图片
 *
 *  @param url         url
 *  @param placeHoder  默认占位图片
 */
- (void)setRoundImageWithURL:(NSURL *_Nonnull)url  placeHoder:(UIImage *_Nullable)placeHoder;

/**
 *  不需要默认的图片
 */
- (void)setRoundImageWithURL:(NSURL *_Nonnull)url;



@end
