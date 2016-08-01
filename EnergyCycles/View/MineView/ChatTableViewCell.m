//
//  ChatTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (void)updateDataWithModel:(MessageModel *)model {
    self.text.text = model.MessageContent;
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
