//
//  MineHeadTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineHeadTableViewCell.h"

@implementation MineHeadTableViewCell

// 获取数据
- (void)updataDataWithImage:(NSString *)image
                       name:(NSString *)name
                        sex:(NSString *)sex
                     signIn:(NSInteger)signIn
                    address:(NSString *)address
                      intro:(NSString *)intro {
    // 头像
    if ([image isEqualToString:@""]) {
        self.headImage.imageView.image = [UIImage imageNamed:@"touxiang"];
    } else {
        [self.headImage.imageView sd_setImageWithURL:[NSURL URLWithString:image]];
    }
    // 昵称
    self.nameLabel.text = name;
    // 性别
    if ([sex isEqualToString:@"男"]) {
        self.sexImage.image = [UIImage imageNamed:@"man"];
    } else if ([sex isEqualToString:@"女"]) {
        self.sexImage.image = [UIImage imageNamed:@"woman"];
    } else {
        self.sexImage.image = [UIImage imageNamed:@""];
    }
    // 签到
    if (signIn == 0) {
        self.signInLabel.text = @"";
    } else {
        self.signInLabel.text = [NSString stringWithFormat:@"连续签到%ld天",signIn];
    }
    // 地址
    self.addressLabel.text = address;
    // 简介
    if ([intro isEqualToString:@""]) {
        self.introLabel.text = @"简介:暂无";
    } else {
        self.introLabel.text = [NSString stringWithFormat:@"简介:%@",intro];
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
