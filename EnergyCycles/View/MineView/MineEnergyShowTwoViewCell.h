//
//  EnergyShowTwoViewCell.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EnergyCycleShowCellModel.h"
#import "EnergyMainModel.h"
@interface MineEnergyShowTwoViewCell : UITableViewCell

//头像iocn
@property (weak, nonatomic) IBOutlet UIButton *icon1Button;
- (IBAction)icon1ButtonClick:(UIButton *)sender;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickname1Label;
//时间
@property (weak, nonatomic) IBOutlet UILabel *time1Label;
//加载昵称后面小图标
@property (weak, nonatomic) IBOutlet UIImageView *smallIcon1ImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *title1Label;
//详细信息
@property (weak, nonatomic) IBOutlet UILabel *information1Label;
//赞
@property (weak, nonatomic) IBOutlet UIButton *zan1Button;
//踩
@property (weak, nonatomic) IBOutlet UIButton *cai1Button;
//评论
@property (weak, nonatomic) IBOutlet UIButton *comment1Button;
//删除
@property (weak, nonatomic) IBOutlet UIButton *del1Button;
- (IBAction)del1ButtonClick:(UIButton *)sender;
//置顶
@property (weak, nonatomic) IBOutlet UILabel *dingLabel;


@property (strong, nonatomic) IBOutlet UIImageView *videoImage;
@property (strong, nonatomic) IBOutlet UILabel *videoTitle;
@property (strong, nonatomic) IBOutlet UILabel *videoContent;
@property (strong, nonatomic) IBOutlet UILabel *videoFrom;

//block
@property (nonatomic, copy) void(^energyShowTwoButtonClick)(NSInteger index);

//填充数据
- (void)updateDataTwoWithModel:(EnergyMainModel *)model;

//删除当前
@property (nonatomic, copy) void(^mineTwoEnergyDelButtonClick)(NSInteger index);



@end
