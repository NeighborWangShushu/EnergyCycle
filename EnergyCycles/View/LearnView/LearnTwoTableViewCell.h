//
//  LearnTwoTableViewCell.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"

@interface LearnTwoTableViewCell : UITableViewCell

//
@property (nonatomic, copy) void(^learnCellTouchuZan)(NSInteger cellIndex);

//排名
@property (weak, nonatomic) IBOutlet UIImageView *leftLearnImageView;
//
@property (weak, nonatomic) IBOutlet UIButton *leftLearnButton;

//头像
@property (weak, nonatomic) IBOutlet UIButton *headLearnButton;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLearnLabel;
//记录
@property (weak, nonatomic) IBOutlet UILabel *jiluLearnLabel;
//
@property (weak, nonatomic) IBOutlet UIProgressView *lingLearnProgressView;
//赞
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
- (IBAction)rightButtonClick:(UIButton *)sender;

//填充数据
- (void)updateEveryDayPKDataWithIndex:(NSInteger)index withModel:(UserModel *)model;


@end
