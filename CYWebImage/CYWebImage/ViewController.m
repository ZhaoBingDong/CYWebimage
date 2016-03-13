//
//  ViewController.m
//  CYWebImage
//
//  Created by dongzb on 16/2/28.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "ViewController.h"
#import "CYTableViewCell.h"
#import "CYWebImageDefine.h"
#import "UIImageView+Extension.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()
<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray <NSString *>*dataSource;
@end

@implementation ViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"url.plist" ofType:nil]];
    [self.dataSource addObjectsFromArray:array];
    [self.tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CYTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *image_url = self.dataSource[indexPath.row];
    
    NSURL *url = [NSURL URLWithString:image_url];
    // 设置圆角图片 调用的是 SDWebImage 的下载方法
//    [cell.cyImagreView setRoundImageWithURL:url placeHoder:[UIImage imageNamed:@"huluw.png"]];
    
    // 自己写的缓存图片方法 只做学习交流 并不能用到项目里 优化的不够好
//        [cell.cyImagreView setImageWithURL:url.absoluteString placeHolder:[UIImage imageNamed:@"huluw"]];
    
    
    [cell.cyImagreView cyImageWithURL:url placeHolder:[UIImage imageNamed:@"菜谱详情加载"]];
    
//    [cell.cyImagreView setImageWithURL:url];
    
    
//        [cell.cyImagreView setImageWithURL:url option:CYWebImageOptionHighPriority placeHolder:[UIImage imageNamed:@"菜谱详情加载"] progress:^(float receviedSize, float totalSize) {
//            NSLog(@"-----%f",receviedSize/totalSize);
//        } completeBlock:^(UIImage * _Nullable image) {
//    
//    //        NSLog(@"----%@",image);
//    
//        }];

    
    // SDWebImage缓存图片的方法
//    [cell.cyImagreView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"huluw"]];
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
