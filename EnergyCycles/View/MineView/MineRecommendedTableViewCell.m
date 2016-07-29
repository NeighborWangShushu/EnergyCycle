//
//  MineRecommendedTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineRecommendedTableViewCell.h"

@implementation MineRecommendedTableViewCell

- (void)updateDataWithModel:(RecommentModel *)model {
    
    // 头像
    if ([model.photourl isEqualToString:@""] || model.photourl == nil) {
        [self.headImage setImage:[UIImage imageNamed:@"touxiang"]];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.photourl]];
    }
    
    // 昵称
    self.nameLabel.text = model.nickname;
    
    // 时间
    NSString *time = [model.user_registerDate substringToIndex:10];
    self.timeLabel.text = time;
    
    // 简介
    if (model.Brief == NULL || [model.Brief isEqualToString:@""]) {
        self.introLabel.text = @"暂无设置简介";
    } else {
        self.introLabel.text = model.Brief;
    }
    
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
