//
//  MineHeadTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface MineHeadTableViewCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIButton *headImage;
// 姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 性别
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
// 签到
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;
// 地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
// 地址图标
@property (weak, nonatomic) IBOutlet UIImageView *addressImage;
// 简介
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
// 简介图标
@property (weak, nonatomic) IBOutlet UIImageView *introImage;
// 简介按钮
@property (weak, nonatomic) IBOutlet UIButton *introButton;
// 简介的位置约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

// 获取数据
- (void)updateDataWithModel:(UserModel *)model
                     signIn:(NSInteger)signIn;
@end
