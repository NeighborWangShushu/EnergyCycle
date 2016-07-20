//
//  SettingTwoViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SettingTwoViewCell.h"

@implementation SettingTwoViewCell

- (void)updateDataWithSection:(NSInteger)section index:(NSInteger)index {
    if (section == 0) {
        if (index == 0) {
            self.leftLabel.text = @"个人资料";
        } else if (index == 1) {
            self.leftLabel.text = @"账号管理";
        }
    }
    if (section == 2) {
        if (index == 1) {
            self.leftLabel.text = @"意见反馈";
        } else if (index == 2){
            self.leftLabel.text = @"关于能量圈";
        }
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
