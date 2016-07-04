//
//  PingLunViewCell.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PingLunViewCell : UITableViewCell

//背景
@property (weak, nonatomic) IBOutlet UIView *backView;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//时间label
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//评论内容
@property (weak, nonatomic) IBOutlet UILabel *neirongLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewBootmAutoLayout;


@end
