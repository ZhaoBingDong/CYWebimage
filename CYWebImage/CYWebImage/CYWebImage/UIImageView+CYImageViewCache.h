//
//  UIImageView+CYImageViewCache.h
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CYImageViewCache)

/** <根据 url 来加载一个网络图片> */
- (void)setImageWithURL:(NSString*)url placeHolder:(UIImage*)placeHolder;

@end
