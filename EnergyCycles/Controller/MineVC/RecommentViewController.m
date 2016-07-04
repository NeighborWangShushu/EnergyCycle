//
//  RecommentViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "RecommentViewController.h"

#import "MineRecViewCell.h"
#import "RecommentModel.h"

#import "OtherUesrViewController.h"
#import "GifHeader.h"

@interface RecommentViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_dataArr;
    NSInteger touchIndex;
}

@end

@implementation RecommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@的推荐",self.showTitle];
    _dataArr = [[NSMutableArray alloc] init];
    
    EnetgyCycle.energyTabBar.tabBar.translucent = NO;
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    mineRecTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mineRecTableView.showsVerticalScrollIndicator = NO;
    mineRecTableView.showsHorizontalScrollIndicator = NO;
    
    //
    [self setUpMJRefresh];
    
    self.navigationController.navigationBarHidden = NO;
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
    mineRecTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithIndexPage];
    }];
    
    [mineRecTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [mineRecTableView.mj_header endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexPage {
    [[AppHttpManager shareInstance] getGetMyTuiJianListWithUserid:[self.showUserID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [_dataArr removeAllObjects];
            for (NSDictionary *subDict in dict[@"Data"]) {
                RecommentModel *model = [[RecommentModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            
            [self endRefresh];
            if (!_dataArr.count) {
                if ([self.showUserID integerValue] == [User_ID integerValue]) {
                    [SVProgressHUD showImage:nil status:@"暂时还没有被推荐的用户哦，加油!"];
                }else {
                    [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"%@暂时还没有被推荐的用户哦!",self.showTitle]];
                }
            }
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popViewControllerAnimated:NO];
        }else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
        [mineRecTableView reloadData];
    } failure:^(NSString *str) {
        [self endRefresh];
        NSLog(@"%@",str);
    }];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MineRecViewCellID = @"MineRecViewCellID";
    MineRecViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineRecViewCellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MineRecViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImageButton.userInteractionEnabled = NO;
    
    if (_dataArr.count) {
        RecommentModel *model = (RecommentModel *)_dataArr[indexPath.row];
        
        [cell.iconImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.photourl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
        cell.nameLabel.text = model.nickname;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    touchIndex = indexPath.row;
    [self performSegueWithIdentifier:@"MineRecommViewToOtherUserView" sender:nil];
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MineRecommViewToOtherUserView"]) {
        OtherUesrViewController *otherVC = segue.destinationViewController;
        
        if (_dataArr.count) {
            RecommentModel *model = (RecommentModel *)_dataArr[touchIndex];
            otherVC.otherName = model.nickname;
            otherVC.otherUserId = model.use_id;
            otherVC.otherPic = model.photourl;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
