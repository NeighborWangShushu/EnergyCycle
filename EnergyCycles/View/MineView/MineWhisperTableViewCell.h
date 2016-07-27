//
//  MineWhisperTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MineWhisperTableViewCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// 内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
// 是否未读
@property (weak, nonatomic) IBOutlet UIView *unReadView;
// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

- (void)updateDataWithModel:(MessageModel *)model;

@end
