//
//  MinePKRecordViewTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPkEveryModel.h"

@interface MinePKRecordViewTableViewCell : UITableViewCell

// 序号
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
// 项目名称
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 记录总数
@property (weak, nonatomic) IBOutlet UILabel *recordCountLabel;
// 最近一次记录的时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)getDataWithModel:(MyPkEveryModel *)model number:(NSInteger)number;

@end
