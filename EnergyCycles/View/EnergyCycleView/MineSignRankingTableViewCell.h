//
//  MineSignRankingTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 2016/12/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignRankingModel.h"

@interface MineSignRankingTableViewCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
// 名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 排名
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;
// 累计天数
@property (weak, nonatomic) IBOutlet UILabel *totalDays;

- (void)getDataWithModel:(SignRankingModel *)model;

@end
