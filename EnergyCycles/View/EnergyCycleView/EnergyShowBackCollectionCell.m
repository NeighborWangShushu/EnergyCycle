//
//  EnergyShowBackCollectionCell.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "EnergyShowBackCollectionCell.h"
#import "EnergyShowOneViewCell.h"
#import "EnergyShowTwoViewCell.h"
#import "EnergyShowThreeViewCell.h"
#import "EnergyMainModel.h"
#import "GifHeader.h"


@interface EnergyShowBackCollectionCell () <UITableViewDataSource,UITableViewDelegate> {
    int page;
    NSInteger showType;
    NSMutableArray * _dataList;
}

@end

@implementation EnergyShowBackCollectionCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor whiteColor];
    page = 0;
    _dataList=[NSMutableArray array];
    
    self.showTableView.delegate = self;
    self.showTableView.dataSource = self;
    self.showTableView.backgroundColor = [UIColor clearColor];
    self.showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showTableView.showsVerticalScrollIndicator = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataArray:) name:@"update" object:nil];
    //
    [self setUpMJRefresh];
    
    //增加消息中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(energyCycleDetailChange:) name:@"isEnergyCycleDetailChange" object:nil];
}

#pragma mark - 增加消息中心
- (void)energyCycleDetailChange:(NSNotification *)notification {
    NSDictionary *notifiationDict = [notification object];
    if (_dataList.count) {
        EnergyMainModel *model = (EnergyMainModel *)_dataList[[notifiationDict[@"index"] integerValue]];
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
        [_dataList replaceObjectAtIndex:[notifiationDict[@"index"] integerValue] withObject:model];
    }
    
    [self.showTableView reloadData];
}

-(void)updataArray:(NSNotification*)obj {
    NSString * temp=[NSString stringWithFormat:@"%@",obj.object];
    if ([temp isEqualToString:@"update"]) {
        [self.showTableView.mj_header endRefreshing];
        
        [_dataList removeAllObjects];
        [self.showTableView reloadData];
        [self setUpMJRefresh];
    }
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.showTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        page = 0;
        [_dataList removeAllObjects];
        [weakSelf loadDataWithIndexWithType:showType Page:page];
    }];
    
    self.showTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithIndexWithType:showType Page:page];
    }];
    
    [self.showTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [self.showTableView.mj_header endRefreshing];
    [self.showTableView.mj_footer endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexWithType:(NSInteger)type Page:(int)pages {
    [[AppHttpManager shareInstance] getGetArticleListWithType:[NSString stringWithFormat:@"%ld",(long)type] Userid:User_ID Token:User_TOKEN PageIndex:[NSString stringWithFormat:@"%d",pages] PageSize:@"15" PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            NSArray * arr=dict[@"Data"];
            if (arr.count) {
                if (pages == 0) {
                    [_dataList removeAllObjects];
                }
                for (NSDictionary * subDic in arr) {
                    EnergyMainModel * model=[[EnergyMainModel alloc]initWithDictionary:subDic error:nil];
                    [_dataList addObject:model];
                }
                [self. showTableView reloadData];
            }
        }else {
            if (type == 4 && [dict[@"Code"] integerValue] == 1000) {
                [SVProgressHUD showImage:nil status:@"需要关注其他人哟~"];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        }
        
        [self endRefresh];
    } failure:^(NSString *str) {
        page --;
        [self endRefresh];
    }];
}

#pragma mark - 获取网络数据
- (void)energyShowCollectionGetDataWithIndex:(NSInteger)indexPath {
    if (showType != indexPath) {
        showType = indexPath;
        [self endRefresh];
        [self.showTableView.mj_header beginRefreshing];
    }
}

#pragma mark - UITableView 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataList.count) {
        EnergyMainModel * model=_dataList[indexPath.row];
        if (model.artPic.count) {//图片
            return 310.f;
        }else if (model.videoUrl.length>6) {
            return 292.f;
        }else{
            return 188.f;
        }
    }
    return 0.1f;
}
//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataList.count) {
        EnergyMainModel * model = _dataList[indexPath.row];
        if (model.artPic.count) {//图片
            static NSString *EnergyShowOneViewCellId = @"EnergyShowOneViewCellId";
            EnergyShowOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EnergyShowOneViewCellId];
            
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"EnergyShowOneViewCell" owner:self options:nil].lastObject;
            }
            
            [cell updateDataOneWithModel:model];
            
            cell.zanButton.tag=indexPath.row;
            [cell.zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.caiButton.tag=indexPath.row+1000;
            [cell.caiButton addTarget:self action:@selector(caiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.commentButton.tag = 10010+indexPath.row;
            [cell.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.iconButton.tag = 3001 + indexPath.row;
            [cell setEnergyShowButtonClick:^(NSInteger index) {
                [self jumpOtherUserInformationWithIndex:index-3001];
            }];
            
            return cell;
        }else if (model.videoUrl.length>6) {//视频
            static NSString *EnergyShowTwoViewCellId = @"EnergyShowTwoViewCellId";
            
            EnergyShowTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EnergyShowTwoViewCellId];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"EnergyShowTwoViewCell" owner:self options:nil].lastObject;
            }
            
            [cell updateDataTwoWithModel:model];
            
            cell.zan1Button.tag=indexPath.row;
            [cell.zan1Button addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.cai1Button.tag=indexPath.row+1000;
            [cell.cai1Button addTarget:self action:@selector(caiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.comment1Button.tag = 10010+indexPath.row;
            [cell.comment1Button addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.icon1Button.tag = 3001 + indexPath.row;
            [cell setEnergyShowTwoButtonClick:^(NSInteger index) {
                [self jumpOtherUserInformationWithIndex:index-3001];
            }];
            
            return cell;
        }
        
        // 纯文字
        static NSString *EnergyShowThreeViewCellId = @"EnergyShowThreeViewCellId";
        EnergyShowThreeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EnergyShowThreeViewCellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"EnergyShowThreeViewCell" owner:self options:nil].lastObject;
        }
        
        [cell updateDataThreeWithModel:model];
        
        cell.zan2Button.tag=indexPath.row;
        [cell.zan2Button addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.cai2Button.tag=indexPath.row+1000;
        [cell.cai2Button addTarget:self action:@selector(caiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.comment2Button.tag = 10010+indexPath.row;
        [cell.comment2Button addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.icon2Button.tag = 3001 + indexPath.row;
        [cell setEnergyShowThreeButtonClick:^(NSInteger index) {
            [self jumpOtherUserInformationWithIndex:index-3001];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataList.count) {
        EnergyCycleShowCellModel *model = _dataList[indexPath.row];
        if (_EnergyCycleCellBlock) {
            _EnergyCycleCellBlock(model,indexPath.row);
        }
    }
}

#pragma mark - 跳转到其他人信息界面
- (void)jumpOtherUserInformationWithIndex:(NSInteger)index {
    EnergyMainModel *model = (EnergyMainModel *)_dataList[index];
    if (_energyCycleHeadBlock) {
        _energyCycleHeadBlock(model);
    }
}

#pragma mark--点赞
- (void)zanButtonClick:(UIButton *)sender{
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        if (_dataList.count){
            EnergyMainModel * model=_dataList[sender.tag];
            
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
                [self.showTableView reloadData];
            }
        }
    }
}
//踩
-(void)caiButtonClick:(UIButton *)sender {
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        if (_dataList.count){
            EnergyMainModel * model=_dataList[sender.tag-1000];
            
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
                [self.showTableView reloadData];
            }
        }
    }
}
//评论
- (void)commentButtonClick:(UIButton *)btn {
    if ([User_TOKEN isKindOfClass:[NSNull class]] || [User_TOKEN isEqual:[NSNull null]] || User_TOKEN == nil || [User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        EnergyCycleShowCellModel *model = _dataList[btn.tag - 10010];
        if (_EnergyCycleCellBlock) {
            _EnergyCycleCellBlock(model,btn.tag-10010);
        }
    }
}

-(void)zanOrCai:(NSString *)type withOType:(NSString *)oType ArticleId:(NSInteger)Id index:(NSInteger)CellIndex {
    [[AppHttpManager shareInstance] postAddLikeOrNoLikeWithType:type OpeType:oType ArticleId:(int)Id  UserId:[User_ID intValue] token:User_TOKEN PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if (Id == 2) {
                NSLog(@"踩 成功");
            }else {
                NSLog(@"赞 成功");
            }
        }
    } failure:^(NSString *str) {
        
    }];
}


@end
