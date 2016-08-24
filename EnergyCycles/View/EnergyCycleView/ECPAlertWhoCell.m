//
//  ECPAlertWhoCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECPAlertWhoCell.h"

@implementation ECPAlertWhoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)alertAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didSelected)]) {
        [self.delegate didSelected];
    }
}
@end
