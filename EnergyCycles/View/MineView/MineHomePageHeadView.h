//
//  MineHomePageHeadView.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "UserModel.h"
#import "UserInfoModel.h"

@interface MineHomePageHeadView : UIView

// 背景
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
// 左侧背景按钮
@property (weak, nonatomic) IBOutlet UIButton *leftBackgroundButton;
// 右侧背景按钮
@property (weak, nonatomic) IBOutlet UIButton *rightBackgroundButton;
// 头像
@property (weak, nonatomic) IBOutlet UIButton *headImage;
// 徽章
@property (weak, nonatomic) IBOutlet UIButton *subscriptBadge;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
// 性别
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
// 地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
// 地址图标
@property (weak, nonatomic) IBOutlet UIImageView *addressImage;
// 关注
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
// 粉丝
@property (weak, nonatomic) IBOutlet UIButton *fansButton;
// 简介
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
// 简介图标
@property (weak, nonatomic) IBOutlet UIImageView *introImage;
// 简介按钮
@property (weak, nonatomic) IBOutlet UIButton *introButton;
// 内部控件约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
// 分段控件
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segControl;
// 下拉动效约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundImageHeight;

@property (nonatomic, strong) UserModel *model;

// 获取数据
- (void)getdateDataWithModel:(UserModel *)model userInfoModel:(UserInfoModel *)userInfoModel;
@end
