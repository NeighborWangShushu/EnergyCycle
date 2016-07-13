//
//  MineHomePageHeadView.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineHomePageHeadView : UIView

// 头像
@property (weak, nonatomic) IBOutlet UIButton *headImage;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
// 性别
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
// 地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
// 地址图标
@property (weak, nonatomic) IBOutlet UIImageView *addressImage;
// 签到
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
// 签到(没有地址数据时显示)
@property (weak, nonatomic) IBOutlet UILabel *signTwoLabel;
// 关注
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
// 粉丝
@property (weak, nonatomic) IBOutlet UIButton *fansButton;
// 简介
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

- (void)getdateDataWithImage:(NSString *)image
                        name:(NSString *)name
                         sex:(NSString *)sex
                      signIn:(NSInteger)signIn
                     address:(NSString *)address
                       intro:(NSString *)intro
                   attention:(NSInteger)attention
                        fans:(NSInteger)fans;

@end
