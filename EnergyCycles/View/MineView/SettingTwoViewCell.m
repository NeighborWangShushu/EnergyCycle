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
//        if (index == 0) {
//            self.leftLabel.text = @"个人资料";
//            [self lineView];
//        } else if (index == 1) {
            self.leftLabel.text = @"账号管理";
//            [self lineView];
//        }
    }
    if (section == 2) {
        if (index == 1) {
            self.leftLabel.text = @"意见反馈";
            [self lineView];
        } else if (index == 2){
            self.leftLabel.text = @"关于能量圈";
        }
    }
    if (section == 3) {
        self.leftLabel.text = @"退出当前账号";
        self.leftLabel.textColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
        self.rightImage.hidden = YES;
    }
}

- (void)isOtherLogin {
    self.leftLabel.text = @"";
    self.rightImage.hidden = YES;
}

- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x + 31, self.frame.size.height - 1, Screen_width - 50, 1);
    line.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    [self.contentView addSubview:line];
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
