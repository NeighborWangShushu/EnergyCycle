//
//  NewsTwoCollectionViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NewsTwoCollectionViewCell.h"

#import "NewsOneViewCell.h"
#import "NewsTwoViewCell.h"
#import "GifHeader.h"

@interface NewsTwoCollectionViewCell () <UITableViewDataSource,UITableViewDelegate> {
    NSInteger touchIndex;
    NSMutableArray *_messageArr;
}

@end

@implementation NewsTwoCollectionViewCell

- (void)awakeFromNib {
    self.myNewsSiXinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myNewsSiXinTableView.showsHorizontalScrollIndicator = NO;
    self.myNewsSiXinTableView.showsVerticalScrollIndicator = NO;
    self.myNewsSiXinTableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    self.myNewsSiXinTableView.dataSource = self;
    self.myNewsSiXinTableView.delegate = self;
    
    _messageArr = [[NSMutableArray alloc] init];
    [self setUpMJRefresh];
    
    //增加消息中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsTwoDetailChange:) name:@"isNewsTwoDetailChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsRefresh:) name:@"isNewsRefresh" object:nil];
}

#pragma mark - 增加消息中心
- (void)newsTwoDetailChange:(NSNotification *)notification {
    NSDictionary *notifiationDict = [notification object];
    if (_messageArr.count) {//消息
        MessageModel *messageModel = (MessageModel *)_messageArr[[notifiationDict[@"index"] integerValue]];
        messageModel.MessageIsRead = @"1";
        
        [_messageArr replaceObjectAtIndex:[notifiationDict[@"index"] integerValue] withObject:messageModel];
        [self.myNewsSiXinTableView reloadData];
    }
}

- (void)newsRefresh:(NSNotification *)notification {
    [self.myNewsSiXinTableView.mj_header beginRefreshing];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.myNewsSiXinTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithIndexType:touchIndex];
    }];
    
    [self.myNewsSiXinTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [self.myNewsSiXinTableView.mj_header endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexType:(NSInteger)type {
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
                model.MessageContent = [model.MessageContent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [_messageArr addObject:model];
            }
            
            [self endRefresh];
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            if (_netTwoBack) {
                _netTwoBack();
            }
        }else {
            [self endRefresh];
        }
        [self.myNewsSiXinTableView reloadData];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [self endRefresh];
    }];
}

#pragma mark - 获取网络数据
- (void)creatInformationCollectionViewWithIndex:(NSInteger)index {
    touchIndex = index;
    [self endRefresh];
    [self.myNewsSiXinTableView.mj_header beginRefreshing];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    MessageModel *model = (MessageModel *)_messageArr[indexPath.row];
    if (_MessageTwoShowSelectCell) {
        _MessageTwoShowSelectCell(model,indexPath.row);
    }
}


@end
