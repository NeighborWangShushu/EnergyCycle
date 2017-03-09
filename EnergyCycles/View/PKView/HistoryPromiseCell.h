//
//  HistoryPromiseCell.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromiseModel.h"

@interface HistoryPromiseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;// 项目名称
@property (weak, nonatomic) IBOutlet UILabel *dateLabel; // 目标开始与结束时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // 目标时长
@property (weak, nonatomic) IBOutlet UILabel *dailyGoalLabel; // 每日目标
@property (weak, nonatomic) IBOutlet UIImageView *finishImage; // 是否完成图片

- (void)getDataWithModel:(PromiseModel *)model;

@end
