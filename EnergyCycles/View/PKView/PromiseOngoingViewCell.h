//
//  PromiseOngoingViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromiseOngoingViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // 项目名称
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // 目标时长
@property (weak, nonatomic) IBOutlet UILabel *dailyGoal; // 每日目标
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel; // 开始时间
@property (weak, nonatomic) IBOutlet UILabel *scheduleLabel; // 进度百分比
@property (weak, nonatomic) IBOutlet UIView *scheduleView; // 进度块

- (void)getDataWithModel;

@end
