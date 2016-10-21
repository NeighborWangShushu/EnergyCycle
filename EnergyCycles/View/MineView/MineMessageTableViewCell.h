//
//  MineMessageTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetMessageModel.h"

@interface MineMessageTableViewCell : UITableViewCell

// 用户名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// 消息(赞或评论)
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
// 第一张图片
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
// 标题内容
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

- (void)updateDataWithModel:(GetMessageModel *)model;

- (void)noData;

@end
