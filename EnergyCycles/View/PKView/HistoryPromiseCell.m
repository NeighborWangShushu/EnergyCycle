//
//  HistoryPromiseCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HistoryPromiseCell.h"

@implementation HistoryPromiseCell

- (void)getDataWithModel:(PromiseModel *)model {
    
    self.backgroundColor = [UIColor clearColor];
    [self.picImage sd_setImageWithURL:[NSURL URLWithString:model.P_PICURL]];
    self.titleLabel.text = model.ProjectName;
    NSString *startDate_str = [model.StartDate substringToIndex:10];
    NSString *endDate_str= [model.EndDate substringToIndex:10];
    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@", startDate_str, endDate_str];
    self.timeLabel.text = [NSString stringWithFormat:@"%@天", model.AllDays];
    self.dailyGoalLabel.text = [NSString stringWithFormat:@"%@%@", model.ReportNum, model.P_UNIT];
    
    // 内容视图
    self.containerView.layer.cornerRadius = 10;
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOpacity = 0.5;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    
    if ([model.FinishDays isEqualToString:model.AllDays]) {
        [self.finishImage setImage:[UIImage imageNamed:@"promise_finish"]];
    } else {
        [self.finishImage setImage:[UIImage imageNamed:@"promise_unfinish"]];
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
