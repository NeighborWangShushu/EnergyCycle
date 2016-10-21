//
//  RecordDetailViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "RecordDetailViewController.h"

#import "RecordTableViewCell.h"
#import "RecordDetailViewCell.h"
#import "RecordModel.h"
#import "GifHeader.h"

@interface RecordDetailViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *_dataArr;
}

@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [[NSMutableArray alloc] init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    self.title = @"记录详情";
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    [self setUpMJRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    recordDetailTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithIndex];
    }];
    
    [recordDetailTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [recordDetailTableView.mj_header endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndex {
    [[AppHttpManager shareInstance] getGetExchangeRecordListWithRecordid:[self.recordId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                RecordModel *model = [[RecordModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            [self endRefresh];
            [recordDetailTableView reloadData];
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
        }

    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [self endRefresh];
    }];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 3;
    }else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 162.f;
    }else {
        return 40.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *RecordTableViewCellId = @"RecordTableViewCellId";
        RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordTableViewCellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_dataArr.count) {
            if (indexPath.section == 0) {
                RecordModel *model = (RecordModel *)_dataArr[0];
                
                cell.orderNumberLabel.text = model.  orderCode;
                cell.orderStateLabel.text = model.orderState;
                cell.jifenLabel.text = model.jifen;
                cell.orderNameLabel.text = model.name;
                
                NSArray *arr = [model.addTime componentsSeparatedByString:@"T"];
                NSArray *subArr = [arr.firstObject componentsSeparatedByString:@"-"];
                cell.timeLabel.text = [NSString stringWithFormat:@"%@/%@/%@",subArr.firstObject,subArr[1],subArr.lastObject];
                
                NSArray *imageArr = [model.img componentsSeparatedByString:@","];
                [cell.orderImageView sd_setImageWithURL:[NSURL URLWithString:imageArr.firstObject]];
                
                if (!(([model.expressName isKindOfClass:[NSNull class]] || [model.expressName isEqual:[NSNull null]] || model.expressName == nil) || ([model.expressCode isKindOfClass:[NSNull class]] || [model.expressCode isEqual:[NSNull null]] || model.expressCode == nil))) {
                    cell.kuaidiLabel.text = [NSString stringWithFormat:@"%@:%@",model.expressName,model.expressCode];
                }else {
                    cell.kuaidiLabel.text = @"";
                }
            }
        }
        
        return cell;
    }
    static NSString *RecordDetailViewCellId = @"RecordDetailViewCellId";
    RecordDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordDetailViewCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArr.count) {
        RecordModel *model = (RecordModel *)_dataArr[0];
        
        cell.informationLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.titleLabel.text = model.expressName;
                cell.informationLabel.text = @"";
            }else if (indexPath.row == 1) {
                cell.titleLabel.text = @"快递单号：";
                cell.informationLabel.text = model.expressCode;
            }else {
                cell.titleLabel.text = @"快递状态：";
                cell.informationLabel.textColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
                cell.informationLabel.text = model.expressState;
            }
        }else {
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"收件人：";
                cell.informationLabel.text = model.receiveName;
            }else if (indexPath.row == 1) {
                cell.titleLabel.text = @"联系电话：";
                cell.informationLabel.text = model.receviePhone;
            }else {
                cell.titleLabel.text = @"收货地址：";
                cell.informationLabel.text = model.recevieAddress;
            }
        }
    }
    
    return cell;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }else {
        return 10.f;
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
