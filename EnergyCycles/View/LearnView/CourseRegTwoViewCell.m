//
//  CourseRegTwoViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CourseRegTwoViewCell.h"

@implementation CourseRegTwoViewCell

- (void)awakeFromNib {
    self.backView.layer.borderWidth = 1.f;
    self.backView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
