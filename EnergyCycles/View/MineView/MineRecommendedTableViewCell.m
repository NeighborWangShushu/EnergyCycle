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
    
    // 简介
    if (model.Brief == NULL || [model.Brief isEqualToString:@""]) {
        self.introLabel.text = @"暂未设置简介";
    } else {
        self.introLabel.text = model.Brief;
    }
    
}

- (void)noData {
    self.textLabel.text = @"暂无推荐用户";
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
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
