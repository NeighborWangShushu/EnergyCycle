//
//  MineViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface MineViewController : BaseViewController {
    IBOutlet UITableView *mineTableView;
}

//背景
@property (weak, nonatomic) IBOutlet UIView *headBackView;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *userImageButton;
- (IBAction)userImageButtonClick:(id)sender;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//小图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//关注
@property (weak, nonatomic) IBOutlet UILabel *guanzhuLabel;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuButton;
- (IBAction)guanzhuButtonClick:(UIButton *)sender;

//粉丝
@property (weak, nonatomic) IBOutlet UILabel *fensiLabel;
@property (weak, nonatomic) IBOutlet UIButton *fensiButton;
- (IBAction)fensiButtonClick:(UIButton *)sender;


//能量圈
@property (weak, nonatomic) IBOutlet UIButton *energyCycleButton;
- (IBAction)energyCycleButtonClick:(id)sender;

//每日PK
@property (weak, nonatomic) IBOutlet UIButton *everyDayPKButton;
- (IBAction)everyDayPKButtonClick:(id)sender;

//进阶PK
@property (weak, nonatomic) IBOutlet UIButton *advPKButton;
- (IBAction)advOKButtonClick:(id)sender;

//推荐
@property (weak, nonatomic) IBOutlet UIButton *recommentButton;
- (IBAction)recommentButtonClick:(id)sender;



@end
