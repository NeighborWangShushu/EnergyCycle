//
//  ToDayPKTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/8/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherReportModel.h"

@interface ToDayPKTableViewCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
// 项目名称
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 记录数量
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
// 今日排名
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;

- (void)updateDataWithModel:(OtherReportModel *)model;

- (void)noData;

@end
