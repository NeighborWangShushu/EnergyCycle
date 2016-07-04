//
//  MineEveryDayOneViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MineEveryDayOneViewCell.h"

@implementation MineEveryDayOneViewCell

- (void)awakeFromNib {
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 58/2.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
