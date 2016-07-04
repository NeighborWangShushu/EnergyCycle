//
//  EnergyPostViewCell.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "EnergyPostViewCell.h"

@interface EnergyPostViewCell ()

@end

@implementation EnergyPostViewCell

- (void)awakeFromNib {
    self.informationTextView.placehoder = @"请输入内容";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
