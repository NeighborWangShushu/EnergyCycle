//
//  CCTalkCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CCTalkCell.h"
#import "UIImageView+WebCache.h"


@implementation CCTalkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.img setImage:[UIImage imageNamed:@"cctalk"]];
    
 
}

- (void)setPic:(NSString *)pic {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
