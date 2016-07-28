//
//  MineHomePageTableViewControllerProtocol.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kHeaderImgHeight 250
#define kNavigationHeight 64
#define kSegmentedHeight 40

@protocol TabelViewScrollingProtocol <NSObject>

@required
// 拖动时触发
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY;
// 停止滚动时触发
- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY;
// 停止拖拽时触发
- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY;
// 将要开始拖拽时触发
- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY;
// 将要结束拖拽时触发
- (void)tableViewWillBeginDecelerating:(UITableView *)tablView offsetY:(CGFloat)offsetY;

@end

@interface MineHomePageTableViewControllerProtocol : UITableViewController

@property (nonatomic, weak) id<TabelViewScrollingProtocol> delegate;

@end
