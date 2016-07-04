//
//  CourseTableViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CourseTableViewCell.h"

@implementation CourseTableViewCell

- (void)awakeFromNib {
    self.biaoLabel.layer.masksToBounds = YES;
    self.biaoLabel.layer.cornerRadius = 2.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
