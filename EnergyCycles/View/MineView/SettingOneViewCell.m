//
//  SettingOneViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SettingOneViewCell.h"

@implementation SettingOneViewCell

- (void)updateDataWithString:(NSString *)string {
    self.leftLabel.text = @"我的邀请码";
    self.rightLabel.text = string;
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
