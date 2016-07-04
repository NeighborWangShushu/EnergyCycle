//
//  MineTwoViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MineTwoViewCell.h"

@implementation MineTwoViewCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - 填充数据
- (void)updateDataWithSection:(NSInteger)section withIndex:(NSInteger)index {
    if (section == 0) {
        if (index == 1) {
            self.leftImageView.image = [UIImage imageNamed:@"ziliao.png"];
            self.leftLabel.text = @"我的资料";
            self.rightLabel.text = @"修改 完善";
            self.lineView.hidden = NO;
        }else {
            self.leftImageView.image = [UIImage imageNamed:@"shejiaoquan.png"];
            self.leftLabel.text = @"我的社交圈";
            self.rightLabel.text = @"好友";
            self.lineView.hidden = YES;
        }
    }else if (section == 1) {
        if (index == 0) {
            self.leftImageView.image = [UIImage imageNamed:@"jifen1.png"];
            self.leftLabel.text = @"积分排行榜";
            self.rightLabel.text = @"查看排行";
            self.lineView.hidden = NO;
        }else if (index == 1) {
            self.leftImageView.image = [UIImage imageNamed:@"shenqing.png"];
            self.leftLabel.text = @"申请老学员认证";
            self.rightLabel.text = @"立即认证";
            self.lineView.hidden = NO;
        }else {
            self.leftImageView.image = [UIImage imageNamed:@"jifen.png"];
            self.leftLabel.text = @"积分商城";
            self.rightLabel.text = @"兑换 抽奖";
            self.lineView.hidden = YES;
        }
    }else {
        self.leftImageView.image = [UIImage imageNamed:@"jianyi.png"];
        self.leftLabel.text = @"我要提建议";
        self.rightLabel.text = @"提建议";
        self.lineView.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
