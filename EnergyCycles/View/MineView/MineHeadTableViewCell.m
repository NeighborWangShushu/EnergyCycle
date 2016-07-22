//
//  MineHeadTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineHeadTableViewCell.h"
#import "MineHomePageHeadModel.h"

@implementation MineHeadTableViewCell

- (void)updateDataWithModel:(UserModel *)model
                  infoModel:(UserInfoModel *)infoModel {
    // 头像
    if (model.photourl == NULL) {
        self.headImage.imageView.image = [UIImage imageNamed:@"touxiang"];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.photourl] forState:UIControlStateNormal];
    }
    
    // 昵称
    self.nameLabel.text = model.nickname;
    // 性别
    if ([model.sex isEqualToString:@"男"]) {
        self.sexImage.image = [UIImage imageNamed:@"man"];
        self.constraint.constant = 32;
    } else if ([model.sex isEqualToString:@"女"]) {
        self.sexImage.image = [UIImage imageNamed:@"woman"];
        self.constraint.constant = 32;
    } else {
        self.sexImage.image = [UIImage imageNamed:@""];
        self.constraint.constant = 14;
    }
    // 签到
    if ([infoModel.AS_CONTINUONS integerValue] == 0) {
        self.signInLabel.text = @"";
    } else {
        self.signInLabel.text = [NSString stringWithFormat:@"连续签到%ld天",[infoModel.AS_CONTINUONS integerValue]];
    }
    // 地址
    if (model.city == NULL) {
//        self.constraint.constant = 6;
//        self.addressImage.hidden = YES;
//        self.addressLabel.hidden = YES;
        self.addressLabel.text = @"暂无数据";
    } else {
        self.addressLabel.text = model.city;
    }
    
    // 简介
    if (model.Brief == NULL) {
        self.introLabel.text = @"简介:暂无";
    } else {
        self.introLabel.text = [NSString stringWithFormat:@"简介:%@", model.Brief];
    }
}


- (IBAction)ChangeIntro:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JumpToIntroViewController" object:nil];
}

- (IBAction)ChangeIcon:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeHeadImage" object:nil];
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