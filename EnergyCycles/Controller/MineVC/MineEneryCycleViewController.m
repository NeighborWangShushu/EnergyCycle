//
//  MineEneryCycleViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MineEneryCycleViewController.h"

#import "EnergyShowOneViewCell.h"
#import "EnergyShowTwoViewCell.h"
#import "EnergyShowThreeViewCell.h"

#import "MineEnergyShowOneViewCell.h"
#import "MineEnergyShowTwoViewCell.h"
#import "MineEnergyShowThreeViewCell.h"

#import "EnergyMainModel.h"
#import "GifHeader.h"
#import "DetailViewController.h"

@interface MineEneryCycleViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate> {
    int page;
    
    NSMutableArray *_dataArr;
    NSInteger delIndex;
}

@end

@implementation MineEneryCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@的能量圈",self.showTitle];
    EnetgyCycle.energyTabBar.tabBar.translucent = NO;
    
    _dataArr = [[NSMutableArray alloc] init];
    
    mineEneryCycleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mineEneryCycleTableView.showsVerticalScrollIndicator = NO;
    mineEneryCycleTableView.showsHorizontalScrollIndicator = NO;
    
    //
    [self setUpMJRefresh];
    
    //增加消息中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mineEnergyCycleDetailChange:) name:@"isMineEnergyCycleDetailChange" object:nil];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 增加消息中心
- (void)mineEnergyCycleDetailChange:(NSNotification *)notification {
    NSDictionary *notifiationDict = [notification object];
    if (_dataArr.count) {
        EnergyMainModel *model = (EnergyMainModel *)_dataArr[[notifiationDict[@"index"] integerValue]];
        if ([notifiationDict[@"type"] integerValue] == 3) {
            model.commentNum = [NSString stringWithFormat:@"%ld",(long)[model.commentNum integerValue] + 1];
        }else if ([notifiationDict[@"type"] integerValue] == 2) {//踩
            if ([model.isHasNoLike integerValue] == 0) {
                model.isHasNoLike = @"1";
                model.noLikeNum = [NSString stringWithFormat:@"%ld",(long)[model.noLikeNum integerValue] + 1];
            }else {
                model.isHasNoLike = @"0";
                if ([model.noLikeNum integerValue] -1 < 0) {
                    model.noLikeNum = @"0";
                }else {
                    model.noLikeNum = [NSString stringWithFormat:@"%ld",(long)[model.noLikeNum integerValue] - 1];
                }
            }
        }else {//赞
            if ([model.isHasLike integerValue] == 0) {
                model.isHasLike = @"1";
                model.likeNum = [NSString stringWithFormat:@"%ld",(long)[model.likeNum integerValue] + 1];
            }else {
                model.isHasLike = @"0";
                if ([model.likeNum integerValue] -1 < 0) {
                    model.isHasLike = @"0";
                }else {
                    model.likeNum = [NSString stringWithFormat:@"%ld",(long)[model.likeNum integerValue] - 1];
                }
            }
        }
        [_dataArr replaceObjectAtIndex:[notifiationDict[@"index"] integerValue] withObject:model];
    }
    
    [mineEneryCycleTableView reloadData];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    mineEneryCycleTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        page = 0;
        [weakSelf loadDataWithIndexWithPage:page];
    }];
    
    mineEneryCycleTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithIndexWithPage:page];
    }];
    [mineEneryCycleTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [mineEneryCycleTableView.mj_header endRefreshing];
    [mineEneryCycleTableView.mj_footer endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexWithPage:(int)pages {
    [[AppHttpManager shareInstance] getGetArticleListByUserWithUserId:[self.showUserID intValue] Token:@"" PageIndex:pages PageSize:10 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if (pages == 0) {
            [_dataArr removeAllObjects];
        }
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                EnergyMainModel *model = [[EnergyMainModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            
            [mineEneryCycleTableView reloadData];
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popViewControllerAnimated:NO];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
        
        [self endRefresh];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [self endRefresh];
    }];
}

#pragma mark - UITableView 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count) {
        EnergyMainModel *model = (EnergyMainModel *)_dataArr[indexPath.row];
        
        if (model.artPic.count) {
            return 310.f;
        }else if (!model.videoUrl && model.artPic.count==0) {
            return 292.f;
        }
        return 188.f;
    }
    
    return 0.01f;
}
//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count) {//图片
        EnergyMainModel *model = (EnergyMainModel *)_dataArr[indexPath.row];
        
        if (![self.showTitle isEqualToString:@"我"]) {
            if (model.artPic.count) {
                static NSString *EnergyShowOneViewCellId = @"EnergyShowOneViewCellId";
                EnergyShowOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EnergyShowOneViewCellId];
                
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"EnergyShowOneViewCell" owner:self options:nil].lastObject;
                }
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (_dataArr.count) {
                    EnergyMainModel *model = (EnergyMainModel *)_dataArr[indexPath.row];
                    [cell updateDataOneWithModel:model];
                }
                
                cell.commentButton.userInteractionEnabled = NO;
                
                cell.zanButton.tag = 1001+indexPath.row;
                [cell.zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.caiButton.tag = 2001+indexPath.row;
                [cell.caiButton addTarget:self action:@selector(caiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            }else if (!model.videoUrl  && model.artPic.count==0) {//视频
                static NSString *EnergyShowTwoViewCellId = @"EnergyShowTwoViewCellId";
                
                EnergyShowTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EnergyShowTwoViewCellId];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"EnergyShowTwoViewCell" owner:self options:nil].lastObject;
                }
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (_dataArr.count) {
                    EnergyMainModel *model = (EnergyMainModel *)_dataArr[indexPath.row];
                    [cell updateDataTwoWithModel:model];
                }
                
                cell.comment1Button.userInteractionEnabled = NO;
                
                cell.zan1Button.tag = 1001+indexPath.row;
                [cell.zan1Button addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.cai1Button.tag = 2001+indexPath.row;
                [cell.cai1Button addTarget:self action:@selector(caiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            }
            //文字
            static NSString *EnergyShowThreeViewCellId = @"EnergyShowThreeViewCellId";
            EnergyShowThreeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EnergyShowThreeViewCellId];
            
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"EnergyShowThreeViewCell" owner:self options:nil].lastObject;
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (_dataArr.count) {
                EnergyMainModel *model = (EnergyMainModel *)_dataArr[indexPath.row];
                [cell updateDataThreeWithModel:model];
            }
            
            cell.comment2Button.userInteractionEnabled = NO;
            
            cell.zan2Button.tag = 1001+indexPath.row;
            [cell.zan2Button addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.cai2Button.tag = 2001+indexPath.row;
            [cell.cai2Button addTarget:self action:@selector(caiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        //我的
        if (model.artPic.count) {
            static NSString *MineEnergyShowOneViewCellId = @"MineEnergyShowOneViewCellId";
            MineEnergyShowOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineEnergyShowOneViewCellId];
            
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"MineEnergyShowOneViewCell" owner:self options:nil].lastObject;
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (_dataArr.count) {
                EnergyMainModel *model = (EnergyMainModel *)_dataArr[indexPath.row];
                [cell updateDataOneWithModel:model];
            }
            
            cell.commentButton.userInteractionEnabled = NO;
            
            cell.zanButton.tag = 1001+indexPath.row;
            [cell.zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.caiButton.tag = 2001+indexPath.row;
            [cell.caiButton addTarget:self action:@selector(caiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.delButton.tag = 3001+indexPath.row;
            [cell setMineOneEnergyDelButtonClick:^(NSInteger index) {
                [self delDataWithIndex:index-3001];
            }];
            
            return cell;
        }else if (!model.videoUrl  && model.artPic.count==0) {//视频
            static NSString *MineEnergyShowTwoViewCellId = @"MineEnergyShowTwoViewCellId";
            
            MineEnergyShowTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineEnergyShowTwoViewCellId];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"MineEnergyShowTwoViewCell" owner:self options:nil].lastObject;
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (_dataArr.count) {
                EnergyMainModel *model = (EnergyMainModel *)_dataArr[indexPath.row];
                [cell updateDataTwoWithModel:model];
            }
            
            cell.comment1Button.userInteractionEnabled = NO;
            
            cell.zan1Button.tag = 1001+indexPath.row;
            [cell.zan1Button addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.cai1Button.tag = 2001+indexPath.row;
            [cell.cai1Button addTarget:self action:@selector(caiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.del1Button.tag = 3001+indexPath.row;
            [cell setMineTwoEnergyDelButtonClick:^(NSInteger index) {
                [self delDataWithIndex:index-3001];
            }];
            
            return cell;
        }
        //文字
        static NSString *MineEnergyShowThreeViewCellId = @"MineEnergyShowThreeViewCellId";
        MineEnergyShowThreeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineEnergyShowThreeViewCellId];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineEnergyShowThreeViewCell" owner:self options:nil].lastObject;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_dataArr.count) {
            EnergyMainModel *model = (EnergyMainModel *)_dataArr[indexPath.row];
            [cell updateDataThreeWithModel:model];
        }
        
        cell.comment2Button.userInteractionEnabled = NO;
        
        cell.zan2Button.tag = 1001+indexPath.row;
        [cell.zan2Button addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.cai2Button.tag = 2001+indexPath.row;
        [cell.cai2Button addTarget:self action:@selector(caiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.del2Button.tag = 3001+indexPath.row;
        [cell setMineThrEnergyDelButtonClick:^(NSInteger index) {
            [self delDataWithIndex:index-3001];
        }];
        
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

//跳转到详情界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = MainStoryBoard(@"AllDeatilVCID");
    
    EnergyMainModel *model = (EnergyMainModel *)_dataArr[indexPath.row];
    detailVC.tabBarStr = @"home";
    detailVC.showTitle = model.artTitle;
    detailVC.showDetailId = model.artId;
    detailVC.touchIndex = indexPath.row;
    detailVC.isMine = @"1";
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 赞
- (void)zanButtonClick:(UIButton *)sender{
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        if (_dataArr.count){
            EnergyMainModel * model=_dataArr[sender.tag-1001];
            
            if ([model.isHasNoLike integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"赞和踩只能有一个哦."];
            }else {
                if ([model.isHasLike integerValue] == 1) {
                    model.likeNum = [NSString stringWithFormat:@"%ld",(long)[model.likeNum integerValue] - 1];
                    model.isHasLike = @"0";
                    
                    [self zanOrCai:[NSString stringWithFormat:@"%d",1] withOType:@"1" ArticleId:[model.artId integerValue] index:sender.tag];//赞
                }else {
                    model.likeNum = [NSString stringWithFormat:@"%ld",(long)[model.likeNum integerValue] + 1];
                    model.isHasLike = @"1";
                    
                    [self zanOrCai:[NSString stringWithFormat:@"%d",1] withOType:@"0" ArticleId:[model.artId integerValue] index:sender.tag];//取消赞
                }
                [mineEneryCycleTableView reloadData];
            }
        }
    }
}

#pragma mark - 踩
-(void)caiButtonClick:(UIButton *)sender{
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        if (_dataArr.count){
            EnergyMainModel *model = _dataArr[sender.tag-2001];
            
            if ([model.isHasLike integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"赞和踩只能有一个哦."];
            }else {
                if ([model.isHasNoLike integerValue] == 1) {
                    model.noLikeNum = [NSString stringWithFormat:@"%ld",(long)[model.noLikeNum integerValue] - 1];
                    model.isHasNoLike = @"0";
                    
                    [self zanOrCai:[NSString stringWithFormat:@"%d",2] withOType:@"1" ArticleId:[model.artId integerValue] index:sender.tag-1000];//踩
                }else {
                    model.noLikeNum = [NSString stringWithFormat:@"%ld",(long)[model.noLikeNum integerValue] + 1];
                    model.isHasNoLike = @"1";
                    
                    [self zanOrCai:[NSString stringWithFormat:@"%d",2] withOType:@"0" ArticleId:[model.artId integerValue] index:sender.tag-1000];//取消踩
                }
                [mineEneryCycleTableView reloadData];
            }
        }
    }
}

//获取网络数据
-(void)zanOrCai:(NSString *)type withOType:(NSString *)oType ArticleId:(NSInteger)Id index:(NSInteger)CellIndex{
    [[AppHttpManager shareInstance] postAddLikeOrNoLikeWithType:type OpeType:oType ArticleId:(int)Id  UserId:[User_ID intValue] token:User_TOKEN PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if (Id == 2) {
                NSLog(@"踩 成功");
            }else {
                NSLog(@"赞 成功");
            }
        }
    } failure:^(NSString *str) {
        NSLog(@"我的能量圈赞踩失败：%@",str);
    }];
}

#pragma mark - 删除
- (void)delDataWithIndex:(NSInteger)index {
    delIndex = index;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        EnergyMainModel *model = (EnergyMainModel *)_dataArr[delIndex];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:@"操作中.."];
        
        [[AppHttpManager shareInstance] getDeleteArticleWithuserId:[User_ID intValue] Token:User_TOKEN AType:1 AId:[model.artId intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                
                [_dataArr removeObjectAtIndex:delIndex];
                [mineEneryCycleTableView reloadData];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
