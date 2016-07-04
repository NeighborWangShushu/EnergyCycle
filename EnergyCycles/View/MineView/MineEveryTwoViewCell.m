//
//  MineEveryTwoViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MineEveryTwoViewCell.h"

@implementation MineEveryTwoViewCell

- (void)awakeFromNib {
    self.showImageView.layer.masksToBounds = YES;
    self.showImageView.layer.cornerRadius = 78/2.f;
}


@end
