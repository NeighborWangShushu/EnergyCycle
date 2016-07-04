//
//  OtherUserEDPKViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 16/3/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OtherUserEDPKViewController.h"

#import "MineEveryDayOneViewCell.h"
#import "OtherReportModel.h"
#import "GifHeader.h"

@interface OtherUserEDPKViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *_dataArr;
}

@end

@implementation OtherUserEDPKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@的今日PK",self.showTitle];
    
    _dataArr = [[NSMutableArray alloc] init];
    
    EnetgyCycle.energyTabBar.tabBar.translucent = NO;
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    otherUserRecTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    otherUserRecTableView.showsVerticalScrollIndicator = NO;
    otherUserRecTableView.showsHorizontalScrollIndicator = NO;
    
    //
    [self setUpMJRefresh];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    EnetgyCycle.energyTabBar.tabBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    otherUserRecTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithIndexPage];
    }];
    
    [otherUserRecTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [otherUserRecTableView.mj_header endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexPage {
    [[AppHttpManager shareInstance] getGetReportByUserWithUserid:[self.showUserID intValue] Token:@"" OUserId:[self.showUserID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        [_dataArr removeAllObjects];
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"][@"reportItemInfo"]) {
                OtherReportModel *model = [[OtherReportModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            [self endRefresh];
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popViewControllerAnimated:NO];
        }else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
        
        if (!_dataArr.count) {
            [SVProgressHUD showImage:nil status:@"该用户今日无汇报数据"];
        }
        [otherUserRecTableView reloadData];
    } failure:^(NSString *str) {
        [self endRefresh];
        NSLog(@"%@",str);
    }];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MineEveryDayOneViewCellID = @"MineEveryDayOneViewCellID";
    MineEveryDayOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineEveryDayOneViewCellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MineEveryDayOneViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArr.count) {
        OtherReportModel *model = (OtherReportModel *)_dataArr[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.RI_Pic] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
        cell.titleLabel.text = model.RI_Name;
        cell.raceLabel.text = [NSString stringWithFormat:@"%@%@",model.RI_Num,model.RI_Unit];
        cell.paiLabel.text = model.orderNum;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
