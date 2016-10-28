//
//  PraiseRankingTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PraiseRankingModel.h"

@interface PraiseRankingTableViewCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
// 名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 排名
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;
// 底部条
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)getDataWithModel:(PraiseRankingModel *)model;

@end
