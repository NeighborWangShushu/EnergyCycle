//
//  InformTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "InformTableViewCell.h"

@implementation InformTableViewCell

- (void)updateDataWithModel:(NotifyModel *)model {
    self.titleLabel.text = model.NotifyTitle;
    
    NSString *commentText = [model.NotifyContent stringByRemovingPercentEncoding];
    commentText = [commentText stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    commentText = [commentText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    commentText = [commentText stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    commentText = [commentText stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    self.contentLabel.text = commentText;
    
    NSString *time = [model.NotifyTime substringToIndex:10];
    self.timeLabel.text = time;
}

- (void)noData {
    self.userInteractionEnabled = NO;
    self.textLabel.text = @"暂无通知";
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
