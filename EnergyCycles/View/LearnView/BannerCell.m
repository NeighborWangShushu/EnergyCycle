//
//  BannerCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BannerCell.h"
#import "Masonry.h"
#import "SDCycleScrollView.h"

@interface BannerCell ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong)SDCycleScrollView * scrollView;
@end

@implementation BannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSArray *)data {
    _data = data;
    [self setup];
}

- (void)setup {

    if (self.scrollView) {
        self.scrollView.imageURLStringsGroup = _data;
        return;
    }
    SDCycleScrollView * scrollView  = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    scrollView.pageControlStyle     = SDCycleScrollViewPageContolStyleAnimated;
    scrollView.imageURLStringsGroup = _data;
    [scrollView setCurrentPageDotImage:[UIImage imageNamed:@"banner_dot_noamal"]];
    [scrollView setPageDotImage:[UIImage imageNamed:@"banner_dot_selected"]];
    [self addSubview:scrollView];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@180);
    }];
    self.scrollView = scrollView;
    [scrollView setClickItemOperationBlock:^(NSInteger index) {
    BannerItem*item = self.items[index];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"WDTwoScrollViewClick" object:nil userInfo:@{@"url":[NSString stringWithFormat:@"%@",item.url],@"type":[NSNumber numberWithInteger:item.type]}];
    }];


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
