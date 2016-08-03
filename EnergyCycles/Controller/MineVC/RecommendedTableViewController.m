//
//  RecommendedTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RecommendedTableViewController.h"
#import "MineRecommendedTableViewCell.h"
#import "RecommentModel.h"
#import "GifHeader.h"

#import "MineHomePageViewController.h"

@interface RecommendedTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RecommendedTableViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        [weakSelf updateData];
    }];
    
//    [self.tableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)updateData {
    [[AppHttpManager shareInstance] getGetMyTuiJianListWithUserid:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *data in dict[@"Data"]) {
                RecommentModel *model = [[RecommentModel alloc] initWithDictionary:data error:nil];
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endRefresh];
                [self.tableView reloadData];
            });
            
        } else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:@"暂时还没有被推荐的用户哦!" maskType:SVProgressHUDMaskTypeClear];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐用户";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self updateData];
    [self setUpMJRefresh];
    
    
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
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *mineRecommendedTableViewCell = @"mineRecommendedTableViewCell";
    MineRecommendedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineRecommendedTableViewCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MineRecommendedTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RecommentModel *model = self.dataArray[indexPath.row];
    [cell updateDataWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MineHomePageViewController *mineVC = MainStoryBoard(@"MineHomePageViewController");
    RecommentModel *model = self.dataArray[indexPath.row];
    mineVC.userId = model.use_id;
    [self.navigationController pushViewController:mineVC animated:YES];
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
