//
//  MineHeadViewTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/8/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface MineHeadViewTableViewCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIButton *headImage;
// 徽章
@property (weak, nonatomic) IBOutlet UIButton *subscriptBadge;
// 背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
// 姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 性别
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
// 积分
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
// 地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
// 地址图标
@property (weak, nonatomic) IBOutlet UIImageView *addressImage;

- (void)updateDataWithModel:(UserModel *)model;

@end
