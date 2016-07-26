//
//  MineMessageTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineMessageTableViewCell.h"

@implementation MineMessageTableViewCell

- (void)updateDataWithModel:(GetMessageModel *)model {
    
    NSLog(@"sdfasdfsdf%@",model);
    // 用户名
    self.nameLabel.text = model.nickname;
    
    // 时间
    self.timeLabel.text = model.NotifyTime;
    
    // 消息
    self.messageLabel.text = model.NotifyContent;
    
    // 能量圈第一张图片
    if ([model.FirstImg isEqualToString:@""] || model.FirstImg == nil) {
        self.firstImage.hidden = YES;
        self.constraint.constant = 12;
    } else {
        [self.firstImage sd_setImageWithURL:[NSURL URLWithString:model.FirstImg]];
        self.constraint.constant = 70;
    }
    
    // 内容
    NSString *commentText = [model.A_CONTENT stringByRemovingPercentEncoding];
    commentText = [commentText stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    commentText = [commentText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    self.titleLabel.text = commentText;
    
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
