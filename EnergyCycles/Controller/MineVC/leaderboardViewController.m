//
//  leaderboardViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "leaderboardViewController.h"
#import "IntegralMallViewController.h"

#import "LeaderBoardViewCell.h"
#import "UserModel.h"
#import "GifHeader.h"
#import "OtherUesrViewController.h"
#import "MineHomePageViewController.h"

@interface leaderboardViewController () <UITableViewDataSource,UITableViewDelegate> {
    int page;
    NSMutableArray *_dataArr;
    UILabel *numLabel;
}

@end

@implementation leaderboardViewController

<<<<<<< HEAD
- (void)rightAction {
    IntegralMallViewController *imVC = MainStoryBoard(@"IntegralMallViewController");
    [self.navigationController pushViewController:imVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupRightNavBarWithTitle:@"商城"];
}
=======
//- (void)rightAction {
//    IntegralMallViewController *imVC = MainStoryBoard(@"IntegralMallViewController");
//    [self.navigationController pushViewController:imVC animated:YES];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [self setupRightNavBarWithTitle:@"商城"];
//}
>>>>>>> wangbin

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分排行榜";
    [self setupLeftNavBarWithimage:@"loginfanhui"];

    //
    [self creatHeadView];
    _dataArr = [[NSMutableArray alloc] init];
    
    leaderBoardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    leaderBoardTableView.showsHorizontalScrollIndicator = NO;
    leaderBoardTableView.showsVerticalScrollIndicator = NO;
}

- (void)creatHeadView {
    //
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, Screen_width, 17)];
    titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的积分";
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self.headBackView addSubview:titleLabel];
    
    //
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 160)];
    numLabel.font = [UIFont systemFontOfSize:64];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.center = CGPointMake(Screen_width/2, 100);
    [self.headBackView addSubview:numLabel];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = numLabel.bounds;
    gradientLayer.colors = @[(id)[UIColor colorWithRed:112/255.0 green:203/255.0 blue:246/255.0 alpha:1].CGColor, (id)[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1].CGColor];
    [self.headBackView.layer addSublayer:gradientLayer];
    
    gradientLayer.mask = numLabel.layer;
    numLabel.frame = gradientLayer.frame;
    
    //
    UIImageView *yinyingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_width/2-50, 110, 100, 40)];
    yinyingImageView.image = [UIImage imageNamed:@"learbyinying"];
    [self.headBackView addSubview:yinyingImageView];
    
    //
    [self setUpMJRefresh];
    [self getMyJiFenPaiMing];
}

#pragma mark - 获取积分排名
- (void)getMyJiFenPaiMing {
    self.nameLabel.text = self.showName;
    
    NSString *jifen = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserJiFen"]];
    numLabel.text = jifen;
    
    [[AppHttpManager shareInstance] getGetJinfenCountWithUserid:[self.userId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            self.paimingLabel.text = [NSString stringWithFormat:@"第%@名",dict[@"Data"]];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    leaderBoardTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf loadDataWithIndexPage:page];
    }];
    
    leaderBoardTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithIndexPage:page];
    }];
    
    [leaderBoardTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [leaderBoardTableView.mj_header endRefreshing];
    [leaderBoardTableView.mj_footer endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexPage:(int)pages {
    [[AppHttpManager shareInstance] getGetJiFenListWithPage:pages  withUserId:[self.userId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if (pages == 1) {
                [_dataArr removeAllObjects];
            }
            for (NSDictionary *subDict in dict[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            
            [self endRefresh];
            [leaderBoardTableView reloadData];
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效" maskType:SVProgressHUDMaskTypeClear];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
        }
        
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [self endRefresh];
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
    return 70.f;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LeaderBoardViewCellID = @"LeaderBoardViewCellID";
    LeaderBoardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LeaderBoardViewCellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LeaderBoardViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    static float process = 0;
    if (_dataArr.count) {
        UserModel *model = (UserModel *)_dataArr[indexPath.row];
        [cell updateLearderBoardDataWithModel:model withIndex:indexPath.row];
        
        if (indexPath.row == 0) {
            process = [model.jifen floatValue];
        }
        if (indexPath.row == 0) {
            if (process != 0) {
                cell.lingLearnProgressView.progress = 1.0;
            }else {
                cell.lingLearnProgressView.progress = 0.0;
            }
        }else {
            if (process != 0) {
//                cell.lingLearnProgressView.progress = [model.studyVal floatValue]/process;
                cell.lingLearnProgressView.progress = [model.jifen floatValue]/process;
            }else {
                cell.lingLearnProgressView.progress = 0.0;
            }
        }
    }
    
    cell.headLearnButton.userInteractionEnabled = NO;
    //头像点击事件
//    cell.headLearnButton.tag = 4101 + indexPath.row;
//    [cell.headLearnButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - 头像点击事件
- (void)headButtonClick:(UIButton *)button {
    NSLog(@"积分排行榜头像：%ld",(long)button.tag);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    OtherUesrViewController *otherUserVC = MainStoryBoard(@"OtherUserInformationVCID");
//    UserModel *model = (UserModel *)_dataArr[indexPath.row];
//    otherUserVC.otherUserId = model.use_id;
//    otherUserVC.otherName = model.nickname;
//    otherUserVC.otherPic = model.photourl;
//    [self.navigationController pushViewController:otherUserVC animated:YES];
    MineHomePageViewController *mineVC = MainStoryBoard(@"MineHomePageViewController");
    UserModel *model = _dataArr[indexPath.row];
    mineVC.userId = model.use_id;
    [self.navigationController pushViewController:mineVC animated:YES];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
