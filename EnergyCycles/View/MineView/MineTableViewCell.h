//
//  MineTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface MineTableViewCell : UITableViewCell

// 图标
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
// 选项
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
// 数量
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
// 右侧图标
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
// 退出登录
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

- (void)updateDataWithSection:(NSInteger)section
                        index:(NSInteger)index
                userInfoModel:(UserInfoModel *)userInfoModel;

@end
