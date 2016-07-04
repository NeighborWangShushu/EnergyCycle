//
//  MineOneViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MineOneViewCell.h"

@implementation MineOneViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateDataWithStr:(NSString *)getStr {
    self.leftImageView.image = [UIImage imageNamed:@"nengliangyuan.png"];
    self.leftLabel.text = @"我的邀请码";
    
    self.rightLabel.text = getStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
