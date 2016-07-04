//
//  ReportOneCollectionViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ReportOneCollectionViewCell.h"

@implementation ReportOneCollectionViewCell

- (void)awakeFromNib {
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 78/2.f;
}

#pragma mark - 填充数据
- (void)updateCollectionViewDataWithModel:(PKSelectedModel *)model {
    self.titleLabel.text = nil;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.picUrl]]];
    self.titleLabel.text = model.name;
}


@end
