//
//  BadgeRulesCollectionViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BadgeRulesCollectionViewCell.h"

@implementation BadgeRulesCollectionViewCell

- (void)updateImageViewWithDays:(NSString *)days flag:(NSString *)flag {
    NSString *string = [NSString stringWithFormat:@"%@signIn_0", days];
//    NSString *string = [NSString stringWithFormat:@"%@signIn_%@", days, flag];
    self.badgeImage.alpha = [flag isEqualToString:@"0"] ? 0.4 : 1;
    [self.badgeImage setImage:[UIImage imageNamed:string]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
