//
//  MineHomePageHeadView.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineHomePageHeadView.h"
#import "UIImage+Category.h"

@implementation MineHomePageHeadView

- (void)tap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.backgroundImage addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    NSLog(@"aa");
}

- (void)getdateDataWithBackgroundImage:(NSString *)backgroundImage
                             headImage:(NSString *)headImage
                                  name:(NSString *)name
                                   sex:(NSString *)sex
                                signIn:(NSInteger)signIn
                               address:(NSString *)address
                                 intro:(NSString *)intro
                             attention:(NSInteger)attention
                                  fans:(NSInteger)fans {
    

    
    
    
    // 头像
    if ([headImage isEqualToString:@""]) {
        [self.headImage setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:headImage] forState:UIControlStateNormal];
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
    [self.attentionButton setTitle:[NSString stringWithFormat:@"关注 %ld",attention] forState:UIControlStateNormal];
    
    // 粉丝
    [self.fansButton setTitle:[NSString stringWithFormat:@"粉丝 %ld", fans] forState:UIControlStateNormal];
    
    // 简介
    if ([intro isEqualToString:@""]) {
        self.introLabel.text = @"简介:暂无";
    } else {
        self.introLabel.text = [NSString stringWithFormat:@"简介:%@", intro];
    }
    
    // 背景
    if ([backgroundImage isEqualToString:@""]) {
        [self.backgroundImage setImage:[UIImage imageNamed:@"bg"]];
    } else {
        [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:backgroundImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (self.backgroundImage.image.size.height >= 452) {
                self.backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
            }
            if (self.backgroundImage.image.size.width >= 375) {
                self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
            }
        }];
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
