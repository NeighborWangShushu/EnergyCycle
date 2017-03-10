//
//  DailyPromiseTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromiseDetailModel.h"

@interface DailyPromiseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView; // 容器视图

@property (weak, nonatomic) IBOutlet UIView *leftView; // 左视图

@property (weak, nonatomic) IBOutlet UIView *point; // 提示红点

@property (weak, nonatomic) IBOutlet UILabel *promise; // 每日目标

@property (weak, nonatomic) IBOutlet UILabel *completeLabel; // 完成

- (void)getDataWithModel:(PromiseDetailModel *)model;

@end
