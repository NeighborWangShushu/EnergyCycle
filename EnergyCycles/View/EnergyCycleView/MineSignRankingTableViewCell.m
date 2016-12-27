//
//  MineSignRankingTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2016/12/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineSignRankingTableViewCell.h"

@implementation MineSignRankingTableViewCell

- (void)getDataWithModel:(SignRankingModel *)model {
    // 排名
    self.rankingLabel.text = [NSString stringWithFormat:@"第%@名", model.RankNum];
    
    // 头像
    if ([model.photourl isEqualToString:@""] || model.photourl == nil) {
        [self.headerImageView setImage:[UIImage imageNamed:@"touxiang"]];
    } else {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.photourl]];
    }
    
    // 名字
    self.nameLabel.text = model.nickname;
    
    // 累计天数
    self.totalDays.text = [NSString stringWithFormat:@"%@天", model.Num];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
