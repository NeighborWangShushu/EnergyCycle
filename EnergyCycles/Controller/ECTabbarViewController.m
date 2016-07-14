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

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)
#define addHeight 88


@interface ECTabbarViewController ()<ECTabbarDelegate>


@property (nonatomic,strong)TabbarView*tabbar;
@end

@implementation ECTabbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

-(void)touchBtnAtIndex:(NSInteger)index
{
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    NSDictionary* data = [_arrayViewcontrollers objectAtIndex:index];
    
    UIViewController *viewController = data[@"viewController"];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height- 50);
    
    [self.view insertSubview:viewController.view belowSubview:_tabbar];
    
}

-(NSArray *)getViewcontrollers
{
    NSArray* tabBarItems = nil;
    
    UIViewController *first = [[UIViewController alloc]init];
    
    UIViewController *second = [[UIViewController alloc]init];
    
    tabBarItems = [NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_normal_1", @"image",@"tabbar_pressed_1", @"image_locked", first, @"viewController",@"能量圈",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_normal_2", @"image",@"tabbar_pressed_2", @"image_locked", second, @"viewController",@"PK",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_normal_3", @"image",@"tabbar_pressed_3", @"image_locked", second, @"viewController",@"学习",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_normal_4", @"image",@"tabbar_pressed_4", @"image_locked", second, @"viewController",@"我的",@"title", nil],nil];
    return tabBarItems;
    
}

@end
