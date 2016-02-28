//
//  CYOperationQueue.m
//  缓存图片
//
//  Created by dongzb on 16/1/16.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "CYOperationQueue.h"
#import "CYDownloadOperation.h"
@implementation CYOperationQueue

- (void)setSuspended:(BOOL)suspended
{
    [super setSuspended:suspended];
    
    BOOL pause = suspended;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pause" object:@(pause)];
    
}

@end
