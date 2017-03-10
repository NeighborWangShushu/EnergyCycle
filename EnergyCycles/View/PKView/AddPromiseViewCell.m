//
//  PromiseViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AddPromiseViewCell.h"

@implementation AddPromiseViewCell

- (void)setup {

    self.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    
    self.containerView.layer.cornerRadius = 10; // 内容视图圆角
//    self.containerView.layer.masksToBounds = YES;
    self.centerButton.layer.cornerRadius = self.centerButton.frame.size.height / 2;
//    self.centerButton.layer.masksToBounds = YES;
    
    self.centerButton.enabled = NO;
    self.centerButton.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
    self.centerButton.layer.shadowOpacity = 0.5;
    self.centerButton.layer.shadowOffset = CGSizeMake(0, 4);
    
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOpacity = 0.5;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
