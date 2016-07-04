//
//  EnergyShowThreeViewCell.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EnergyMainModel.h"

@interface EnergyShowThreeViewCell : UITableViewCell

//头像iocn
@property (weak, nonatomic) IBOutlet UIButton *icon2Button;
- (IBAction)icon2ButtonClick:(UIButton *)sender;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickname2Label;
//时间
@property (weak, nonatomic) IBOutlet UILabel *time2Label;
//加载昵称后面小图标
@property (weak, nonatomic) IBOutlet UIImageView *smallIcon2ImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
//详细信息
@property (weak, nonatomic) IBOutlet UILabel *information2Label;
//赞
@property (weak, nonatomic) IBOutlet UIButton *zan2Button;
//踩
@property (weak, nonatomic) IBOutlet UIButton *cai2Button;
//评论
@property (weak, nonatomic) IBOutlet UIButton *comment2Button;
//置顶
@property (weak, nonatomic) IBOutlet UILabel *dingLabel;


//block
@property (nonatomic, copy) void(^energyShowThreeButtonClick)(NSInteger index);

//填充数据
- (void)updateDataThreeWithModel:(EnergyMainModel *)model;


@end
