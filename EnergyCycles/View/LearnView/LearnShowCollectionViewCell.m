//
//  LearnShowCollectionViewCell.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LearnShowCollectionViewCell.h"

#import "LearnOneViewCell.h"
#import "LearnTwoTableViewCell.h"

@interface LearnShowCollectionViewCell () <UITableViewDataSource,UITableViewDelegate> {
    NSString *cellIndexStr;
    
    int page;
    NSMutableArray *_dataArr;
    NSMutableArray * _zanArray;
    NSMutableArray * _caiArray;
}

@end

@implementation LearnShowCollectionViewCell

- (void)awakeFromNib {
    _dataArr = [[NSMutableArray alloc] init];
    
    self.learnShowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.learnShowTableView.backgroundColor = [UIColor clearColor];
    self.learnShowTableView.showsVerticalScrollIndicator = NO;
    self.learnShowTableView.dataSource = self;
    self.learnShowTableView.delegate = self;
    
    [self setUpMJRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(learnNotification:) name:@"isLearnNotification" object:nil];

    //增加消息中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(learnDetailChange:) name:@"isLearnDetailChange" object:nil];
}

#pragma mark - 增加消息中心
- (void)learnDetailChange:(NSNotification *)notification {
    NSDictionary *notifiationDict = [notification object];
    if (_dataArr.count) {
        LearnViewShowModel *model = (LearnViewShowModel *)_dataArr[[notifiationDict[@"index"] integerValue]];
        if ([notifiationDict[@"type"] integerValue] == 4) {
            model.readCount = [NSString stringWithFormat:@"%ld",(long)[model.readCount integerValue] + 1];
        }else if ([notifiationDict[@"type"] integerValue] == 3) {
            model.CommentCount = [NSString stringWithFormat:@"%ld",(long)[model.CommentCount integerValue] + 1];
        }else if ([notifiationDict[@"type"] integerValue] == 2) {//踩
            if ([model.isBad integerValue] == 0) {
                model.isBad = @"1";
                model.BadCount = [NSString stringWithFormat:@"%ld",(long)[model.BadCount integerValue] + 1];
            }else {
                model.isBad = @"0";
                if ([model.BadCount integerValue] -1 < 0) {
                    model.isBad = @"0";
                }else {
                    model.BadCount = [NSString stringWithFormat:@"%ld",(long)[model.BadCount integerValue] - 1];
                }
            }
        }else {//赞
            if ([model.isGood integerValue] == 0) {
                model.isGood = @"1";
                model.GoodCount = [NSString stringWithFormat:@"%ld",(long)[model.GoodCount integerValue] + 1];
            }else {
                model.isGood = @"0";
                if ([model.GoodCount integerValue] -1 < 0) {
                    model.isGood = @"0";
                }else {
                    model.GoodCount = [NSString stringWithFormat:@"%ld",(long)[model.GoodCount integerValue] - 1];
                }
            }
        }
        [_dataArr replaceObjectAtIndex:[notifiationDict[@"index"] integerValue] withObject:model];
    }
    
    [self.learnShowTableView reloadData];
}

- (void)learnNotification:(NSNotification *)notification {
    [self.learnShowTableView.mj_header beginRefreshing];
}

#pragma mark - 获取index
- (void)creatCollectionViewWithIndex:(NSString *)indexStr {
    cellIndexStr = indexStr;
    [_dataArr removeAllObjects];
    [self.learnShowTableView.mj_header beginRefreshing];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.learnShowTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 0;
        [_dataArr removeAllObjects];
        [weakSelf loadDataWithIndexWithType:cellIndexStr Page:page];
    }];
    
    self.learnShowTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithIndexWithType:cellIndexStr Page:page];
    }];
    [self.learnShowTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [self.learnShowTableView.mj_header endRefreshing];
    [self.learnShowTableView.mj_footer endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexWithType:(NSString *)type Page:(int)pages {
    [[AppHttpManager shareInstance] getGetStudyListByTabWithTabName:type PostOrGet:@"get" useId:[User_ID intValue] withPage:pages withSize:10 success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if (pages == 0) {
                [_dataArr removeAllObjects];
            }
            for (NSDictionary *subDict in dict[@"Data"]) {
                LearnViewShowModel *model = [[LearnViewShowModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            if(_dataArr.count){
             [self.learnShowTableView reloadData];
            }
            [self endRefresh];
            
            if ([dict[@"Data"] count] <= 0) {
                if (pages == 0) {
                    [SVProgressHUD showImage:nil status:@"暂时还没有课程"];
                }else {
                    [SVProgressHUD showImage:nil status:@"没有更多的数据了~"];
                }
            }
        }else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        [self endRefresh];
         page--;
        [self.learnShowTableView reloadData];
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
    if (_dataArr.count) {
        LearnViewShowModel *model = (LearnViewShowModel *)_dataArr[indexPath.row];
        CGRect rect = [model.studyType boundingRectWithSize:CGSizeMake(SIZE_MAX, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] context:nil];
        CGFloat titleHight = [self textHeightFromTextString:model.title width:Screen_width-(12+rect.size.width+10+5) fontSize:16];
        CGFloat summaryHight = [self textHeightFromTextString:model.summary width:Screen_width-24 fontSize:14];
        
        if (summaryHight <= 17.f) {
            return titleHight + 292.f;
        }
        return titleHight + summaryHight + 292.f;
    }
    
    return 0.01f;
}
//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LearnOneViewCellId = @"LearnOneViewCellId";
    LearnOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LearnOneViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LearnOneViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    if (_dataArr.count) {
        LearnViewShowModel *model = (LearnViewShowModel *)_dataArr[indexPath.row];
        [cell updateWithModel:model];
        
        cell.zanButton.tag=indexPath.row+999;
        cell.caiButton.tag=indexPath.row+1001;
        
        cell.zanButton.selected=NO;
        cell.caiButton.selected=NO;
        cell.commentButton.userInteractionEnabled = NO;
        if ([model.isGood intValue]>0) {
            cell.zanButton.selected=YES;
        }
        if ([model.isBad intValue]>0) {
            cell.caiButton.selected=YES;
        }
        
        [cell.zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.caiButton addTarget:self action:@selector(caiButtonClicks:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count) {
        LearnViewShowModel *model = (LearnViewShowModel *)_dataArr[indexPath.row];
        if (_learnShowSelectCell) {
            _learnShowSelectCell(model,cellIndexStr,indexPath.row);
        }
    }
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)zanButtonClick:(UIButton *)sender {
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        NSInteger index = sender.tag-999;
        LearnViewShowModel *model = (LearnViewShowModel *)_dataArr[index];
        
        if ([model.isBad integerValue] == 0) {
            if (sender.selected==NO) {
                model.isGood = @"1";
                sender.selected = YES;
                model.GoodCount = [NSString stringWithFormat:@"%d",[model.GoodCount intValue]+1];
            }else{
                model.isGood = @"0";
                sender.selected = NO;
                model.GoodCount = [NSString stringWithFormat:@"%d",[model.GoodCount intValue]-1];
            }
        }else {
            [SVProgressHUD showImage:nil status:@"赞和踩只能有一个哦."];
        }
        
        [_learnShowTableView reloadData];
        [self zanOrCaiWithType:1 artId:[model.learnId intValue]];
    }
}

- (void)caiButtonClicks:(UIButton *)sender {
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        NSInteger index = sender.tag-1001;
        LearnViewShowModel *model = (LearnViewShowModel *)_dataArr[index];
        
        if ([model.isGood integerValue] == 0) {
            if (sender.selected == NO) {
                model.isBad = @"1";
                sender.selected = YES;
                model.BadCount = [NSString stringWithFormat:@"%d",[model.BadCount intValue]+1];
            }else{
                model.isBad = @"0";
                sender.selected = NO;
                model.BadCount = [NSString stringWithFormat:@"%d",[model.BadCount intValue]-1];
            }
        }else {
            [SVProgressHUD showImage:nil status:@"赞和踩只能有一个哦."];
        }
        
        [_learnShowTableView reloadData];
        [self zanOrCaiWithType:2 artId:[model.learnId intValue]];
    }
}

- (void)zanOrCaiWithType:(int)type artId:(int)artId {
    [[AppHttpManager shareInstance] getStudyAddLikeOrNoLikeWithType:type articleId:artId userId:[User_ID intValue] token:User_TOKEN PostOrGet:@"post" success:^(NSDictionary *dict) {
        NSLog(@"%@",dict[@"Msg"]);
        [_learnShowTableView reloadData];
    } failure:^(NSString *str) {
        
    }];
}

////根据字符串的实际内容的多少,在固定的宽度和字体的大小,动态的计算出实际的高度
- (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size {
    // 设置行间距
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size],NSParagraphStyleAttributeName:paragraphStyle1};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    //返回计算出的行高
    return rect.size.height;
}


@end
