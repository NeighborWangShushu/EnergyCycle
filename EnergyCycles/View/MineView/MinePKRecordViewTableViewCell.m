//
//  MinePKRecordViewTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MinePKRecordViewTableViewCell.h"

@implementation MinePKRecordViewTableViewCell

- (void)getDataWithModel:(MyPkEveryModel *)model number:(NSInteger)number {
    
    // 序号
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",number];
    
    // 图片
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    
    // 项目名称
    self.titleLabel.text = model.name;
    
    // 记录总数
    self.recordCountLabel.text = [NSString stringWithFormat:@"%@条记录", model.tCount];
    
    // 最近一次记录的时间
    NSString *time = [model.RI_DATE substringToIndex:10];
    self.timeLabel.text = [NSString stringWithFormat:@"最近%@", time];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
