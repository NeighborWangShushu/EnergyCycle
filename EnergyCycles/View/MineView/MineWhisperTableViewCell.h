//
//  MineWhisperTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineWhisperTableViewCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// 内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
