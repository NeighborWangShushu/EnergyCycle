//
//  TheAdvOneViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/9.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TheAdvMainModel.h"

@interface MineTheAdvOneViewCell : UITableViewCell

//头像iocn
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
//头像点击事件mineAdvTableView
- (IBAction)iconButtonClick:(UIButton *)sender;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//加载昵称后面小图标
@property (weak, nonatomic) IBOutlet UIImageView *smallIconImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//详细信息
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
//赞
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
//踩
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
//评论
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
//分类button
@property (weak, nonatomic) IBOutlet UIButton *classButton;
//删除
@property (weak, nonatomic) IBOutlet UIButton *delButton;
- (IBAction)delButtonClick:(UIButton *)sender;

//block
@property (nonatomic, copy) void(^advPKOneShowButtonClick)(NSInteger index);

//填充数据
- (void)updateDataOneWithModel:(TheAdvMainModel *)model;

//删除当前
@property (nonatomic, copy) void(^mineOneAdvDelButtonClick)(NSInteger index);


@end
