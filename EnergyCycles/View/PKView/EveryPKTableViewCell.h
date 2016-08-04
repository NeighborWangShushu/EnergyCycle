//
//  EveryPKTableViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EveryDPKPMModel.h"

@interface EveryPKTableViewCell : UITableViewCell

@property (nonatomic, strong) void(^zanButtonClick)(NSInteger index);

//排名
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
//
@property (weak, nonatomic) IBOutlet UIButton *leftButton;

//头像
@property (weak, nonatomic) IBOutlet UIButton *headButton;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//记录
@property (weak, nonatomic) IBOutlet UILabel *jiluLabel;
//
@property (weak, nonatomic) IBOutlet UIProgressView *lingProgressView;
//赞总数
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
//赞
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
- (IBAction)rightButtonClick:(UIButton *)sender;

//填充数据
- (void)updateEveryDayPKDataWithIndex:(NSInteger)index withModel:(EveryDPKPMModel *)model;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withRightAutoLayout;
//@property (weak, nonatomic) IBOutlet UIImageView *withImageView;

@property (weak, nonatomic) IBOutlet UIImageView *pkEveryBackImageView;


@end
