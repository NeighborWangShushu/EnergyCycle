//
//  PraiseRankingTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PraiseRankingTableViewCell.h"

@implementation PraiseRankingTableViewCell

- (void)getDataWithModel:(PraiseRankingModel *)model {
    
    // 头像
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.photourl]];
    
    // 名字
    self.nameLabel.text = model.nickname;
    
    // 排名
    self.rankingLabel.text = model.RankingNum;
        
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
