//
//  EveryDayPKTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ToDayPKTableViewController.h"
#import "ToDayPKTableViewCell.h"
#import "BrokenLineViewController.h"

@interface ToDayPKTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ToDayPKTableViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)getData:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *userId = dic[@"userId"];
    [self getToDayPKDataWithUserId:userId];
}

- (void)getToDayPKDataWithUserId:(NSString *)userId {
    [[AppHttpManager shareInstance] getGetReportByUserWithUserid:[User_ID intValue] Token:User_TOKEN OUserId:[userId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dic in dict[@"Data"][@"reportItemInfo"]) {
                OtherReportModel *model = [[OtherReportModel alloc] initWithDictionary:dic error:nil];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:@"ToDayTableViewController" object:nil];
    
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
    static NSString *toDayPKTableViewCell = @"toDayPKTableViewCell";
    ToDayPKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:toDayPKTableViewCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ToDayPKTableViewCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OtherReportModel *model = self.dataArray[indexPath.row];
    [cell updateDataWithModel:model];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BrokenLineViewController *blVC = MainStoryBoard(@"BrokenLineViewController");
    OtherReportModel *model = self.dataArray[indexPath.row];
    blVC.projectID = model.repItemId;
    blVC.showStr = model.RI_Name;
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
