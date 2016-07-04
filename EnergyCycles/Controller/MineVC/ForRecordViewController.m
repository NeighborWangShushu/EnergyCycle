//
//  ForRecordViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ForRecordViewController.h"

#import "RecordDetailViewController.h"

#import "RecordTableViewCell.h"
#import "RecordModel.h"
#import "GifHeader.h"


@interface ForRecordViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_dataArr;
    NSInteger touchIndex;
}

@end

@implementation ForRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"兑换记录";
    _dataArr = [[NSMutableArray alloc] init];
    
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    [self setUpMJRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    forRecordTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithIndex];
    }];

    [forRecordTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [forRecordTableView.mj_header endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndex {
    [[AppHttpManager shareInstance] getGetExchangeRecordListWithUserid:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [_dataArr removeAllObjects];
            for (NSDictionary *subDict in dict[@"Data"]) {
                RecordModel *model = [[RecordModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            [self endRefresh];
            [forRecordTableView reloadData];
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popToRootViewControllerAnimated:NO];
        } else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [self endRefresh];
    }];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 162.f;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *RecordTableViewCellId = @"RecordTableViewCellId";
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordTableViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArr.count) {
        RecordModel *model = (RecordModel *)_dataArr[indexPath.section];
        
        cell.orderNumberLabel.text = model.orderCode;
        cell.orderStateLabel.text = model.orderState;
        cell.jifenLabel.text = model.jifen;
        cell.orderNameLabel.text = model.name;
        
        //
        NSString *expressNameStr = model.expressName;
        if ([model.expressName isKindOfClass:[NSNull class]] || model.expressName == nil || [model.expressName isEqual:[NSNull null]]) {
            expressNameStr = @"";
        }
        NSString *expessCodeStr = model.expressCode;
        if ([model.expressCode isKindOfClass:[NSNull class]] || model.expressCode == nil || [model.expressCode isEqual:[NSNull null]]) {
            expessCodeStr = @"";
        }
        
        if (![expressNameStr isEqualToString:@""] && ![expessCodeStr isEqualToString:@""]) {
            cell.kuaidiLabel.text = [NSString stringWithFormat:@"%@：%@",expressNameStr,expessCodeStr];
        }else {
            cell.kuaidiLabel.text = @"";
        }
        
        NSArray *arr = [model.addTime componentsSeparatedByString:@"T"];
        NSArray *subArr = [arr.firstObject componentsSeparatedByString:@"-"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@/%@/%@",subArr.firstObject,subArr[1],subArr.lastObject];
        
        NSArray *imageArr = [model.img componentsSeparatedByString:@","];
        [cell.orderImageView sd_setImageWithURL:[NSURL URLWithString:imageArr.firstObject]];
    }
    
    return cell;
}

#pragma mark - 跳转界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    touchIndex = indexPath.row;
    [self performSegueWithIdentifier:@"RecordViewToRecordDetaIlView" sender:nil];
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RecordViewToRecordDetaIlView"]) {//跳转到记录详情界面
        RecordDetailViewController *recoDetailVC = segue.destinationViewController;
        if (_dataArr.count) {
            RecordModel *model = (RecordModel *)_dataArr[touchIndex];
            recoDetailVC.recordId = model.recordid;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
