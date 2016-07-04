//
//  TheAdvThrViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/9.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TheAdvMainModel.h"

@interface TheAdvThrViewCell : UITableViewCell

//头像iocn
@property (weak, nonatomic) IBOutlet UIButton *icon2Button;
//头像点击事件
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

@property (strong, nonatomic) IBOutlet UIButton *class2Button;
//block
@property (nonatomic, copy) void(^advPKThrShowButtonClick)(NSInteger index);

//填充数据
- (void)updateDataThrWithModel:(TheAdvMainModel *)model;


@end
