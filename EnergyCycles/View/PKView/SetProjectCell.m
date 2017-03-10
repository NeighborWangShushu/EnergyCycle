//
//  SetProjectCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SetProjectCell.h"

@implementation SetProjectCell

- (void)getDataWithModelIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        self.titleLabel.text = @"开始日期";
        self.timeTextField.hidden = NO;
        self.numberTextField.hidden = YES;
        self.unitLabel.hidden = YES;
    } else if (indexPath.row == 1) {
        self.titleLabel.text = @"结束日期";
        self.timeTextField.hidden = NO;
        self.numberTextField.hidden = YES;
        self.unitLabel.hidden = YES;
    } else if (indexPath.row == 2) {
        self.titleLabel.text = @"每日目标";
        self.timeTextField.hidden = YES;
        self.numberTextField.hidden = NO;
        self.unitLabel.hidden = NO;
        self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
}

- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x + 25, self.frame.size.height - 1, Screen_width - 50, 1);
    line.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
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
