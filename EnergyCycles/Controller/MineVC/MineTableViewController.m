//
//  MineTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineTableViewController.h"

#import "MineHeadTableViewCell.h"
#import "MineTableViewCell.h"

@interface MineTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MineTableViewController

// 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

// 每一组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 6;
    } else {
        return 1;
    }
}

// 每一组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 14.f;
}

// 每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 113.f;
    }
    return 50.f;
}

// 每一组的底部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

// 设置分区头的View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    return view;
}

// 设置分区尾的View
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    return view;
}

// 每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *mineHeadTableViewCell = @"mineHeadTableViewCell";
        MineHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineHeadTableViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineHeadTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *mineTableViewCell = @"mineTableViewCell";
        MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineTableViewCell];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateDataWithSection:indexPath.section index:indexPath.row count:nil];
        return cell;
    }
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // 个人主页
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) { // 能量圈
            
        } else if (indexPath.row == 1) { // 关注
            
        } else if (indexPath.row == 2) { // 粉丝
            
        } else if (indexPath.row == 3) { // 消息
            
        } else if (indexPath.row == 4) { // PK记录
            
        } else if (indexPath.row == 5) { // 推荐用户
            
        }
    } else if (indexPath.section == 2) { // 积分榜
        
    } else if (indexPath.section == 3) { // 设置
        [self performSegueWithIdentifier:@"SettingTableViewController" sender:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Do any additional setup after loading the view.
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
