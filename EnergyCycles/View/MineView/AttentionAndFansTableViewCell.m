//
//  AttentionAndFansTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AttentionAndFansTableViewCell.h"

@implementation AttentionAndFansTableViewCell

- (void)getdateDataWithHeadImage:(NSString *)headImage
                            name:(NSString *)name
                           intro:(NSString *)intro
                     isAttention:(int)isAttention {
    
    // 头像
    if ([headImage isEqualToString:@""]) {
        [self.headImage setImage:[UIImage imageNamed:@"touxiang"]];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:headImage]];
    }
    
    // 姓名
    self.nameLabel.text = name;
    
    // 简介
    self.introLabel.text = intro;
    
}

- (void)getdateDataWithUserModel:(UserModel *)userModel {
    
    // 头像
    if ([userModel.photourl isEqualToString:@""]) {
        [self.headImage setImage:[UIImage imageNamed:@"touxiang"]];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:userModel.photourl]];
    }
    
    // 姓名
    self.nameLabel.text = userModel.nickname;
    
    // 简介
    
    
    // 是否关注
    if ([userModel.isFriend integerValue] == 0) {
        [self.isAttention setImage:[UIImage imageNamed:@"addAttention"] forState:UIControlStateNormal];
    } else {
        [self.isAttention setImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
    }
    
    if ([userModel.use_id isEqualToString:User_ID]) {
        self.isAttention.hidden = YES;
    }
    
    
}

- (void)getdateDataWithOtherUserModel:(OtherUserModel *)otherUserModel {
    
    // 头像
    if ([otherUserModel.photoUrl isEqualToString:@""]) {
        [self.headImage setImage:[UIImage imageNamed:@"touxiang"]];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:otherUserModel.photoUrl]];
    }
    
    // 姓名
    self.nameLabel.text = otherUserModel.nickName;
    
    // 简介
//    if (otherUserModel.) {
//        <#statements#>
//    }
    
    // 是否关注
    if ([otherUserModel.isHeart isEqualToString:@"1"]) {
        [self.isAttention setImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
    } else if ([otherUserModel.isHeart isEqualToString:@"0"]) {
        [self.isAttention setImage:[UIImage imageNamed:@"addAttention"] forState:UIControlStateNormal];
    }
    
    if ([otherUserModel.userId isEqualToString:User_ID]) {
        self.isAttention.hidden = YES;
    }
    
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
