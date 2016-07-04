//
//  NewDetailViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "NewDetailViewController.h"

#import "InformationViewCell.h"
#import "GifHeader.h"

@interface NewDetailViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *_dataArr;
}

@end

@implementation NewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通知详情";
    
    _dataArr = [[NSMutableArray alloc] init];
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    newDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    newDetailTableView.showsVerticalScrollIndicator = NO;
    newDetailTableView.showsHorizontalScrollIndicator = NO;
    
    //
    [self setUpMJRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    EnetgyCycle.isAtInformationView = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    EnetgyCycle.isAtInformationView = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    newDetailTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithIndex];
    }];
    
    [newDetailTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [newDetailTableView.mj_header endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndex {
    [[AppHttpManager shareInstance] getGetMessageDetailWithNotifyId:self.model.NotifyId PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                InformationModel *model = [[InformationModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            [newDetailTableView reloadData];
            [self endRefresh];
        }else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        [self endRefresh];
        NSLog(@"%@",str);
    }];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count) {
        InformationModel *model = (InformationModel *)_dataArr[indexPath.row];
        CGFloat hight = [self textHeightFromTextString:model.NotifyContent width:Screen_width-24 fontSize:15];
        return 50.f + (hight<30?30:hight);
    }
    
    return 50.f + 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *InformationViewCellID = @"InformationViewCellID";
    InformationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InformationViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArr.count) {
        InformationModel *model = (InformationModel *)_dataArr[indexPath.row];
        cell.titleLabel.text = model.NotifyTitle;
        cell.informationLabel.text = model.NotifyContent;
    
        NSArray *timeArr = [model.NotifyTime componentsSeparatedByString:@"T"];
        NSArray *subTimeArr = [timeArr.firstObject componentsSeparatedByString:@"-"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@/%@/%@",subTimeArr.firstObject,subTimeArr[1],subTimeArr.lastObject];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
