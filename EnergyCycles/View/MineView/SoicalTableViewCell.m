//
//  SoicalTableViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SoicalTableViewCell.h"

@implementation SoicalTableViewCell

- (void)awakeFromNib {
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 21.5f;
    
    self.rightButton.layer.masksToBounds = YES;
    self.rightButton.layer.cornerRadius = 3.f;
    self.rightButton.layer.borderWidth = 1.f;
    self.rightButton.layer.borderColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1].CGColor;
}

- (IBAction)soicalHeadButtonClick:(UIButton *)sender {
    if (_soicalHeadButtonClick) {
        _soicalHeadButtonClick(self.tag);
    }
}

- (IBAction)rightButtonClick:(UIButton *)sender {
    _soicalButtonClick(self.tag);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
