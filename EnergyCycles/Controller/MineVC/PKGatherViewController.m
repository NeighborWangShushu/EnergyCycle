//
//  PKGatherViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PKGatherViewController.h"
#import "HMSegmentedControl.h"
#import "BrokenLineViewController.h"

#import "ToDayPKTableViewController.h"
#import "PKRecordTableViewController.h"

#import "ToDayPKTableViewCell.h"
#import "MinePKRecordViewTableViewCell.h"

#import "XMShareView.h"

@interface PKGatherViewController ()<UIScrollViewDelegate> {
    XMShareView *shareView;
    UIBarButtonItem *shareBarButton;
    UIBarButtonItem *postBarButton;
}

@property (nonatomic, strong) ToDayPKTableViewController *todayVC;

@property (nonatomic, strong) PKRecordTableViewController *pkRecordVC;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) HMSegmentedControl *segControl;

@property (nonatomic, assign) BOOL isToDay;

@property (nonatomic, assign) BOOL noData;

@end

@implementation PKGatherViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PKRecordTableViewController" object:self userInfo:@{@"userId" : User_ID}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToDayTableViewController" object:self userInfo:@{@"userId" : User_ID}];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(brokenLineViewController:) name:@"HomePageControllerToBrokenLineViewController" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createScrollView {
    CGRect frame = self.view.bounds;
    frame.origin.y = 40;
    frame.size.height -= 104; // 导航栏的高度加上顶部控件的高度
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    CGSize size = frame.size;
    size.width = size.width * 2;
    self.scrollView.contentSize = size;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    frame = self.scrollView.bounds;
    self.todayVC = [[ToDayPKTableViewController alloc] init];
    self.todayVC.tableView.showsVerticalScrollIndicator = NO;
    self.todayVC.tableView.tableHeaderView = nil;
    self.todayVC.view.frame = frame;
    
    self.pkRecordVC = [[PKRecordTableViewController alloc] init];
    self.pkRecordVC.tableView.showsVerticalScrollIndicator = NO;
    self.pkRecordVC.isMineTableView = YES;
    self.pkRecordVC.tableView.tableHeaderView = nil;
    frame.origin.x += frame.size.width;
    self.pkRecordVC.view.frame = frame;
    
    [self.scrollView addSubview:self.todayVC.view];
    [self.scrollView addSubview:self.pkRecordVC.view];
    
    [self.view addSubview:self.scrollView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSegmentControl];
    [self createScrollView];
    
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    [self createRightButton];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_isHistory) {
        self.segControl.selectedSegmentIndex = 1;
        self.scrollView.contentOffset = CGPointMake(Screen_width, 0);
        self.title = @"历史记录";
        self.isToDay = NO;
        [self removeBarButton];
    } else {
        self.segControl.selectedSegmentIndex = 0;
        self.title = @"每日PK";
        self.isToDay = YES;
        [self addBarButton];
    }
    
    // Do any additional setup after loading the view.
}

- (void)addBarButton {
    self.navigationItem.rightBarButtonItems = @[shareBarButton, postBarButton];
}

- (void)removeBarButton {
    self.navigationItem.rightBarButtonItems = nil;
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)brokenLineViewController:(NSNotification *)notification {
    BrokenLineViewController *brokenVC = notification.object;
    [self.navigationController pushViewController:brokenVC animated:YES];
}

- (void)createRightButton {
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(30, 0, 49, 18);
    [shareButton setImage:[UIImage imageNamed:@"PKGather_Share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(clickShareButton) forControlEvents:UIControlEventTouchUpInside];
    shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake(20, 0, 49, 18);
    [postButton setImage:[UIImage imageNamed:@"PKGather_Posting"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(clickPostButton) forControlEvents:UIControlEventTouchUpInside];
    postBarButton = [[UIBarButtonItem alloc] initWithCustomView:postButton];
    
}

- (void)clickShareButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToDayViewControllerShare" object:nil];
}

- (void)clickPostButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToDayViewControllerPost" object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    [self.segControl setSelectedSegmentIndex:offset.x / Screen_width animated:YES];
    if (!offset.x) {
        self.isToDay = YES;
        self.title = @"每日PK";
        [self addBarButton];
    } else {
        self.isToDay = NO;
        self.title = @"历史记录";
        [self removeBarButton];
    }
}

- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.isToDay = YES;
        self.title = @"每日PK";
        [self addBarButton];
    } else if (sender.selectedSegmentIndex == 1) {
        self.isToDay = NO;
        self.title = @"历史记录";
        [self removeBarButton];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(Screen_width * sender.selectedSegmentIndex, 0);
    }];

}

// 创建分段控件
- (void)createSegmentControl {
    self.segControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 40)];
    self.segControl.sectionTitles = @[@"今日PK                  ",@"PK记录                  "];
    // 横线的高度
    self.segControl.selectionIndicatorHeight = 2.0f;
    // 背景颜色
    self.segControl.backgroundColor = [UIColor whiteColor];
    // 横线的颜色
    self.segControl.selectionIndicatorColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    // 横线在底部出现
    self.segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    // 横线根据文本的长度自适应长度
    self.segControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    // 为选中时的文本样式
    self.segControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:14]};
    // 选中后的文本样式
    self.segControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:242/ 255.0 green:77/255.0 blue:77/255.0 alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:14]};
    // 初始位置
    self.segControl.selectedSegmentIndex = 0;
    // 边界样式
    self.segControl.borderType = HMSegmentedControlBorderTypeBottom;
    // 边界颜色
    self.segControl.borderColor = [UIColor lightGrayColor];
    // 触发方法
    [self.segControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segControl];
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
