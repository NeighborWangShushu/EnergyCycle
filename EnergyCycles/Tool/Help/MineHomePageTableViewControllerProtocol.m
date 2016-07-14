//
//  MineHomePageTableViewControllerProtocol.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineHomePageTableViewControllerProtocol.h"

@implementation MineHomePageTableViewControllerProtocol

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderImgHeight + kSegmentedHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    if (self.tableView.contentSize.height < kScreenHeight + kHeaderImgHeight - kNavigationHeight) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight + kHeaderImgHeight - kNavigationHeight - self.tableView.contentSize.height, 0);
    }
    
}

#pragma mark ----- ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewScroll:offsetY:)]) {
        [self.delegate tableViewScroll:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewWillBeginDragging:offsetY:)]) {
        [self.delegate tableViewWillBeginDragging:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewWillBeginDecelerating:offsetY:)]) {
        [self.delegate tableViewWillBeginDecelerating:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewDidEndDragging:offsetY:)]) {
        [self.delegate tableViewDidEndDragging:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewDidEndDecelerating:offsetY:)]) {
        [self.delegate tableViewDidEndDecelerating:self.tableView offsetY:offsetY];
    }
}

    


@end
