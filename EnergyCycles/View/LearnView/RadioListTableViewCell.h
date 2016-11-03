//
//  RadioListTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioModel.h"

@interface RadioListTableViewCell : UITableViewCell

// 电台图片
@property (weak, nonatomic) IBOutlet UIImageView *radioImage;
// 电台名字
@property (weak, nonatomic) IBOutlet UILabel *radioName;
// 电台简介
@property (weak, nonatomic) IBOutlet UILabel *radioIntro;

@property (weak, nonatomic) IBOutlet UIView *RadioPlayAnimation;

// 正在播放/暂停的电台url链接
@property (nonatomic, strong) NSURL *radioUrl;

- (void)getDataWithModel:(RadioModel *)model;

- (void)play;

@end
