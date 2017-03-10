//
//  tabbarViewController.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "ECTabbarViewController.h"
#import "ECTabbarView.h"
#import "Masonry.h"
#import "LoginNavController.h"
#import "AppDelegate.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)
#define addHeight 88


@interface ECTabbarViewController ()<ECTabbarDelegate> {
    UIViewController *viewController;
    
}

@property (nonatomic,strong)ECTabbarView*tabbar;


@end

@implementation ECTabbarViewController

#pragma mark - 单例
+ (ECTabbarViewController *)shareInstance {
    static ECTabbarViewController *shareNetworkMessage = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareNetworkMessage = [[self alloc] init];
    });
    
    return shareNetworkMessage;
}

- (void)hideTabbar:(BOOL)hide {
    if (hide) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.tabbar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left);
                make.right.equalTo(self.view.mas_right);
                make.bottom.equalTo(self.view.mas_bottom).with.offset(75);
                make.height.equalTo(@43);
            }];
            
            [viewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left);
                make.right.equalTo(self.view.mas_right);
                make.top.equalTo(self.view.mas_top);
                make.bottom.equalTo(_tabbar.mas_top).with.offset(-30);
                
            }];
            [self.tabbar layoutIfNeeded];
        }];
        
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            [self.tabbar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left);
                make.right.equalTo(self.view.mas_right);
                make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
                make.height.equalTo(@43);
            }];
            
            [self.tabbar layoutIfNeeded];
        }];
        [viewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(_tabbar.mas_top).with.offset(0);
            
        }];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate*delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.tabbarController = self;
    
    self.selctedIndex = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarConToLoginView:) name:@"AllVCNotificationTabBarConToLoginView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isLoginViewBackButtonClick:) name:@"isLoginViewBackButtonClick" object:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
    _tabbar = [[ECTabbarView alloc]initWithFrame:CGRectZero];
    _tabbar.delegate = self;
    [self.view addSubview:_tabbar];
    
    [_tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@40);
    }];
    
    _arrayViewcontrollers = [self getViewcontrollers];
    [self touchBtnAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectIndex:(NSInteger)index {
    [self touchBtnAtIndex:index];
}

- (void)isLoginViewBackButtonClick:(NSNotification*)notifi {
    if (self.selctedIndex == 3) {
        [_tabbar setSelectedIndex:0];
    }
}

-(void)touchBtnAtIndex:(NSInteger)index
{
    if (self.selctedIndex == index) {
        return;
    }
    self.selctedIndex = index;
    [_tabbar setSelectedIndex:index];
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    NSDictionary* data = [_arrayViewcontrollers objectAtIndex:index];
    
    viewController = data[@"viewController"];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    
    [self.view insertSubview:viewController.view belowSubview:_tabbar];
    
    [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(_tabbar.mas_top).with.offset(0);
        
    }];
    
}

-(NSArray *)getViewcontrollers
{
    NSArray* tabBarItems = nil;
    
    UINavigationController *first = MainStoryBoard(@"EnergyCycleNavController");
    
    UIViewController *second = MainStoryBoard(@"PKNavController");
    
    UIViewController *three = MainStoryBoard(@"LearnNavController");

    UIViewController *four = MainStoryBoard(@"MineNavController");

    
    tabBarItems = [NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_normal_1", @"image",@"tabbar_pressed_1", @"image_locked", first, @"viewController",@"能量帖",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_normal_2", @"image",@"tabbar_pressed_2", @"image_locked", second, @"viewController",@"PK",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_normal_3", @"image",@"tabbar_pressed_3", @"image_locked", three, @"viewController",@"学习",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_normal_4", @"image",@"tabbar_pressed_4", @"image_locked", four, @"viewController",@"我的",@"title", nil],nil];
    return tabBarItems;
    
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

@end
