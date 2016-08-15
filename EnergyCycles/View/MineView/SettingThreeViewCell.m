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
    [self lineView];
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
