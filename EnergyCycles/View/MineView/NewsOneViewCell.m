//
//  NewsOneViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "NewsOneViewCell.h"

@implementation NewsOneViewCell

- (void)awakeFromNib {
    self.readPointImageView.backgroundColor = [UIColor redColor];
    self.readPointImageView.layer.masksToBounds = YES;
    self.readPointImageView.layer.cornerRadius = 4.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
