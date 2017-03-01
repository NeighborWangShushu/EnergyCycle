//
//  PromiseOngoingViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PromiseOngoingViewCell.h"

@implementation PromiseOngoingViewCell

- (void)getDataWithModel {
    
    self.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    
    self.containerView.layer.cornerRadius = 10; // 内容视图圆角
    
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOpacity = 0.5;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.scheduleView.layer.cornerRadius = self.scheduleView.frame.size.height / 2;
    CALayer *scheduleLayer = [CALayer layer];
    CGFloat schedule = self.scheduleView.frame.size.width * 0.1;
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
