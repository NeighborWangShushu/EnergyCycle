//
//  OtherUserTableViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "OtherUserTableViewCell.h"

@implementation OtherUserTableViewCell

- (void)awakeFromNib {
    self.userIconImageVoew.layer.masksToBounds = YES;
    self.userIconImageVoew.layer.cornerRadius = 58/2.f;
}

- (IBAction)zanButtonClick:(UIButton *)sender {
    if (_zanButtonClick) {
        _zanButtonClick(sender.tag - 30001);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}




@end
