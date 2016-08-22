//
//  DraftTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/8/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraftsModel.h"

@interface DraftTableViewCell : UITableViewCell

// 最后修改时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// 第一张图片
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
// 内容
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;
// 重发按钮
@property (weak, nonatomic) IBOutlet UIButton *retryButton;
// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

- (void)getDraftsData:(DraftsModel *)model;

@end
