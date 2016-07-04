//
//  AddressTableViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)rightButtonClick:(id)sender {
    self.inputTextView.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
