//
//  DraftTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DraftTableViewCell.h"

@implementation DraftTableViewCell

- (void)getDraftsData:(DraftsModel *)model {
    
    self.timeLabel.text = model.time;
    
    if (model.imageArr == nil) {
        self.constraint.constant = 12;
        self.headImage.hidden = YES;
    } else {
        [self.headImage setImage:model.imageArr.firstObject];
    }
    
    self.contextLabel.text = model.context;
    
}

- (IBAction)retryAction:(id)sender {
    
    
    
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