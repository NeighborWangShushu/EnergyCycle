//
//  MineWhisperTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineWhisperTableViewCell.h"

@implementation MineWhisperTableViewCell

- (void)updateDataWithModel:(MessageModel *)model {
    
    // 未读
    if ([model.MessageIsRead isEqualToString:@"0"] || model.MessageIsRead == nil) {
        self.unReadView.hidden = NO;
        self.constraint.constant = 42;
    } else {
        self.unReadView.hidden = YES;
        self.constraint.constant = 17;
    }
    
    // 头像
    if ([model.photourl isEqualToString:@""] || model.photourl == nil) {
        [self.headImage setImage:[UIImage imageNamed:@"touxiang"]];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.photourl]];
    }
    
    // 昵称
    self.nameLabel.text = model.nickname;
    
    // 时间
    NSString *time = [model.MessageTime substringToIndex:10];
    self.timeLabel.text = time;
    
    // 内容
    NSString *commentText = [model.MessageContent stringByRemovingPercentEncoding];
    commentText = [commentText stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    commentText = [commentText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    self.contentLabel.text = commentText;
    
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
