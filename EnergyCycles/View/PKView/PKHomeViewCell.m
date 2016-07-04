//
//  PKHomeViewCell.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PKHomeViewCell.h"

@implementation PKHomeViewCell

- (void)awakeFromNib {
    self.touchuButton.layer.borderWidth = 1.f;
    self.touchuButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
