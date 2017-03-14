//
//  PromiseOngoingViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PromiseOngoingViewCell.h"
#import "Masonry.h"

@implementation PromiseOngoingViewCell

- (void)getDataWithModel:(PromiseModel *)model {
    
    // 根据目标开始时间进行显示判断
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startDate = [formatter dateFromString:model.StartDate];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval startDateInterval = [startDate timeIntervalSince1970]; // 开始时间的时间间隔
    NSTimeInterval nowDateInterval = [nowDate timeIntervalSince1970]; // 现在时间的时间间隔
    if (startDateInterval > nowDateInterval) {
        formatter.dateFormat = @"MM/dd";
        NSString *startDate_str = [formatter stringFromDate:startDate];
        NSMutableAttributedString *startText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"目标将于%@开始", startDate_str]];
        NSRange range = NSMakeRange(4, startDate_str.length);
        [startText addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor blackColor]} range:range];
        self.startTimeLabel.attributedText = startText;
    } else {
        NSRange range = NSMakeRange(5, model.FinishDays.length + model.AllDays.length + 1);
        NSMutableAttributedString *startText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"完成目标第%ld/%ld天", [model.FinishDays integerValue], [model.AllDays integerValue]]];
        [startText addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor blackColor]} range:range];
        self.startTimeLabel.attributedText = startText;
    }
    
    // 完成进度
    CGFloat modulus = [model.FinishDays floatValue] / [model.AllDays floatValue];
    self.titleLabel.text = model.ProjectName;
    if ([model.P_UNIT isEqualToString:@"天"]) {
        [self.timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.titleLabel);
        }];
        self.dailyGoalTitle.hidden = YES;
        self.dailyGoal.hidden = YES;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@天", model.AllDays];
    self.dailyGoal.text = [NSString stringWithFormat:@"%@%@", model.ReportNum, model.P_UNIT];
    self.scheduleLabel.text = [NSString stringWithFormat:@"%.f%%", modulus * 100];
    self.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    self.containerView.layer.cornerRadius = 10; // 内容视图圆角
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOpacity = 0.5;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.scheduleView.layer.cornerRadius = self.scheduleView.frame.size.height / 2;
    CALayer *scheduleLayer = [CALayer layer];
    CGFloat schedule = self.scheduleView.frame.size.width * modulus;
    scheduleLayer.frame = CGRectMake(0.0f, 0.0f, schedule, self.scheduleView.frame.size.height);
    scheduleLayer.cornerRadius = self.scheduleView.frame.size.height / 2;
    scheduleLayer.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
    scheduleLayer.shadowColor = scheduleLayer.backgroundColor;
    scheduleLayer.shadowOpacity = 0.5;
    scheduleLayer.shadowOffset = CGSizeMake(2, 2);
    [self.scheduleView.layer addSublayer:scheduleLayer];
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
