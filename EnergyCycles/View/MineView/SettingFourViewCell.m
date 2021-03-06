//
//  SettingFourViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SettingFourViewCell.h"

@implementation SettingFourViewCell

- (void)updateDataWithJudge:(BOOL)judge {
    if (judge == NO) {
        self.rightLabel.text = @"未开启";
    } else {
        self.rightLabel.text = @"已开启";
    }
    self.leftLabel.text = @"消息推送";
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
