//
//  AppDelegate.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppTabBarController.h"
#import "EnergyCycleNavController.h"
#import "PKNavController.h"
#import "LearnNavController.h"
#import "MineNavController.h"
#import "ECTabbarViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//TabBar
@property (nonatomic, strong) AppTabBarController *energyTabBar;
//是否进入登录界面
@property (nonatomic, assign) BOOL isEnterLoginView;

//用于添加小红点
@property (nonatomic, strong) MineNavController *mineNavC;
//用于极光注册ID
@property (nonatomic, strong) NSString *appJPushRegisterId;
//是否有推送
@property (nonatomic, assign) BOOL isHaveJPush;
//是否在消息界面
@property (nonatomic, assign) BOOL isAtInformationView;

//音频播放index
@property (nonatomic) NSInteger audioPlayIndex;

@property (nonatomic,strong)ECTabbarViewController*tabbarController;

@end

extern AppDelegate *EnetgyCycle;

