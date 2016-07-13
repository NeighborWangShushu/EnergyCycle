//
//  MineHomePageViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineHomePageViewController.h"

#import "MineHomePageHeadView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kHeaderImgHeight 226
#define kNavigationHeight 64
#define kSegmentedHeight 40

@interface MineHomePageViewController ()

@property (nonatomic, strong) MineHomePageHeadView *mineView;

@end

@implementation MineHomePageViewController

- (void)addHeadView {
    MineHomePageHeadView *mineView = [[NSBundle mainBundle] loadNibNamed:@"MineHomePageHeadView" owner:nil options:nil].lastObject;
    mineView.frame = CGRectMake(0, 0, kScreenWidth, kHeaderImgHeight + kSegmentedHeight);
    [mineView getdateDataWithImage:self.userInfoDic[@"photourl"] name:self.userInfoDic[@"nickname"] sex:self.userInfoDic[@"sex"] signIn:0 address:self.userInfoDic[@"city"] intro:self.userInfoDic[@"Brief"] attention:0 fans:0];
    self.mineView = mineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addHeadView];
    [self.view addSubview:self.mineView];
    
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
