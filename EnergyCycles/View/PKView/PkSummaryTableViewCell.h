//
//  PkSummaryTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/8/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PkSummaryModel.h"

@interface PkSummaryTableViewCell : UITableViewCell

// 汇报次数
@property (weak, nonatomic) IBOutlet UILabel *reportNum;
// 累计天数
@property (weak, nonatomic) IBOutlet UILabel *allDayNum;
// 获赞个数
@property (weak, nonatomic) IBOutlet UILabel *praiseCount;
// 获赞排名
//@property (weak, nonatomic) IBOutlet UILabel *praiseRanking;
@property (weak, nonatomic) IBOutlet UIButton *praiseRanking;

- (void)getDataWithModel:(PkSummaryModel *)model;

@end
