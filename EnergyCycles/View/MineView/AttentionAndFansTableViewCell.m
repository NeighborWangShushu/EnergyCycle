//
//  AttentionAndFansTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AttentionAndFansTableViewCell.h"

@implementation AttentionAndFansTableViewCell

- (void)getdateAttentionDataWithUserModel:(UserModel *)userModel {
    
    // 用户ID
    self.userid = userModel.use_id;
    
    // 头像
    if ([userModel.photourl isEqualToString:@""] || userModel.photourl == nil) {
        [self.headImage setImage:[UIImage imageNamed:@"touxiang"]];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:userModel.photourl]];
    }
    
    // 姓名
    self.nameLabel.text = userModel.nickname;
    
    // 简介
    if (userModel.Brief == NULL || [userModel.Brief isEqualToString:@""]) {
        self.introLabel.text = @"暂未设置简介";
    } else {
        self.introLabel.text = userModel.Brief;
    }
    
    // 是否关注
    [self.isAttention setImage:[UIImage imageNamed:@"attentionButton"] forState:UIControlStateNormal];
    
    self.attention = YES;
    
    if ([userModel.use_id isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
        self.isAttention.hidden = YES;
    }
    
    [self lineView];
    
}

- (void)getdateFansDataWithUserModel:(UserModel *)userModel {
    
    // 用户ID
    self.userid = userModel.use_id;
    
    // 头像
    if ([userModel.photourl isEqualToString:@""] || userModel.photourl == nil) {
        [self.headImage setImage:[UIImage imageNamed:@"touxiang"]];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:userModel.photourl]];
    }
    
    // 姓名
    self.nameLabel.text = userModel.nickname;
    
    // 简介
    if (userModel.Brief == NULL || [userModel.Brief isEqualToString:@""]) {
        self.introLabel.text = @"暂未设置简介";
    } else {
        self.introLabel.text = userModel.Brief;
    }
    
    // 是否关注
    if ([userModel.isFriend isEqualToString:@"0"]) {
        [self.isAttention setImage:[UIImage imageNamed:@"addAttentionButton"] forState:UIControlStateNormal];
        self.attention = NO;
    } else {
        [self.isAttention setImage:[UIImage imageNamed:@"attentionButton"] forState:UIControlStateNormal];
        self.attention = YES;
    }
    
    if ([userModel.use_id isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
        self.isAttention.hidden = YES;
    }
    
    [self lineView];
}

- (void)getdateDataWithOtherUserModel:(OtherUserModel *)otherUserModel {
    
    // 用户ID
    self.userid = otherUserModel.userId;
    
    // 头像
    if ([otherUserModel.photoUrl isEqualToString:@""] || otherUserModel.photoUrl == nil) {
        [self.headImage setImage:[UIImage imageNamed:@"touxiang"]];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:otherUserModel.photoUrl]];
    }
    
    // 姓名
    self.nameLabel.text = otherUserModel.nickName;
    
    // 简介
    if (otherUserModel.Brief == NULL || [otherUserModel.Brief isEqualToString:@""]) {
        self.introLabel.text = @"暂未设置简介";
    } else {
        self.introLabel.text = otherUserModel.Brief;
    }
    
    // 是否关注
    if ([otherUserModel.isHeart isEqualToString:@"1"]) {
        [self.isAttention setImage:[UIImage imageNamed:@"attentionButton"] forState:UIControlStateNormal];
        self.attention = YES;
    } else if ([otherUserModel.isHeart isEqualToString:@"0"]) {
        [self.isAttention setImage:[UIImage imageNamed:@"addAttentionButton"] forState:UIControlStateNormal];
        self.attention = NO;
    }
    
    if ([otherUserModel.userId isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
        self.isAttention.hidden = YES;
    }
    
    [self lineView];
}

- (IBAction)attentionButton:(id)sender {
    if (self.attention == YES) {
        [[AppHttpManager shareInstance] getAddOrCancelFriendWithType:2 UserId:[User_ID intValue] Token:User_TOKEN OUserId:[self.userid intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"已取消关注" maskType:SVProgressHUDMaskTypeClear];
                self.attention = NO;
                [self.isAttention setImage:[UIImage imageNamed:@"addAttentionButton"] forState:UIControlStateNormal];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@", str);
        }];
    } else {
        [[AppHttpManager shareInstance] getAddOrCancelFriendWithType:1 UserId:[User_ID intValue] Token:User_TOKEN OUserId:[self.userid intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"关注成功" maskType:SVProgressHUDMaskTypeClear];
                self.attention = YES;
                [self.isAttention setImage:[UIImage imageNamed:@"attentionButton"] forState:UIControlStateNormal];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@", str);
        }];
    }
}

- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x + 17, self.frame.size.height - 1, self.frame.size.width + 50, 1);
    line.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    [self.contentView addSubview:line];
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
