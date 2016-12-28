//
//  SignRankingTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2016/12/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SignRankingTableViewCell.h"

@implementation SignRankingTableViewCell

- (void)getDataWithModel:(SignRankingModel *)model {
    
    // 图片用原比例显示
    self.rankingImage.contentMode = UIViewContentModeScaleAspectFit;
    
    // 前三名显示图标
    if ([model.RankNum isEqualToString:@"1"]) {
        self.rankingLabel.hidden = YES;
        self.rankingImage.hidden = NO;
        self.rankingImage.image = [UIImage imageNamed:@"praiseRankingFirst"];
//        self.praiseCount.textColor = [UIColor colorWithRed:254/255.0 green:197/255.0 blue:53/255.0 alpha:1];
    } else if ([model.RankNum isEqualToString:@"2"]) {
        self.rankingLabel.hidden = YES;
        self.rankingImage.hidden = NO;
        self.rankingImage.image = [UIImage imageNamed:@"praiseRankingSecond"];
//        self.praiseCount.textColor = [UIColor colorWithRed:172/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    } else if ([model.RankNum isEqualToString:@"3"]) {
        self.rankingLabel.hidden = YES;
        self.rankingImage.hidden = NO;
        self.rankingImage.image = [UIImage imageNamed:@"praiseRankingThird"];
//        self.praiseCount.textColor = [UIColor colorWithRed:172/255.0 green:123/255.0 blue:67/255.0 alpha:1];
    }
    
    // 排名
    self.rankingLabel.text = model.RankNum;
    
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
