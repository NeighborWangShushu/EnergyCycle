//
//  ToDayPKTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ToDayPKTableViewCell.h"

@implementation ToDayPKTableViewCell

- (void)updateDataWithModel:(OtherReportModel *)model {
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.RI_Pic]];
    
    self.titleLabel.text = model.RI_Name;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%@%@", model.RI_Num, model.RI_Unit];
    
    self.rankingLabel.text = [NSString stringWithFormat:@"今日排名:%@", model.orderNum];
    
    [self lineView];
}

- (void)noData {
    self.userInteractionEnabled = NO;
    self.textLabel.text = @"该用户暂无今日PK汇报";
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x + 12, self.frame.size.height - 1, self.frame.size.width + 50, 1);
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
