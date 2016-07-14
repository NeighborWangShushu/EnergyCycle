//
//  tabbarViewController.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "ECTabbarViewController.h"
#import "TabbarView.h"
#import "Masonry.h"
#import "LoginNavController.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)
#define addHeight 88


@interface ECTabbarViewController ()<ECTabbarDelegate>


@property (nonatomic,strong)TabbarView*tabbar;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selctedIndex = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarConToLoginView:) name:@"AllVCNotificationTabBarConToLoginView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isLoginViewBackButtonClick:) name:@"isLoginViewBackButtonClick" object:nil];

	// Do any additional setup after loading the view, typically from a nib.
    _tabbar = [[TabbarView alloc]initWithFrame:CGRectZero];
    _tabbar.delegate = self;
    [self.view addSubview:_tabbar];
    
    [_tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@60);
    }];
    
    _arrayViewcontrollers = [self getViewcontrollers];
    [self touchBtnAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedIndex:(NSInteger)index {
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
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    NSLog(@"view subviews:%ld",[self.view.subviews count]);
    
    NSDictionary* data = [_arrayViewcontrollers objectAtIndex:index];
    
    UIViewController *viewController = data[@"viewController"];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height- 50);
    
    [self.view insertSubview:viewController.view belowSubview:_tabbar];
    
}

-(NSArray *)getViewcontrollers
{
    NSArray* tabBarItems = nil;
    
    UINavigationController *first = MainStoryBoard(@"EnergyCycleNavController");
    
    UIViewController *second = MainStoryBoard(@"PKNavController");
    
    UIViewController *three = MainStoryBoard(@"LearnNavController");

    UIViewController *four = MainStoryBoard(@"MineNavController");

    
    tabBarItems = [NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_normal_1", @"image",@"tabbar_pressed_1", @"image_locked", first, @"viewController",@"能量圈",@"title", nil],
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
