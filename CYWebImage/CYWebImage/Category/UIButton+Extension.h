//
//  UIButton+Extension.h
//  Junengwan
//
//  Created by 董招兵 on 16/3/7.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
/**
 *  设置按钮的backgroundImage 带占位图片
 */
- (void)setBackRoundImage:(NSURL*_Nonnull)url  forState:(UIControlState)state placeHoder:(UIImage *_Nullable)placeHoder;
/**
 *  设置按钮的backgroundImage 不带占位图片
 */
- (void)setBackRoundImage:(NSURL*_Nonnull)url forState:(UIControlState)state;

/**
 *  设置 button 的 image 不带占位图
 */
- (void)setRoundImageWithURL:(NSURL*_Nonnull)url forState:(UIControlState)state;
/**
 *  设置 button 的 image 带占位图
 */
- (void)setRoundImageWithURL:(NSURL *_Nonnull)url  forState:(UIControlState)state placeHoder:(UIImage *_Nullable)placeHoder;


@end
