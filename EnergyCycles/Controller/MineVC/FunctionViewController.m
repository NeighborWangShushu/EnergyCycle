//
//  FunctionViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FunctionViewController.h"

@interface FunctionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *string;

@end

@implementation FunctionViewController

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"功能介绍";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    self.string.hidden = YES;
    
//    self.string.text = @"能量圈是由上海摩英教育集团打造出品，致力于组建学习，运动型家庭。让每一个家庭成为正能量的传播站！让每一个孩子在自信，感恩，好学的环境中成长成才！新圈子，新起点，新生活，加入能量圈，开启属于您的蜕变之旅！";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, Screen_width - 40, 150)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"能量圈是由上海摩英教育集团打造出品，致力于组建学习，运动型家庭。让每一个家庭成为正能量的传播站！让每一个孩子在自信，感恩，好学的环境中成长成才！新圈子，新起点，新生活，加入能量圈，开启属于您的蜕变之旅！";
    [self.view addSubview:label];
    
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
