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
// 简介
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
// 底部view
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (void)updateDataWithModel:(RecommentModel *)model;

- (void)noData;

@end
