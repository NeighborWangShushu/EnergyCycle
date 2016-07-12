//
//  MineHomePageViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineHomePageViewController.h"

@interface MineHomePageViewController ()

// 背景图
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
// 头像
@property (weak, nonatomic) IBOutlet UIButton *iconImage;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
// 性别
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
// 地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
// 地址图标
@property (weak, nonatomic) IBOutlet UIImageView *addressImage;
// 关注
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
// 粉丝
@property (weak, nonatomic) IBOutlet UIButton *fansButton;
// 简介
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
// 位置约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@end

@implementation MineHomePageViewController

- (void)getdateDataWithDic:(NSDictionary *)dic {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
