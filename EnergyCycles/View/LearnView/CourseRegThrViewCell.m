//
//  CourseRegThrViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CourseRegThrViewCell.h"

@implementation CourseRegThrViewCell

- (void)awakeFromNib {
    self.inputTextView.layer.borderWidth = 1.f;
    self.inputTextView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    
    self.inputTextView.placehoder = @"请输入...";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
