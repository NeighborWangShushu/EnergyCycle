//
//  MinePKRecordViewTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MinePKRecordViewTableViewCell.h"

@implementation MinePKRecordViewTableViewCell

- (void)getDataWithModel:(MyPkEveryModel *)model {
    
    // 图片
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    
    // 项目名称
    self.titleLabel.text = model.name;
    
    // 记录总数
    self.recordCountLabel.text = [NSString stringWithFormat:@"%@条记录", model.tCount];
    
    // 最近一次记录的时间
    NSString *time = [model.RI_DATE substringToIndex:10];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", time];
    
    [self lineView];
    
}

- (void)noData {
    self.userInteractionEnabled = NO;
    self.headImage.hidden = YES;
    self.titleLabel.hidden = YES;
    self.recordCountLabel.hidden = YES;
    self.titleLabel.hidden = YES;
    self.textLabel.text = @"该用户暂无PK记录";
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x + 12, self.frame.size.height - 1, self.frame.size.width + 50, 1);
    line.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    [self.contentView addSubview:line];
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
