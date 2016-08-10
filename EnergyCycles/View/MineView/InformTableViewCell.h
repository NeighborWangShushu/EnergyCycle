//
//  InformTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/8/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotifyModel.h"

@interface InformTableViewCell : UITableViewCell

// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)updateDataWithModel:(NotifyModel *)model;

- (void)noData;

@end
