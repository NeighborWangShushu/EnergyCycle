//
//  PromiseVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PromiseVC.h"
#import "AddPromiseViewCell.h"
#import "PromiseOngoingViewCell.h"
#import "GifHeader.h"
#import "PromiseDetailsVC.h"
#import "ProjectVC.h"
#import "SinglePromiseDetailsVC.h"

@interface PromiseVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;
//@property (nonatomic, strong) 

@end

@implementation PromiseVC

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

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    // 重新加载导航视图来去除导航视图底部的横线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"公众承诺";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
//        return [self.dataArray count];
        return 1;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *promiseOngoingViewCell = @"PromiseOngoingViewCell";
        PromiseOngoingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:promiseOngoingViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:promiseOngoingViewCell owner:self options:nil].firstObject;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell getDataWithModel];
        
        return cell;
        
    } else {
        static NSString *addPromiseViewCell = @"AddPromiseViewCell";
        AddPromiseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addPromiseViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:addPromiseViewCell owner:self options:nil].firstObject;
        }
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [cell getDataWithModel];
        
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SinglePromiseDetailsVC *spdVC = [[SinglePromiseDetailsVC alloc] init];
        [self.navigationController pushViewController:spdVC animated:YES];
    } else if (indexPath.section == 1) {
        ProjectVC *pVC = [[ProjectVC alloc] init];
        [self.navigationController pushViewController:pVC animated:YES];
    }
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
