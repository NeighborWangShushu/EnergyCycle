//
//  ECNavMenuCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECNavMenuCell.h"

@implementation ECNavMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setModel:(ECNavMenuModel *)model {
    _model = model;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.selectedIcon setImage:[UIImage imageNamed:@"ec_menu_selected_dot"]];
    }else {
        [self.selectedIcon setImage:nil];
    }
    self.model.isSelected = selected;
    [self.model update];
    // Configure the view for the selected state
}

@end
