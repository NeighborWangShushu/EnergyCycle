//
//  TheAdvTwoViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/9.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TheAdvMainModel.h"

@interface MineTheAdvTwoViewCell : UITableViewCell

//头像iocn
@property (weak, nonatomic) IBOutlet UIButton *icon1Button;
//头像点击事件
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
@property (strong, nonatomic) IBOutlet UIButton *class1Button;

@property (strong, nonatomic) IBOutlet UIImageView *videoImageView;
@property (strong, nonatomic) IBOutlet UILabel *videoTitle;
@property (strong, nonatomic) IBOutlet UILabel *videoContext;
@property (strong, nonatomic) IBOutlet UILabel *videoFrom;
//删除
@property (weak, nonatomic) IBOutlet UIButton *delButton;
- (IBAction)delButtonClick:(UIButton *)sender;

//block
@property (nonatomic, copy) void(^advPKTwoShowButtonClick)(NSInteger index);

//填充数据
- (void)updateDataTwoWithModel:(TheAdvMainModel *)model;

//删除当前
@property (nonatomic, copy) void(^mineThrAdvDelButtonClick)(NSInteger index);



@end
