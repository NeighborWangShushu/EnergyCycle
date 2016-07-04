//
//  OtherUserGuanZhuViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 16/3/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OtherUserGuanZhuViewController.h"

#import "OtherUserModel.h"
#import "OtherUserShowViewCell.h"

#import "OtherUesrViewController.h"
#import "GifHeader.h"


@interface OtherUserGuanZhuViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *_dataArr;
}

@end

@implementation OtherUserGuanZhuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关注的人";
    self.navigationController.navigationBarHidden = NO;
    EnetgyCycle.energyTabBar.tabBar.translucent = NO;
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    _dataArr = [[NSMutableArray alloc] init];
    
    otherUserTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    otherUserTableView.showsHorizontalScrollIndicator = NO;
    otherUserTableView.showsVerticalScrollIndicator = NO;
    otherUserTableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    [self setUpMJRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    EnetgyCycle.energyTabBar.tabBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    otherUserTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        [weakSelf getNetDataWithType];
    }];
    
    [otherUserTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [otherUserTableView.mj_header endRefreshing];
}

#pragma mark - 获取网络数据
- (void)getNetDataWithType {
    [[AppHttpManager shareInstance] getGetFriendsListWithUid1:[self.otherUserID intValue] Uid2:[User_ID intValue] Type:1 PostOrGet:@"get" success:^(NSDictionary *dict) {
        [_dataArr removeAllObjects];
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                OtherUserModel *model = [[OtherUserModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            [self endRefresh];
            [otherUserTableView reloadData];
        }else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [self endRefresh];
    }];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *OtherUserShowViewCellID = @"OtherUserShowViewCellID";
    OtherUserShowViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OtherUserShowViewCellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OtherUserShowViewCell" owner:self options:nil].lastObject;
    }
    cell.tag = 4201 + indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArr.count) {
        OtherUserModel *model = (OtherUserModel *)_dataArr[indexPath.row];
        
        cell.rightButton.hidden = NO;
        if ([model.userId integerValue] == [User_ID integerValue]) {
            cell.rightButton.hidden = YES;
        }
        
        cell.nameLabel.text = model.nickName;
        [cell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.photoUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
        
        [cell.rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
        cell.rightButton.userInteractionEnabled = YES;
        
        if ([model.isHeart integerValue] == 0) {
            [cell.rightButton setImage:[[UIImage imageNamed:@"45tianjia01.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [cell.rightButton setTitle:@"关注" forState:UIControlStateNormal];
        }else {
            [cell.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.rightButton setBackgroundColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1]];
            
            [cell.rightButton setImage:[[UIImage imageNamed:@"46gou_.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [cell.rightButton setTitle:@"已关注" forState:UIControlStateNormal];
            cell.rightButton.userInteractionEnabled = NO;
        }
    }
    
    //头像
    [cell setOtherUserHeadButtonClick:^(NSInteger index) {
        OtherUserModel *model = (OtherUserModel *)_dataArr[index-4201];
        
        OtherUesrViewController *otherUserVC = MainStoryBoard(@"OtherUserInformationVCID");
        otherUserVC.otherUserId = model.userId;
        otherUserVC.otherName = model.nickName;
        otherUserVC.otherPic = model.photoUrl;
        [self.navigationController pushViewController:otherUserVC animated:YES];
    }];
    
    //关注
    [cell setOtherUserButtonClick:^(NSInteger index) {
        OtherUserModel *model = (OtherUserModel *)_dataArr[index-4201];
        
        [[AppHttpManager shareInstance] getAddOrCancelFriendWithType:1 UserId:[User_ID intValue] Token:User_TOKEN OUserId:[model.userId intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"关注成功"];
                [otherUserTableView.mj_header beginRefreshing];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
    }];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
