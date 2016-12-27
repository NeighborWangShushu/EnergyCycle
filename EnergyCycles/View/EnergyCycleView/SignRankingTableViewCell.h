//
//  SignRankingTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 2016/12/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignRankingModel.h"

@interface SignRankingTableViewCell : UITableViewCell

// 排名
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;
// 排名图片
@property (weak, nonatomic) IBOutlet UIImageView *rankingImage;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
// 名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 累计天数
@property (weak, nonatomic) IBOutlet UILabel *totalDays;
// 底部条
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)getDataWithModel:(SignRankingModel *)model;

@end
