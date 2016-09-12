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
    self.url = model.OuterPath;
//    CGRect frame = self.backgroundImage.frame;
//    CGFloat width = Screen_width / 3 - 34;
//    CGFloat height = width * (42 / 103);
//    CGSize size = CGSizeMake(width, height);
//    frame.size = size;
//    self.backgroundImage.frame = frame;
    self.backgroundImage.layer.cornerRadius = 10;
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:model.ImageUrl] forState:UIControlStateNormal];
//    self.backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.nameLabel.text = model.Content;
}

- (IBAction)clickAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LearnRecommend" object:self.url];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
