//
//  MineAdvPKViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MineAdvPKViewController.h"

#import "TheAdvOneViewCell.h"
#import "TheAdvTwoViewCell.h"
#import "TheAdvThrViewCell.h"

#import "MineTheAdvOneViewCell.h"
#import "MineTheAdvTwoViewCell.h"
#import "MineTheAdvThrViewCell.h"

#import "TheAdvMainModel.h"
#import "DetailViewController.h"
#import "GifHeader.h"

@interface MineAdvPKViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate> {
    int page;
    
    NSMutableArray *_dataArr;
    NSInteger delIndex;
}

@end

@implementation MineAdvPKViewController

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@的进阶PK",self.showTitle];
    EnetgyCycle.energyTabBar.tabBar.translucent = NO;
    
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    _dataArr = [[NSMutableArray alloc] init];
    
    mineAdvTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mineAdvTableView.showsVerticalScrollIndicator = NO;
    mineAdvTableView.showsHorizontalScrollIndicator = NO;
    
    //
    [self setUpMJRefresh];
    
    //增加消息中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theMineAdvDetailChange:) name:@"isMineTheAdvDetailChange" object:nil];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 增加消息中心
- (void)theMineAdvDetailChange:(NSNotification *)notification {
    NSDictionary *notifiationDict = [notification object];
    if (_dataArr.count) {
        TheAdvMainModel *model = (TheAdvMainModel *)_dataArr[[notifiationDict[@"index"] integerValue]];
        if ([notifiationDict[@"type"] integerValue] == 3) {
            model.commNum = [NSString stringWithFormat:@"%ld",(long)[model.commNum integerValue] + 1];
        }else {//总票，新增
            model.hits = [NSString stringWithFormat:@"%ld",(long)[model.hits integerValue] + 1];
            model.daysHits = [NSString stringWithFormat:@"%ld",(long)[model.daysHits integerValue] + 1];
        }
        [_dataArr replaceObjectAtIndex:[notifiationDict[@"index"] integerValue] withObject:model];
    }
    
    [mineAdvTableView reloadData];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    mineAdvTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        page = 0;
        [weakSelf loadDataWithIndexWithPage:page];
    }];
    
    mineAdvTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithIndexWithPage:page];
    }];
    [mineAdvTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [mineAdvTableView.mj_header endRefreshing];
    [mineAdvTableView.mj_footer endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexWithPage:(int)pages {
    [[AppHttpManager shareInstance] getGetPostListByUserWithUserId:[self.showUserID intValue] Token:@"" PageIndex:pages PageSize:10 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if (pages == 0) {
            [_dataArr removeAllObjects];
        }
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"][@"postList"]) {
                TheAdvMainModel *model = [[TheAdvMainModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            
            [mineAdvTableView reloadData];
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

#pragma mark - TableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count) {
        TheAdvMainModel *model = (TheAdvMainModel *)_dataArr[indexPath.row];
        
        if (model.postPic.count) {
            return 310.f;
        }else if (!model.videoUrl && model.postPic.count==0) {
            return 292.f;
        }
        return 188.f;
    }
    
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count) {
        TheAdvMainModel *model = (TheAdvMainModel *)_dataArr[indexPath.row];
        if (![self.showTitle isEqualToString:@"我"]) {
            if (model.postPic.count) {//图片
                static NSString *TheAdvOneViewCellId = @"TheAdvOneViewCellId";
                TheAdvOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TheAdvOneViewCellId];
                
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"TheAdvOneViewCell" owner:self options:nil].lastObject;
                }
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (_dataArr.count) {
                    TheAdvMainModel *model = (TheAdvMainModel *)_dataArr[indexPath.row];
                    [cell updateDataOneWithModel:model];
                }
                cell.zanButton.userInteractionEnabled = NO;
                cell.caiButton.userInteractionEnabled = NO;
                cell.commentButton.userInteractionEnabled = NO;
                
                return cell;
            }else if (!model.videoUrl && model.postPic.count==0) {//视频
                static NSString *TheAdvTwoViewCellID = @"TheAdvTwoViewCellID";
                
                TheAdvTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TheAdvTwoViewCellID];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"TheAdvTwoViewCell" owner:self options:nil].lastObject;
                }
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (_dataArr.count) {
                    TheAdvMainModel *model = (TheAdvMainModel *)_dataArr[indexPath.row];
                    [cell updateDataTwoWithModel:model];
                }
                cell.zan1Button.userInteractionEnabled = NO;
                cell.cai1Button.userInteractionEnabled = NO;
                cell.comment1Button.userInteractionEnabled = NO;
                
                return cell;
            }
            //文字
            static NSString *TheAdvThrViewCellID = @"TheAdvThrViewCellID";
            TheAdvThrViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TheAdvThrViewCellID];
            
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"TheAdvThrViewCell" owner:self options:nil].lastObject;
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (_dataArr.count) {
                TheAdvMainModel *model = (TheAdvMainModel *)_dataArr[indexPath.row];
                [cell updateDataThrWithModel:model];
            }
            cell.zan2Button.userInteractionEnabled = NO;
            cell.cai2Button.userInteractionEnabled = NO;
            cell.comment2Button.userInteractionEnabled = NO;
            
            return cell;
        }
        //我的
        if (model.postPic.count) {//图片
            static NSString *MineTheAdvOneViewCellId = @"MineTheAdvOneViewCellId";
            MineTheAdvOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineTheAdvOneViewCellId];
            
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"MineTheAdvOneViewCell" owner:self options:nil].lastObject;
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (_dataArr.count) {
                TheAdvMainModel *model = (TheAdvMainModel *)_dataArr[indexPath.row];
                [cell updateDataOneWithModel:model];
            }
            cell.zanButton.userInteractionEnabled = NO;
            cell.caiButton.userInteractionEnabled = NO;
            cell.commentButton.userInteractionEnabled = NO;
            //删除
            cell.delButton.tag = 4301+indexPath.row;
            [cell setMineOneAdvDelButtonClick:^(NSInteger index) {
                [self delDataWithIndex:index-4301];
            }];
            
            return cell;
        }else if (!model.videoUrl && model.postPic.count==0) {//视频
            static NSString *MineTheAdvTwoViewCellID = @"MineTheAdvTwoViewCellID";
            
            MineTheAdvTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineTheAdvTwoViewCellID];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"MineTheAdvTwoViewCell" owner:self options:nil].lastObject;
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (_dataArr.count) {
                TheAdvMainModel *model = (TheAdvMainModel *)_dataArr[indexPath.row];
                [cell updateDataTwoWithModel:model];
            }
            cell.zan1Button.userInteractionEnabled = NO;
            cell.cai1Button.userInteractionEnabled = NO;
            cell.comment1Button.userInteractionEnabled = NO;
            //删除
            cell.delButton.tag = 4301+indexPath.row;
            [cell setMineThrAdvDelButtonClick:^(NSInteger index) {
                [self delDataWithIndex:index-4301];
            }];
            
            return cell;
        }
        //文字
        static NSString *MineTheAdvThrViewCellID = @"MineTheAdvThrViewCellID";
        MineTheAdvThrViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineTheAdvThrViewCellID];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineTheAdvThrViewCell" owner:self options:nil].lastObject;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_dataArr.count) {
            TheAdvMainModel *model = (TheAdvMainModel *)_dataArr[indexPath.row];
            [cell updateDataThrWithModel:model];
        }
        cell.zan2Button.userInteractionEnabled = NO;
        cell.cai2Button.userInteractionEnabled = NO;
        cell.comment2Button.userInteractionEnabled = NO;
        //删除
        cell.delButton.tag = 4301+indexPath.row;
        [cell setMineTwoAdvDelButtonClick:^(NSInteger index) {
            [self delDataWithIndex:index-4301];
        }];
        
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - cell点击事件//跳转到详情界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = MainStoryBoard(@"AllDeatilVCID");
    TheAdvMainModel *model = (TheAdvMainModel *)_dataArr[indexPath.row];
    
    detailVC.tabBarStr = @"pk";
    detailVC.showTitle = model.title;
    detailVC.showDetailId = model.postId;
    detailVC.advModel = model;
    detailVC.touchIndex = indexPath.row;
    detailVC.isMine = @"1";
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 删除
- (void)delDataWithIndex:(NSInteger)index {
    delIndex = index;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        TheAdvMainModel *model = (TheAdvMainModel *)_dataArr[delIndex];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:@"操作中.."];
        
        [[AppHttpManager shareInstance] getDeleteArticleWithuserId:[User_ID intValue] Token:User_TOKEN AType:2 AId:[model.postId intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                
                [_dataArr removeObjectAtIndex:delIndex];
                [mineAdvTableView reloadData];
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
