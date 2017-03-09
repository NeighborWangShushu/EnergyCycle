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
#import "HistoryPromiseVC.h"
#import "PKGatherViewController.h"
#import "RightNavMenuView.h"
#import "PromiseModel.h"
#import "Masonry.h"

#define kCalendar_HeaderHeight 80

@interface PromiseVC ()<UITableViewDelegate, UITableViewDataSource, RightNavMenuViewDelegate> {
    NSInteger pageIndex;
    NSInteger pageSize;
}

@property (nonatomic, strong) RightNavMenuView *rightNavMenuView; // 右侧菜单栏

@property (nonatomic, strong) NSMutableArray *menuDataArray; // 菜单栏内容

@property (nonatomic, strong) NSMutableArray *dataArray; // 目标列表数据

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PromiseDetailsVC *promiseDetailsVC;

@property (nonatomic, strong) UIButton *explanation;

@end

@implementation PromiseVC

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)menuDataArray {
    if (!_menuDataArray) {
        self.menuDataArray = [NSMutableArray array];
    }
    return _menuDataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    // 重新加载导航视图来去除导航视图底部的横线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNavMenuView];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    
    // 顶部导航栏右侧菜单
    if (!self.rightNavMenuView) {
        self.rightNavMenuView = [[RightNavMenuView alloc] initWithDataArray:self.menuDataArray];
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.rightNavMenuView];
        self.rightNavMenuView.delegate = self;
        [self.rightNavMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@60);
            make.right.equalTo(self.view.mas_right).with.offset(-10);
            make.width.equalTo(@115);
            make.height.equalTo(@(self.menuDataArray.count * 40 + 25));
        }];
    } else {
        [self removeNavMenuView];
    }

}

// 清楚顶部菜单栏
- (void)removeNavMenuView {
    [self.rightNavMenuView removeFromSuperview];
    self.rightNavMenuView = nil;
}

// 创建目标列表
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

// 创建日历视图控制器
- (void)createCalendar {
    
    self.promiseDetailsVC = [[PromiseDetailsVC alloc] init];
    CGFloat pdVC_y = CGRectGetMaxY(self.tableView.frame);
    self.promiseDetailsVC.view.frame = CGRectMake(0, pdVC_y, Screen_width, Screen_Height);
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Screen_width, kCalendar_HeaderHeight)];
    [headerButton addTarget:self action:@selector(changeControllerRect) forControlEvents:UIControlEventTouchUpInside];
    [self.promiseDetailsVC.view addSubview:headerButton];
    [self.view addSubview:self.promiseDetailsVC.view];
    
}

// 奖惩说明
- (void)createExplanationView {
    
    self.explanation = [UIButton buttonWithType:UIButtonTypeCustom];
    self.explanation.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.explanation.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.explanation addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.explanation setImage:[UIImage imageNamed:@"Promise_Explanation_BackgroundImage"] forState:UIControlStateNormal];
    // 取消高亮
    self.explanation.adjustsImageWhenHighlighted = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self.explanation];
    
    UILabel *explanationLabel = [[UILabel alloc] init];
    [self.explanation addSubview:explanationLabel];
    [explanationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.explanation);
        make.centerY.equalTo(self.explanation).with.offset(15);
        make.width.equalTo(@(self.explanation.frame.size.width / 2));
        make.height.equalTo(@(self.explanation.frame.size.height / 2));
    }];
    explanationLabel.textColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    explanationLabel.textAlignment = NSTextAlignmentCenter;
    explanationLabel.font = [UIFont systemFontOfSize:10];
    explanationLabel.numberOfLines = 0;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"公众承诺区目标最低天数：\n5天，低于5天的目标无法设立\n\n完成当日目标，积分奖励政策如下：\n5-10天 10分/天\n11-20天 30分/天\n21天以上 50分/天\n\n若有一天未达成承诺，\n当日及之后的积分均无法获得\n\n任何情况下取消承诺\n将扣除已获得的所有积分，\n并且追加扣除100分作为失信惩罚"];
    NSRange rang = NSMakeRange(13, 14);
    UIColor *redcolor = [UIColor colorWithRed:231/255.0 green:18/255.0 blue:17/255.0 alpha:1];
    [text addAttribute:NSForegroundColorAttributeName value:redcolor range:rang];
    rang = NSMakeRange(45, 37);
    [text addAttribute:NSForegroundColorAttributeName value:redcolor range:rang];
    rang = NSMakeRange(120, 12);
    [text addAttribute:NSForegroundColorAttributeName value:redcolor range:rang];
    explanationLabel.attributedText = text;
    
}

- (void)cancel {
    [self.explanation removeFromSuperview];
}

#pragma mark - 手势动画

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
    
    if (self.rightNavMenuView) {
        [self removeNavMenuView];
    }
    
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
                             self.promiseDetailsVC.indicatorImg.transform = CGAffineTransformMakeScale(1.0, -1.0);
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
                             self.promiseDetailsVC.indicatorImg.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         }
                         completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"公众承诺";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    [self setupRightNavBarWithimage:@"promise_more"];
    [self getData];
    [self getNavMenuData];
    [self createTableView];
    [self createCalendar];
    [self createGestureRecognizer];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    [[AppHttpManager shareInstance] getMyTargetListWithUserID:[User_ID integerValue] Type:1 PageIndex:0 PageSize:100 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            NSDictionary *dataDic = dict[@"Data"];
            for (NSDictionary *dic in dataDic) {
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

- (void)getNavMenuData {
    RightNavMenuModel *model1 = [[RightNavMenuModel alloc] init];
    model1.imageName = @"promise_explanation";
    model1.title = @"奖惩说明";
    
    RightNavMenuModel *model2 = [[RightNavMenuModel alloc] init];
    model2.imageName = @"promise_history";
    model2.title = @"历史目标";
    
    RightNavMenuModel *model3 = [[RightNavMenuModel alloc] init];
    model3.imageName = @"promise_history";
    model3.title = @"PK记录";
    
    [self.menuDataArray addObject:model1];
    [self.menuDataArray addObject:model2];
    [self.menuDataArray addObject:model3];
}

#pragma mark - RightNavMenuViewDelegate

- (void)didSelected:(NSIndexPath *)indexPath {
    [self removeNavMenuView];
    if (indexPath.row == 0) {
        [self createExplanationView];
    } else if (indexPath.row == 1) {
        HistoryPromiseVC *hpVC = [[HistoryPromiseVC alloc] init];
        [self.navigationController pushViewController:hpVC animated:YES];
    } else if (indexPath.row == 2) {
        PKGatherViewController *pkVC = [[PKGatherViewController alloc] init];
        pkVC.isHistory = YES;
        [self.navigationController pushViewController:pkVC animated:YES];
    }
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
