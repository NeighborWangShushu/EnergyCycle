//
//  MineHomePageHeadView.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineHomePageHeadView.h"

@implementation MineHomePageHeadView

- (void)getdateDataWithImage:(NSString *)image
                        name:(NSString *)name
                         sex:(NSString *)sex
                      signIn:(NSInteger)signIn
                     address:(NSString *)address
                       intro:(NSString *)intro
                   attention:(NSInteger)attention
                        fans:(NSInteger)fans {
    
    // 头像
    if ([image isEqualToString:@""]) {
        [self.headImage setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:image] forState:UIControlStateNormal];
    }
    
    // 昵称
    self.nicknameLabel.text = name;
    
    // 性别
    if ([sex isEqualToString:@"男"]) {
        self.sexImage.image = [UIImage imageNamed:@"man"];
    } else if ([sex isEqualToString:@"女"]) {
        self.sexImage.image = [UIImage imageNamed:@"woman"];
    } else {
        self.sexImage.image = [UIImage imageNamed:@""];
    }
    
    // 地址
    if ([address isEqualToString:@""]) {
        self.addressImage.hidden = YES;
        self.addressLabel.hidden = YES;
        self.signLabel.hidden = YES;
        if (signIn == 0) {
            self.constraint.constant = 12;
        }
    }
    
    // 签到
    if (signIn == 0) {
        self.signLabel.hidden = YES;
    } else {
        self.signLabel.text = [NSString stringWithFormat:@"连续签到%ld天",signIn];
        self.signTwoLabel.text = self.signLabel.text;
    }
    
    // 关注
    self.attentionButton.titleLabel.text = [NSString stringWithFormat:@"关注&nbsp;%ld",attention];
    self.attentionButton.titleLabel.text = @"adf";
    
    // 粉丝
    self.fansButton.titleLabel.text = [NSString stringWithFormat:@"粉丝&nbsp;%ld", fans];
    
    // 简介
    if ([intro isEqualToString:@""]) {
        self.introLabel.text = @"简介:暂无";
    } else {
        self.introLabel.text = [NSString stringWithFormat:@"简介:%@", intro];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
