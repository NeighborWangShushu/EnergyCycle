//
//  PKRecordTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PKRecordTableViewController.h"
#import "MinePKRecordViewTableViewCell.h"
#import "MyPkEveryModel.h"
#import "BrokenLineViewController.h"
#import "GifHeader.h"

@interface PKRecordTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int page;

@end

@implementation PKRecordTableViewController

// 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

// 通知获取用户ID并调用获取数据方法
- (void)getPKData:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *userId = dic[@"userId"];
    self.userId = userId;
    [self getDataWithUserId:userId];
}

- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        [weakSelf getDataWithUserId:self.userId];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getDataWithUserId:self.userId];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

// 获取数据
- (void)getDataWithUserId:(NSString *)userId {
    [[AppHttpManager shareInstance] getGetMyPkHistoryProjectWithUserId:[userId intValue] Token:@"" PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            
            [self.dataArray removeAllObjects];
            
            for (NSDictionary *dic in dict[@"Data"]) {
                MyPkEveryModel *model = [[MyPkEveryModel alloc] initWithDictionary:dic error:nil];
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
        [self endRefresh];
        NSLog(@"%@", str);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.isMineTableView) {
        [self getDataWithUserId:self.userId];
//        [self setUpMJRefresh];
        self.tableView.tableHeaderView = nil;
        self.title = @"PK记录";
        self.navigationController.navigationBar.translucent = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 50);
//        self.tabBarController.tabBar.hidden = YES;
    }
    
    [self setUpMJRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPKData:) name:@"PKRecordTableViewController" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *minePKRecordViewTableViewCell = @"minePKRecordViewTableViewCell";
    MinePKRecordViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:minePKRecordViewTableViewCell];
    
    if (cell  == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MinePKRecordViewTableViewCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyPkEveryModel *model = self.dataArray[indexPath.row];
    [cell getDataWithModel:model number:indexPath.row + 1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BrokenLineViewController *blVC = MainStoryBoard(@"BrokenLineViewController");
    MyPkEveryModel *model = self.dataArray[indexPath.row];
    blVC.projectID = model.pId;
    blVC.showStr = model.name;
    [self.navigationController pushViewController:blVC animated:YES];
}


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
