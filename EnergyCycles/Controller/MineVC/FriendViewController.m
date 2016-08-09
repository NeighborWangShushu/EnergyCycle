//
//  FriendViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FriendViewController.h"
#import "AttentionAndFansTableViewCell.h"

#import "MineHomePageViewController.h"

@interface FriendViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation FriendViewController

// 懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)getData {
    [[AppHttpManager shareInstance] getBothHeartWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        [self.dataArr removeAllObjects];
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *dic in dict[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                [self.dataArr addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
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
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = @"我的社交圈";
    
    [self getData];
    // Do any additional setup after loading the view.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *attentionAndFansTableViewCell = @"attentionAndFansTableViewCell";
    AttentionAndFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attentionAndFansTableViewCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AttentionAndFansTableViewCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserModel *model = self.dataArr[indexPath.row];
    [cell getdateFriendsDataWithUserModel:model];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MineHomePageViewController *mineVC = MainStoryBoard(@"MineHomePageViewController");
    UserModel *model = self.dataArr[indexPath.row];
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
