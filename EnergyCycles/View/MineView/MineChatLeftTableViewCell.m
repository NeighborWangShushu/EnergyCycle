//
//  MineChatLeftTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineChatLeftTableViewCell.h"

@implementation MineChatLeftTableViewCell

- (void)updateDataWithModel:(MessageModel *)model {
    if ([model.bImg isEqualToString:@""] || model.bImg == nil) {
        [self.leftHeadButton setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    } else {
        [self.leftHeadButton sd_setImageWithURL:[NSURL URLWithString:model.bImg] forState:UIControlStateNormal];
    }
    
    UIImage *image = [UIImage imageNamed:@"chat_left"];
    [self.leftContentImage setImage:[image stretchableImageWithLeftCapWidth:15 topCapHeight:15]];
    
    self.leftContentLabel.text = model.MessageContent;

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
