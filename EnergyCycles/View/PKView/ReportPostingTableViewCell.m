//
//  ReportPostingTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ReportPostingTableViewCell.h"

@implementation ReportPostingTableViewCell

- (IBAction)postAction:(id)sender {
    if (self.onPost) {
        [self.postButton setImage:[UIImage imageNamed:@"offPost"] forState:UIControlStateNormal];
        self.onPost = NO;
    } else {
        [self.postButton setImage:[UIImage imageNamed:@"onPost"] forState:UIControlStateNormal];
        self.onPost = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReportPostSwitch" object:self.onPost ? @"YES" : @"NO"];
}

- (void)updateData {
    self.onPost = NO;
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
