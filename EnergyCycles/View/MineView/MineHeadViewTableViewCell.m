//
//  MineHeadViewTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineHeadViewTableViewCell.h"

@implementation MineHeadViewTableViewCell

- (void)updateDataWithModel:(UserModel *)model {
    
    // 背景
    if ([model.BackgroundImg isEqualToString:@""] || model.BackgroundImg == nil) {
        [self.backgroundImage setImage:[UIImage imageNamed:@"backgroundImage"]];
    } else {
        [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:model.BackgroundImg]];
    }
    
    // 头像
    if ([model.photourl isEqualToString:@""] || model.photourl == nil) {
        [self.headImage setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.photourl] forState:UIControlStateNormal];
    }
    
    // 昵称
    self.nameLabel.text = model.nickname;
    
    // 性别
    if ([model.sex isEqualToString:@"男"]) {
        self.sexImage.image = [UIImage imageNamed:@"man"];
    } else if ([model.sex isEqualToString:@"女"]) {
        self.sexImage.image = [UIImage imageNamed:@"woman"];
    } else {
        self.sexImage.image = [UIImage imageNamed:@""];
    }
    
    // 积分
    self.integralLabel.text = model.jifen;
    
    // 地址
    if ([model.city isEqualToString:@""] || model.city == nil) {
        self.addressImage.hidden = YES;
    } else {
        self.addressImage.hidden = NO;
        self.addressLabel.text = model.city;
    }
    
}

- (IBAction)changeHeadImage:(id)sender {
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
