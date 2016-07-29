//
//  AppTabBarController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AppTabBarController.h"

#import "EnergyCycleNavController.h"
#import "PKNavController.h"
#import "LearnNavController.h"
#import "MineNavController.h"

#import "LoginNavController.h"

@interface AppTabBarController () {
    BOOL _isEnterYanZheng;
}

@end

@implementation AppTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加消息中心,进入登录界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarConToLoginView:) name:@"AllVCNotificationTabBarConToLoginView" object:nil];
    
    EnetgyCycle.energyTabBar = self;
    EnergyCycleNavController *energyNavVC = (EnergyCycleNavController *)self.viewControllers[0];
    [self setTabBarWithItem:energyNavVC.energyCycleItem withTag:0];
    
    PKNavController *pkNavVC = (PKNavController *)self.viewControllers[1];
    [self setTabBarWithItem:pkNavVC.pKItem withTag:1];
    
    LearnNavController *learnNavVC = (LearnNavController *)self.viewControllers[2];
    [self setTabBarWithItem:learnNavVC.learnItem withTag:2];
    
    MineNavController *mineNavVC = (MineNavController *)self.viewControllers[3];
    [self setTabBarWithItem:mineNavVC.mineItem withTag:3];
    EnetgyCycle.mineNavC = mineNavVC;
    
    //设置navigation
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backImage = [UIImage imageNamed:@"whiteback_normal.png"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backImage.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];
    UIOffset offSet;
    offSet.horizontal = 0;
    offSet.vertical = -50;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:offSet forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - private methods
- (void)setTabBarWithItem:(UITabBarItem *)item withTag:(int)tag {
    [self settitleWithItem:item withTag:tag];
    [self settabBarItemImage:item withTag:tag];
    
    //设置背景颜色
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
}

#pragma mark - 设置标题
- (void)settitleWithItem:(UITabBarItem *)item withTag:(int)tag {
    NSString *titleStr = @"";
    switch (tag) {
        case 0:
            titleStr = @"能量圈";
            break;
        case 1:
            titleStr = @"PK";
            break;
        case 2:
            titleStr = @"学习";
            break;
        case 3:
            titleStr = @"我的";
            break;
        default:
            break;
    }
    item.title = titleStr;
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.5],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.5],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
}

#pragma mark - 设置图片
- (void)settabBarItemImage:(UITabBarItem *)item withTag:(int)tag {
    UIImage *nImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_pressed_%d.png",tag+1]];
    nImage = [nImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_normal_%d.png",tag+1]];
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [item setImage:[nImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setSelectedImage:[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

#pragma mark - 消息中心判断是否进入登录界面
- (void)tabBarConToLoginView:(NSNotification *)notification {
    if ([notification object] != nil) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"账号异常"];
        if ([[[notification object] objectForKey:@"Code"] integerValue] == 109) {
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"账号不存在"];
        }
    }else {
        [SVProgressHUD dismiss];
    }
    if (EnetgyCycle.isEnterLoginView == NO) {
        LoginNavController *loginNav = MainStoryBoard(@"loginNav");
        [self presentViewController:loginNav animated:YES completion:nil];
        EnetgyCycle.isEnterLoginView = YES;
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
