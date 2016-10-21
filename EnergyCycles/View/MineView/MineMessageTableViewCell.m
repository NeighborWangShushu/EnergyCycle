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
    
//    NSLog(@"sdfasdfsdf%@",model);
    // 用户名
    
    self.nameLabel.text = model.nickname;
    
    // 时间
    NSString *time = [model.NotifyTime substringToIndex:10];
    self.timeLabel.text = time;
    
    // 消息
    NSString *messageText = [model.NotifyContent stringByRemovingPercentEncoding];
    messageText = [messageText stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    messageText = [messageText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    self.messageLabel.text = messageText;
    
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

- (void)noData {
    self.userInteractionEnabled = NO;
    self.textLabel.text = @"暂无数据";
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
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
