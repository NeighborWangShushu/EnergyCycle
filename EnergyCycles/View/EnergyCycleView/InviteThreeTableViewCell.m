//
//  InviteThreeTableViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "InviteThreeTableViewCell.h"

@implementation InviteThreeTableViewCell

- (void)awakeFromNib {
    self.iconButton.layer.masksToBounds = YES;
    self.iconButton.layer.cornerRadius = 20.f;
}

- (IBAction)iconButtonClick:(UIButton *)sender {
    if (_iconButtonClick) {
        _iconButtonClick(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
