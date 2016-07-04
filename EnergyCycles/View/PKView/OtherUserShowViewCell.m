//
//  OtherUserShowViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 16/3/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OtherUserShowViewCell.h"

@implementation OtherUserShowViewCell

- (void)awakeFromNib {
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 21.5f;
    
    self.rightButton.layer.masksToBounds = YES;
    self.rightButton.layer.cornerRadius = 3.f;
    self.rightButton.layer.borderWidth = 1.f;
    self.rightButton.layer.borderColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1].CGColor;
}

- (IBAction)otherHeadButtonClick:(UIButton *)sender {
    if (_otherUserHeadButtonClick) {
        _otherUserHeadButtonClick(self.tag);
    }
}

- (IBAction)rightButtonClick:(UIButton *)sender {
    if (_otherUserButtonClick) {
        _otherUserButtonClick(self.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
