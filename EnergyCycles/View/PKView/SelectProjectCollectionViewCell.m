//
//  SelectProjectCollectionViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SelectProjectCollectionViewCell.h"

@implementation SelectProjectCollectionViewCell

- (void)awakeFromNib {
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 78/2.f;
    
    self.selectedImageView.image = [UIImage imageNamed:@""];
}

#pragma mark - 填充数据
- (void)updateCollectionDataWith {
    
}


@end
