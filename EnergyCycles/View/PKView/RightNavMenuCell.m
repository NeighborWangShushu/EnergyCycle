//
//  RightNavMenuCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RightNavMenuCell.h"

@implementation RightNavMenuCell

- (void)getDataWithModel:(RightNavMenuModel *)model {
    
    [self.iconImage setImage:[UIImage imageNamed:model.imageName]];
    
    self.titleLabel.text = model.title;
    
}

- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x, self.frame.size.height - 1, self.frame.size.width, 1);
    line.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.3];
    [self addSubview:line];
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
