//
//  SettingThreeViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SettingThreeViewCell.h"

@implementation SettingThreeViewCell

- (void)updateDataWithData:(CGFloat)data {
    self.leftLabel.text = @"清理缓存";
    self.rightLabel.text = [NSString stringWithFormat:@"%.1fM",data];
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
