//
//  MineRecViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MineRecViewCell.h"

@implementation MineRecViewCell

- (void)awakeFromNib {
    self.iconImageButton.layer.masksToBounds = YES;
    self.iconImageButton.layer.cornerRadius = 20.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
