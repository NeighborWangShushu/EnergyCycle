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
    
    self.rankingImage.contentMode = UIViewContentModeScaleAspectFit;
    
    // 前三名显示图标
    if ([model.RankingNum isEqualToString:@"1"]) {
        self.rankingLabel.hidden = YES;
        self.rankingImage.hidden = NO;
        self.rankingImage.image = [UIImage imageNamed:@"praiseRankingFirst"];
        self.praiseCount.textColor = [UIColor colorWithRed:254/255.0 green:197/255.0 blue:53/255.0 alpha:1];
    } else if ([model.RankingNum isEqualToString:@"2"]) {
        self.rankingLabel.hidden = YES;
        self.rankingImage.hidden = NO;
        self.rankingImage.image = [UIImage imageNamed:@"praiseRankingSecond"];
        self.praiseCount.textColor = [UIColor colorWithRed:172/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    } else if ([model.RankingNum isEqualToString:@"3"]) {
        self.rankingLabel.hidden = YES;
        self.rankingImage.hidden = NO;
        self.rankingImage.image = [UIImage imageNamed:@"praiseRankingThird"];
        self.praiseCount.textColor = [UIColor colorWithRed:172/255.0 green:123/255.0 blue:67/255.0 alpha:1];
    }
    
    // 排名
    self.rankingLabel.text = model.RankingNum;
    
    // 头像
    if ([model.photourl isEqualToString:@""] || model.photourl == nil) {
        [self.headerImageView setImage:[UIImage imageNamed:@"touxiang"]];
    } else {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.photourl]];
    }
    
    // 名字
    self.nameLabel.text = model.nickname;
    
    // 获赞个数
    self.praiseCount.text = [NSString stringWithFormat:@"%@赞", model.Goods];
        
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
