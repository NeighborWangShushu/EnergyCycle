//
//  InformTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "InformTableViewController.h"
#import "InformTableViewCell.h"

#import "GifHeader.h"

@interface InformTableViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) int page;

@property (nonatomic, assign) BOOL noData;

@end

@implementation InformTableViewController

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [weakSelf getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [weakSelf getData];
    }];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData {
    [[AppHttpManager shareInstance] getAPPNotifyWithUserid:[User_ID intValue] Pageindex:self.page Pagesize:10 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if (self.page == 0) {
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *data in dict[@"Data"]) {
                NotifyModel *model = [[NotifyModel alloc] initWithDictionary:data error:nil];
                [self.dataArr addObject:model];
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

- (void)getInformReaded {
    [[AppHttpManager shareInstance] getMessageReadedWithType:3 Userid:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            NSLog(@"置为已读");
        } else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    self.title = @"通知";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getData];
    [self getInformReaded];
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
    if ([self.dataArr count] == 0) {
        self.noData = YES;
        return 1;
    } else {
        self.noData = NO;
        return [self.dataArr count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *informTableViewCell = @"informTableViewCell";
    InformTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:informTableViewCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"InformTableViewCell" owner:self options:nil].lastObject;
    }
    
    if (self.noData) {
        [cell noData];
        return cell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NotifyModel *model = self.dataArr[indexPath.row];
    [cell updateDataWithModel:model];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NotifyModel *model = self.dataArr[indexPath.row];
    NSString *commentText = [model.NotifyContent stringByRemovingPercentEncoding];
    commentText = [commentText stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    commentText = [commentText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    commentText = [commentText stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    commentText = [commentText stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:model.NotifyTitle message:commentText preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];

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
