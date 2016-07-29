//
//  MineRecommendedTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommentModel.h"

@interface MineRecommendedTableViewCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// 简介
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

- (void)updateDataWithModel:(RecommentModel *)model;

@end
