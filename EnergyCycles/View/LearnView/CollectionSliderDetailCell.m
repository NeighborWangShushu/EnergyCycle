//
//  CollectionSliderDetailCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CollectionSliderDetailCell.h"

@implementation CollectionSliderDetailCell

- (void)getDataWithModel:(BannerModel *)model {
    self.url = model.Content;
    self.backgroundImage.layer.cornerRadius = 10;
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:model.ImageUrl] forState:UIControlStateNormal];
    self.nameLabel.text = model.Title;
}

- (IBAction)clickAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LearnRecommend" object:self.url];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
