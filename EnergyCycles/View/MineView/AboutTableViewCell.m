//
//  AboutTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AboutTableViewCell.h"

@implementation AboutTableViewCell

- (void)updateDataWithIndex:(NSInteger)index {
    if (index == 0) {
        self.leftLabel.text = @"电话";
        self.rightLabel.text = @"400-800-6258";
        self.rightImage.hidden = YES;
        [self lineView];
    } else if (index == 1) {
        self.leftLabel.text = @"给我评分";
        self.rightLabel.hidden = YES;
        [self lineView];
    } else if (index == 2) {
        self.leftLabel.text = @"功能介绍";
        self.rightLabel.hidden = YES;
//        [self lineView];
    } else if (index == 3) {
        self.leftLabel.text = @"检查版本更新";
        self.rightLabel.hidden = YES;
    }
}

- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x + 31, self.frame.size.height - 1, self.frame.size.width + 50, 1);
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
