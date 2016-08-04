//
//  EveryDayPKViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 16/1/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "EveryDayPKViewCell.h"

@implementation EveryDayPKViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)clickRightButton:(UIButton *)sender {
    if (_zanButton) {
        _zanButton(sender.tag - 30002);
    }
}

@end
