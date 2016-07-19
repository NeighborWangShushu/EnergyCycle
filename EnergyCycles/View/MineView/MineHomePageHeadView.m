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
- (IBAction)changeHeadImage:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"headViewChangeHeadImage" object:nil];
}

- (IBAction)jumpToAttentionController:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToAttentionController" object:nil];
}

- (IBAction)jumpToFansController:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToFansController" object:nil];
}

- (IBAction)jumpToIntroViewController:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToIntroViewController" object:nil];
}

- (void)getdateDataWithModel:(UserModel *)model signIn:(NSInteger)signIn attention:(NSInteger)attention fans:(NSInteger)fans {
    // 背景
    if (model.BackgroundImg == NULL) {
        [self.backgroundImage setImage:[UIImage imageNamed:@"bg"]];
    } else {
        [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:model.BackgroundImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (self.backgroundImage.image.size.height >= 452) {
                self.backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
            }
            if (self.backgroundImage.image.size.width >= 375) {
                self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
            }
        }];
    }
    
    // 头像
    if (model.photourl == NULL) {
        [self.headImage setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.photourl] forState:UIControlStateNormal];
    }
    
    // 昵称
    self.nicknameLabel.text = model.nickname;
    
    // 性别
    if ([model.sex isEqualToString:@"男"]) {
        self.sexImage.image = [UIImage imageNamed:@"man"];
    } else if ([model.sex isEqualToString:@"女"]) {
        self.sexImage.image = [UIImage imageNamed:@"woman"];
    } else {
        self.sexImage.image = [UIImage imageNamed:@""];
    }
    
    // 地址
    if (model.city == NULL) {
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
    if (model.Brief == NULL) {
        self.introLabel.text = @"简介:暂无";
    } else {
        self.introLabel.text = [NSString stringWithFormat:@"简介:%@", model.Brief];
    }
    
    NSNumberFormatter *number = [[NSNumberFormatter alloc] init];
    if ([model.use_id isEqualToString:[number stringFromNumber:User_ID]]) {
        self.introImage.hidden = NO;
        self.introButton.hidden = NO;
    } else {
        self.introImage.hidden = YES;
        self.introButton.hidden = YES;
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
