//
//  SignRankingTableVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2016/12/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SignRankingTableVC.h"
#import "SignRankingTableViewCell.h"
#import "GifHeader.h"
#import "MineHomePageViewController.h"

@interface SignRankingTableVC () {
    int pageIndex;
    int pageSize;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SignRankingModel *userModel;

@end

@implementation SignRankingTableVC

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"早起签到排名";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    [self setUpMJRefresh];
    
    // Do any additional setup after loading the view.
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpMJRefresh {
    pageIndex = 0;
    pageSize = 10;
    [self getData];
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        pageIndex = 0;
        [weakSelf getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageIndex++;
        [weakSelf getData];
    }];
}

- (void)getData {
    [[AppHttpManager shareInstance] getEarlySignRankingWithUserID:[User_ID intValue] PageIndex:pageIndex PageSize:pageSize PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            NSDictionary *dataDic = dict[@"Data"];
            if (pageIndex == 0) {
                [self.dataArray removeAllObjects];
                for (NSDictionary *dic in dataDic[@"MyOrder"]) {
                    self.userModel = [[SignRankingModel alloc] initWithDictionary:dic error:nil];
                }
            }
            
            for (NSDictionary *dic in dataDic[@"Order_List"]) {
                SignRankingModel *model = [[SignRankingModel alloc] initWithDictionary:dic error:nil];
                [self.dataArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endRefresh];
                [self.tableView reloadData];
            });
        } else {
            [self endRefresh];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [self.dataArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

// 每一组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30.f;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *signRankingTableViewCell = @"SignRankingTableViewCell";
    SignRankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:signRankingTableViewCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:signRankingTableViewCell owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SignRankingModel *model = [[SignRankingModel alloc] init];
    if (indexPath.section == 0) {
        model = self.userModel;
        cell.lineView.hidden = YES;
    } else {
        model = self.dataArray[indexPath.row];
    }
    [cell getDataWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MineHomePageViewController *mineVC = MainStoryBoard(@"MineHomePageViewController");
    SignRankingModel *model = [[SignRankingModel alloc] init];
    if (indexPath.section == 0) {
        model = self.userModel;
    } else {
        model = self.dataArray[indexPath.row];
    }
    mineVC.userId = model.use_id;
    [self.navigationController pushViewController:mineVC animated:YES];
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
