//
//  PromiseVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PromiseVC.h"
#import "AddPromiseViewCell.h"
#import "PromiseOngoingViewCell.h"
#import "GifHeader.h"
#import "PromiseDetailsVC.h"
#import "ProjectVC.h"
#import "SinglePromiseDetailsVC.h"
#import "PromiseModel.h"

#define kCalendar_HeaderHeight 80

@interface PromiseVC ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger pageIndex;
    NSInteger pageSize;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PromiseDetailsVC *promiseDetailsVC;

@end

@implementation PromiseVC

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView {
    
    CGRect rect = self.view.bounds;
    rect.size.height -= 64 + kCalendar_HeaderHeight - 15;
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    [self.view addSubview:self.tableView];
    
}

- (void)createCalendar {
    
    self.promiseDetailsVC = [[PromiseDetailsVC alloc] init];
    CGFloat pdVC_y = CGRectGetMaxY(self.tableView.frame);
    self.promiseDetailsVC.view.frame = CGRectMake(0, pdVC_y, Screen_width, Screen_Height);
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Screen_width, kCalendar_HeaderHeight)];
    [headerButton addTarget:self action:@selector(changeControllerRect) forControlEvents:UIControlEventTouchUpInside];
    [self.promiseDetailsVC.view addSubview:headerButton];
    [self.view addSubview:self.promiseDetailsVC.view];
    
}

- (void)createGestureRecognizer {
    
    UISwipeGestureRecognizer *swipe_up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipe_up.numberOfTouchesRequired = 1;
    swipe_up.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer *swipe_down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipe_down.numberOfTouchesRequired = 1;
    swipe_down.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipe_up];
    [self.view addGestureRecognizer:swipe_down];
    
}

- (void)swipeView:(UISwipeGestureRecognizer *)sender {
    [self changeControllerRect];
}

- (void)changeControllerRect {
    CGFloat bottom = CGRectGetMaxY(self.tableView.frame);
    CGFloat top = self.view.bounds.origin.y;
    CGFloat pdVC_y = self.promiseDetailsVC.view.frame.origin.y;
    if (pdVC_y == bottom) {
        [UIView animateWithDuration:0.5 // 动画持续时间
                              delay:0 // 动画延迟执行的时间
             usingSpringWithDamping:0.8 // 震动效果，范围0~1，数值越小震动效果越明显
              initialSpringVelocity:1 // 初始速度，数值越大初始速度越快
                            options:UIViewAnimationOptionLayoutSubviews // 动画的过渡效果
                         animations:^{
                             //执行的动画
                             self.promiseDetailsVC.view.frame = self.view.bounds;
                         }
                         completion:nil];
    } else if (pdVC_y == top) {
        [UIView animateWithDuration:0.5 // 动画持续时间
                              delay:0 // 动画延迟执行的时间
             usingSpringWithDamping:0.8 // 震动效果，范围0~1，数值越小震动效果越明显
              initialSpringVelocity:1 // 初始速度，数值越大初始速度越快
                            options:UIViewAnimationOptionLayoutSubviews // 动画的过渡效果
                         animations:^{
                             //执行的动画
                             self.promiseDetailsVC.view.frame = CGRectMake(0, bottom, Screen_width, Screen_Height);
                         }
                         completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    // 重新加载导航视图来去除导航视图底部的横线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"公众承诺";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    [self getData];
    [self createTableView];
    [self createCalendar];
    [self createGestureRecognizer];
//    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];v
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    [[AppHttpManager shareInstance] getMyTargetListWithUserID:[User_ID integerValue] Type:1 PageIndex:0 PageSize:100 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            NSDictionary *dateDic = dict[@"Data"];
            for (NSDictionary *dic in dateDic) {
                PromiseModel *model = [[PromiseModel alloc] initWithDictionary:dic error:nil];
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.dataArray count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *promiseOngoingViewCell = @"PromiseOngoingViewCell";
        PromiseOngoingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:promiseOngoingViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:promiseOngoingViewCell owner:self options:nil].firstObject;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PromiseModel *model = self.dataArray[indexPath.row];
        [cell getDataWithModel:model];
        
        return cell;
        
    } else {
        static NSString *addPromiseViewCell = @"AddPromiseViewCell";
        AddPromiseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addPromiseViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:addPromiseViewCell owner:self options:nil].firstObject;
        }
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [cell setup];
        
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PromiseModel *model = self.dataArray[indexPath.row];
        SinglePromiseDetailsVC *spdVC = [[SinglePromiseDetailsVC alloc] init];
        spdVC.targetID = [model.TargetID integerValue];
        spdVC.model = model;
        [self.navigationController pushViewController:spdVC animated:YES];
    } else if (indexPath.section == 1) {
        ProjectVC *pVC = [[ProjectVC alloc] init];
        [self.navigationController pushViewController:pVC animated:YES];
    }
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
