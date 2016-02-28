//
//  CYWebImageDefine.h
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#ifndef CYWebImageDefine_h
#define CYWebImageDefine_h
#import "NSString+CYMD5.h"
#import "CYImageCache.h"
#import "CYDownloadManager.h"
#import "CYDownloadOperation.h"
#import "CYOperationQueue.h"
#import "UIImageView+CYImageViewCache.h"

#define CYImageCacheFilePath(url) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[url lastPathComponent]]

#endif /* CYWebImageDefine_h */
