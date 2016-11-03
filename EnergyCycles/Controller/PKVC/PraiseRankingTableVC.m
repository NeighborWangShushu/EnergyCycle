//
//  PraiseRankingTableVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PraiseRankingTableVC.h"
#import "PraiseRankingTableViewCell.h"
#import "GifHeader.h"

@interface PraiseRankingTableVC () {
    int pageIndex;
    int pageSize;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PraiseRankingModel *userModel;

@end

@implementation PraiseRankingTableVC

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
    
    self.title = @"获赞排名";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setUpMJRefresh];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpMJRefresh {
//    self.userModel = [[PraiseRankingModel alloc] init];
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
    [[AppHttpManager shareInstance] getGoodOrderWithUserID:[User_ID intValue] PageIndex:pageIndex PageSize:pageSize PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            NSDictionary *dataDic = dict[@"Data"];
            if (pageIndex == 0) {
                [self.dataArray removeAllObjects];
                for (NSDictionary *dic in dataDic[@"MyOrder"]) {
                    self.userModel = [[PraiseRankingModel alloc] initWithDictionary:dic error:nil];
                }
            }
            for (NSDictionary *dic in dataDic[@"Order_List"]) {
                PraiseRankingModel *model = [[PraiseRankingModel alloc] initWithDictionary:dic error:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld", section);
    if (section == 0) {
        return 1;
    } else {
        return [self.dataArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

// 每一组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30.f;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 30)];
    view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 100, 30)];
    label.text = @"最新获赞排名";
    [label setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *praiseRankingTableViewCell = @"PraiseRankingTableViewCell";
    PraiseRankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:praiseRankingTableViewCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PraiseRankingTableViewCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PraiseRankingModel *model = [[PraiseRankingModel alloc] init];
    if (indexPath.section == 0) {
        model = self.userModel;
        cell.lineView.hidden = YES;
    } else {
        model = self.dataArray[indexPath.row];
    }
    [cell getDataWithModel:model];

    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
