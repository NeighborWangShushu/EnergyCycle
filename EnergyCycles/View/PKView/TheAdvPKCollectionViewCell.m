//
//  TheAdvPKCollectionViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/9.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TheAdvPKCollectionViewCell.h"

#import "TheAdvOneViewCell.h"
#import "TheAdvTwoViewCell.h"
#import "TheAdvThrViewCell.h"
#import "GifHeader.h"

@interface TheAdvPKCollectionViewCell () <UITableViewDataSource,UITableViewDelegate> {
    int page;
    int _showType;
    NSMutableArray *_dataList;
    
    NSString * _awardName;
    NSString * _awardId;
    UIButton * _awardBtn;
}

@end

@implementation TheAdvPKCollectionViewCell

- (void)awakeFromNib {
    page = 0;
    _showType=5;
    _dataList=[NSMutableArray array];
    self.theAdvTableView.dataSource = self;
    self.theAdvTableView.delegate = self;
    self.theAdvTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.theAdvTableView.backgroundColor = [UIColor clearColor];
    
    [self setUpMJRefresh];
    
    //增加消息中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theAdvDetailChange:) name:@"isTheAdvDetailChange" object:nil];
}

#pragma mark - 增加消息中心
- (void)theAdvDetailChange:(NSNotification *)notification {
    NSDictionary *notifiationDict = [notification object];
    if (_dataList.count) {
        TheAdvMainModel *model = (TheAdvMainModel *)_dataList[[notifiationDict[@"index"] integerValue]];
        if ([notifiationDict[@"type"] integerValue] == 3) {
            model.commNum = [NSString stringWithFormat:@"%ld",(long)[model.commNum integerValue] + 1];
        }else {//总票，新增
            model.hits = [NSString stringWithFormat:@"%ld",(long)[model.hits integerValue] + 1];
            model.daysHits = [NSString stringWithFormat:@"%ld",(long)[model.daysHits integerValue] + 1];
        }
        [_dataList replaceObjectAtIndex:[notifiationDict[@"index"] integerValue] withObject:model];
    }
    
    [self.theAdvTableView reloadData];
}

- (void)headBtnClick:(UIButton *)button {
    if (_getAwardNameAndID) {
        _getAwardNameAndID(_awardName,_awardID);
    }
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.theAdvTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        page = 0;
        [_dataList removeAllObjects];
        [weakSelf loadDataWithIndexPage:page];
    }];
    
    self.theAdvTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithIndexPage:page];
    }];
    
    [self.theAdvTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [self.theAdvTableView.mj_header endRefreshing];
    [self.theAdvTableView.mj_footer endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexPage:(int)pages {
    [[AppHttpManager shareInstance] getGetPostListWithUserId:[User_ID intValue] Token:User_TOKEN Type:_showType pageIndex:pages pageSize:15 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            _awardName = dict[@"Data"][@"awardName"];
            _awardID = dict[@"Data"][@"awardId"];
            
            //判断是否添加头视图
            if (![_awardName isKindOfClass:[NSNull class]]) {
                UIView *btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, Screen_width, 34.f)];
                btnBackView.backgroundColor = [UIColor colorWithRed:247/255.0 green:204/255.0 blue:62/255.0 alpha:1];
                
                _awardBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                _awardBtn.frame = CGRectMake(0, 2, Screen_width, 30.f);
                [_awardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _awardBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [_awardBtn setTitle:[NSString stringWithFormat:@"本月冠军奖品:%@",_awardName] forState:UIControlStateNormal];
                [_awardBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btnBackView addSubview:_awardBtn];
                
                self.theAdvTableView.tableHeaderView = btnBackView;
            }
            
            for (NSDictionary * dics in dict[@"Data"][@"postList"]) {
                TheAdvMainModel * model=[[TheAdvMainModel alloc]initWithDictionary:dics error:nil];
                [_dataList addObject:model];
            }
            [self.theAdvTableView reloadData];
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            if (_netAdvBack) {
                _netAdvBack();
            }
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
        [self endRefresh];
        [self.theAdvTableView reloadData];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [self endRefresh];
    }];
}

- (void)advPKShowCollectionGetDataWithIndex:(int)indexPath {
    [self.theAdvTableView.mj_header endRefreshing];
    
    _showType = indexPath;
    [_dataList removeAllObjects];
    [self.theAdvTableView.mj_header beginRefreshing];
}

#pragma mark - UITableView 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataList.count) {
        TheAdvMainModel * model=_dataList[indexPath.section];
        if (model.postPic.count) {
            return 310.f;
        }else if (model.videoUrl.length>6) {
            return 292.f;
        }
        
        return 188.f;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheAdvMainModel * _tempModel=nil;
    if (_dataList.count) {
       _tempModel =_dataList[indexPath.section];
    }
    if (_tempModel.postPic.count) {//图片
        static NSString *TheAdvOneViewCellId = @"TheAdvOneViewCellId";
        TheAdvOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TheAdvOneViewCellId];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TheAdvOneViewCell" owner:self options:nil].lastObject;
        }
        [cell updateDataOneWithModel:_tempModel];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.iconButton.tag = 3001 + indexPath.section;
        [cell setAdvPKOneShowButtonClick:^(NSInteger index) {
            [self jumpToOtherUserInforWithIndex:index-3001];
        }];
        
        return cell;
    }else if (_tempModel.videoUrl.length >6) {// 视屏
        static NSString *TheAdvTwoViewCellID = @"TheAdvTwoViewCellID";
        TheAdvTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TheAdvTwoViewCellID];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TheAdvTwoViewCell" owner:self options:nil].lastObject;
        }
        [cell updateDataTwoWithModel:_tempModel];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.icon1Button.tag = 3001 + indexPath.section;
        [cell setAdvPKTwoShowButtonClick:^(NSInteger index) {
            [self jumpToOtherUserInforWithIndex:index-3001];
        }];
        
        return cell;
    }
    // 文字
    static NSString *TheAdvThrViewCellID = @"TheAdvThrViewCellID";
    TheAdvThrViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TheAdvThrViewCellID];

    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TheAdvThrViewCell" owner:self options:nil].lastObject;
    }
    [cell updateDataThrWithModel:_tempModel];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.icon2Button.tag = 3001 + indexPath.section;
    [cell setAdvPKThrShowButtonClick:^(NSInteger index) {
        [self jumpToOtherUserInforWithIndex:index-3001];
    }];
    
    return cell;
}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataList.count) {
        TheAdvMainModel *model = (TheAdvMainModel *)_dataList[indexPath.section];
        if (_theAdvPKCollectionView) {
            _theAdvPKCollectionView(model,indexPath.section);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - 跳转界面
- (void)jumpToOtherUserInforWithIndex:(NSInteger)index {
    TheAdvMainModel *model = (TheAdvMainModel *)_dataList[index];
    
    if (_jumpToOtherInformation) {
        _jumpToOtherInformation(model);
    }
}



@end
