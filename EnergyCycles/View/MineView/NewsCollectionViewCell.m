 //
//  NewsCollectionViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "NewsCollectionViewCell.h"

#import "NewsOneViewCell.h"
#import "NewsTwoViewCell.h"
#import "GifHeader.h"

@interface NewsCollectionViewCell () <UITableViewDataSource,UITableViewDelegate> {
    NSInteger touchIndex;
    NSMutableArray *_dataArr;
    NSMutableArray *_messageArr;
}

@end

@implementation NewsCollectionViewCell

- (void)awakeFromNib {
    self.myNewsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myNewsTableView.showsHorizontalScrollIndicator = NO;
    self.myNewsTableView.showsVerticalScrollIndicator = NO;
    self.myNewsTableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    self.myNewsTableView.dataSource = self;
    self.myNewsTableView.delegate = self;
    
    _dataArr = [[NSMutableArray alloc] init];
    _messageArr = [[NSMutableArray alloc] init];
    [self setUpMJRefresh];
    
    //增加消息中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsDetailChange:) name:@"isNewsDetailChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsRefresh:) name:@"isNewsRefresh" object:nil];
}

#pragma mark - 增加消息中心
- (void)newsDetailChange:(NSNotification *)notification {
    NSDictionary *notifiationDict = [notification object];
    if (_dataArr.count) {
        //通知 活动
        InformationModel *inforModel = (InformationModel *)_dataArr[[notifiationDict[@"index"] integerValue]];
        inforModel.NotifyIsRead = @"1";
        
        [_dataArr replaceObjectAtIndex:[notifiationDict[@"index"] integerValue] withObject:inforModel];
        [self.myNewsTableView reloadData];
    }
}

- (void)newsRefresh:(NSNotification *)notification {
    [self.myNewsTableView.mj_header beginRefreshing];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.myNewsTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithIndexType:touchIndex];
    }];
    
    [self.myNewsTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [self.myNewsTableView.mj_header endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexType:(NSInteger)type {
    if (type != 1) {
        NSString *postType = @"通知";
        if (type == 2) {
            postType = @"活动";
        }
        
        [[AppHttpManager shareInstance] getGetMessageWithType:postType userid:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [_dataArr removeAllObjects];
                for (NSDictionary *subDict in dict[@"Data"]) {
                    InformationModel *model = [[InformationModel alloc] initWithDictionary:subDict error:nil];
                    [_dataArr addObject:model];
                }
                
                if ([postType isEqualToString:@"通知"]) {
                    NSArray *subArr = [NSArray arrayWithArray:_dataArr];
                    [_dataArr removeAllObjects];
                    for (InformationModel *model in subArr) {
                        model.NotifyIsRead = @"1";
                        [_dataArr addObject:model];
                    }
                }
                [self endRefresh];
            }else if ([dict[@"Code"] integerValue] == 10000) {
                [SVProgressHUD showImage:nil status:@"登录失效"];
                if (_netBack) {
                    _netBack();
                }
            }else {
                [self endRefresh];
            }
            [self.myNewsTableView reloadData];
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
            [self endRefresh];
        }];
    }else {
        [[AppHttpManager shareInstance] getGetTopOnePeopleWithUserid:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [_messageArr removeAllObjects];
                NSMutableArray *subArr = [[NSMutableArray alloc] init];
                for (NSDictionary *subDict in dict[@"Data"]) {
                    MessageModel *model = [[MessageModel alloc] initWithDictionary:subDict error:nil];
                    [subArr addObject:model];
                }
                
                for (NSInteger i=subArr.count-1; i>=0; i--) {
                    MessageModel *model = (MessageModel *)subArr[i];
                    [_messageArr addObject:model];
                }
                
                [self endRefresh];
            }else if ([dict[@"Code"] integerValue] == 10000) {
                [SVProgressHUD showImage:nil status:@"登录失效"];
                if (_netBack) {
                    _netBack();
                }
            }else {
                [self endRefresh];
            }
            [self.myNewsTableView reloadData];
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
            [self endRefresh];
        }];
    }
}

#pragma mark - 获取网络数据
- (void)creatInformationCollectionViewWithIndex:(NSInteger)index {
    touchIndex = index;
    [self endRefresh];
    [self.myNewsTableView.mj_header beginRefreshing];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (touchIndex == 1) {
        return _messageArr.count;
    }
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (touchIndex != 1) {
        InformationModel *model = (InformationModel *)_dataArr[indexPath.row];
        if ([model.NotifyIsRead integerValue] == 0) {
            static NSString *NewsOneViewCellIId = @"NewsOneViewCellIId";
            NewsOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsOneViewCellIId];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"NewsOneViewCell" owner:self options:nil].lastObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titleLabel.text = model.NotifyTitle;
            if (touchIndex == 0) {
                cell.titleLabel.numberOfLines = 1;
                cell.informationLabel.text = model.NotifyContent;
            }else {
                cell.titleLabel.numberOfLines = 2;
                cell.informationLabel.text = @"";
            }
            
            NSArray *timeArr = [model.NotifyTime componentsSeparatedByString:@"T"];
            NSArray *subTimeArr = [timeArr.firstObject componentsSeparatedByString:@"-"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@/%@/%@",subTimeArr.firstObject,subTimeArr[1],subTimeArr.lastObject];
            cell.nickNameLabel.text = @"";
            
            return cell;
        }else {
            static NSString *NewsTwoViewCellId = @"NewsTwoViewCellId";
            NewsTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsTwoViewCellId];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"NewsTwoViewCell" owner:self options:nil].lastObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titleLabel.text = model.NotifyTitle;
            if (touchIndex == 0) {
                cell.titleLabel.numberOfLines = 1;
                cell.informationLabel.text = model.NotifyContent;
            }else {
                cell.titleLabel.numberOfLines = 2;
                cell.informationLabel.text = @"";
            }
            
            NSArray *timeArr = [model.NotifyTime componentsSeparatedByString:@"T"];
            NSArray *subTimeArr = [timeArr.firstObject componentsSeparatedByString:@"-"];
            cell.readPointImageView.text = [NSString stringWithFormat:@"%@/%@/%@",subTimeArr.firstObject,subTimeArr[1],subTimeArr.lastObject];
            cell.nicknameLabel.text = @"";
            
            return cell;
        }
    }
    
    MessageModel *model = (MessageModel *)_messageArr[indexPath.row];
    if ([model.MessageIsRead integerValue] == 0) {
        static NSString *NewsOneViewCellIId = @"NewsOneViewCellIId";
        NewsOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsOneViewCellIId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NewsOneViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = model.MessageContent;
        cell.titleLabel.numberOfLines = 2;
        cell.informationLabel.text = @"";
        
        NSArray *timeArr = [model.MessageTime componentsSeparatedByString:@"T"];
        NSArray *subTimeArr = [timeArr.firstObject componentsSeparatedByString:@"-"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@/%@/%@",subTimeArr.firstObject,subTimeArr[1],subTimeArr.lastObject];
        cell.nickNameLabel.text = model.nickname;
        
        return cell;
    }
    static NSString *NewsTwoViewCellId = @"NewsTwoViewCellId";
    NewsTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsTwoViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NewsTwoViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = model.MessageContent;
    cell.titleLabel.numberOfLines = 2;
    cell.informationLabel.text = @"";
    
    NSArray *timeArr = [model.MessageTime componentsSeparatedByString:@"T"];
    NSArray *subTimeArr = [timeArr.firstObject componentsSeparatedByString:@"-"];
    cell.readPointImageView.text = [NSString stringWithFormat:@"%@/%@/%@",subTimeArr.firstObject,subTimeArr[1],subTimeArr.lastObject];
    cell.nicknameLabel.text = model.nickname;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (touchIndex == 1) {//私信
//        MessageModel *model = (MessageModel *)_messageArr[indexPath.row];
//        if (_MessageShowSelectCell) {
//            _MessageShowSelectCell(model,indexPath.row);
//        }
    }else if (touchIndex == 0) {//通知
        InformationModel *model = (InformationModel *)_dataArr[indexPath.row];
        if (_InformationShowSelectCell) {
            _InformationShowSelectCell(model,indexPath.row);
        }
    }else {//活动
        InformationModel *model = (InformationModel *)_dataArr[indexPath.row];
        if (_ActiveShowSelectCell) {
            _ActiveShowSelectCell(model,indexPath.row);
        }
    }
}


@end
