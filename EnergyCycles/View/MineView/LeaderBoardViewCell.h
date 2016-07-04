//
//  LeaderBoardViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"

@interface LeaderBoardViewCell : UITableViewCell

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
- (IBAction)rightButtonClick:(id)sender;

//填充数据
- (void)updateLearderBoardDataWithModel:(UserModel *)model withIndex:(NSInteger)index;



@end
