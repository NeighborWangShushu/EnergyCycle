//
//  TheAdvOneViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/9.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TheAdvMainModel.h"

@interface TheAdvOneViewCell : UITableViewCell

//头像iocn
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
//头像点击事件
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


//block
@property (nonatomic, copy) void(^advPKOneShowButtonClick)(NSInteger index);

//填充数据
- (void)updateDataOneWithModel:(TheAdvMainModel *)model;



@end
