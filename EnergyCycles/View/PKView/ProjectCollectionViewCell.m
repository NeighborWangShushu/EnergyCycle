//
//  ProjectCollectionViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ProjectCollectionViewCell.h"

@implementation ProjectCollectionViewCell

- (void)getDataWithModel:(PKSelectedModel *)model {
    self.backgroundColor = [UIColor clearColor];
    [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.picUrl]]];
    [self.projectNameLabel setText:model.name];
    self.layer.masksToBounds = NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
