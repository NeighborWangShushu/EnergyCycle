//
//  RadioListVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RadioListVC.h"
#import "RadioListTableViewCell.h"
#import "AFSoundManager.h"
#import "GifHeader.h"

@interface RadioListVC () {
    int pageIndex;
    int pageSize;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RadioListVC

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    self.title = @"电台";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setUpMJRefresh];
    
    // Do any additional setup after loading the view.
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)getData {
    [[AppHttpManager shareInstance] getAppRadioListWithPageIndex:pageIndex PageSize:pageSize PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if (pageIndex == 0) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"Data"]) {
                RadioModel *model = [[RadioModel alloc] initWithDictionary:dic error:nil];
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
        NSLog(@"%@", str);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *radioListTableViewCell = @"RadioListTableViewCell";
    RadioListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:radioListTableViewCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RadioListTableViewCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.radioUrl = self.radioUrl;
    RadioModel *model = self.dataArray[indexPath.row];
    [cell getDataWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell play];
    
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
