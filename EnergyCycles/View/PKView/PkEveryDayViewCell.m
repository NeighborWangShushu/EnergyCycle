//
//  PkEveryDayViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PkEveryDayViewCell.h"

#include "EveryPKTableViewCell.h"
#import "EveryDayPKViewCell.h"
#import "GifHeader.h"
#import "UserModel.h"

@interface PkEveryDayViewCell () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> {
    int page;
    NSMutableArray *_dataArr;
    EveryDayPKModel *myModel;
    
    UIImageView *subHeadImageView;
    UILabel *subLabel;
    UILabel *paimingLabel;
    UILabel *nameLabel;
    UILabel *classLabel;
    
    UIView *subHeadView;
}

@property (nonatomic, strong) UserModel *model;

@end


@implementation PkEveryDayViewCell

- (void)awakeFromNib {
    self.backImageView.image = [UIImage imageNamed:@""];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    _dataArr = [[NSMutableArray alloc] init];
    
    pkEveryDayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    pkEveryDayTableView.backgroundColor = [UIColor clearColor];
    pkEveryDayTableView.dataSource = self;
    pkEveryDayTableView.delegate = self;
    pkEveryDayTableView.showsVerticalScrollIndicator = NO;
    
    [self getUserInfo];
    //
//    [self setUpMJRefresh];
    
    //上面显示
    UIView *upBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, Screen_width, 40)];
    upBackView.backgroundColor = [UIColor clearColor];
    [self.backImageView addSubview:upBackView];
    
    CGFloat imageXStart = 101*Screen_width/375;
    subHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageXStart, 0, 28, 28)];
    subHeadImageView.layer.masksToBounds = YES;
    subHeadImageView.layer.cornerRadius = 14;
    [upBackView addSubview:subHeadImageView];
    
    subLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageXStart+28+10, 3, Screen_width-(imageXStart+28+10), 21)];
    subLabel.textColor = [UIColor whiteColor];
    subLabel.font = [UIFont systemFontOfSize:15];
    subLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [upBackView addSubview:subLabel];
    
//    //底部显示
//    UIView *downBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 220, Screen_width, 40)];
//    downBackView.backgroundColor = [UIColor clearColor];
//    [self.backImageView addSubview:downBackView];
//    
//    paimingLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 10, 100, 20)];
//    paimingLabel.font = [UIFont systemFontOfSize:19];
//    paimingLabel.textColor = [UIColor whiteColor];
//    [downBackView addSubview:paimingLabel];
//    CGSize size = [paimingLabel systemLayoutSizeFittingSize:CGSizeMake(MAXFLOAT, 0)];
//    paimingLabel.frame = CGRectMake(4, 19, size.width, 20);
//    
//    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(size.width+10, 20, 100, 20)];
//    nameLabel.font = [UIFont systemFontOfSize:16];
//    nameLabel.textColor = [UIColor whiteColor];
//    [downBackView addSubview:nameLabel];
//    
//    classLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_width-100-12, 20, 100, 20)];
//    classLabel.textAlignment = NSTextAlignmentRight;
//    classLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
//    [downBackView addSubview:classLabel];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    pkEveryDayTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        page = 0;
        [_dataArr removeAllObjects];
        [weakSelf loadDataWithIndexWithProjectId:[myModel.PKId integerValue] Page:page];
    }];
    
    pkEveryDayTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithIndexWithProjectId:[myModel.PKId integerValue] Page:page];
    }];
    
    [pkEveryDayTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [pkEveryDayTableView.mj_header endRefreshing];
    [pkEveryDayTableView.mj_footer endRefreshing];
}

- (void)getUserInfo {
    [[AppHttpManager shareInstance] getGetInfoByUseridWithUserid:[NSString stringWithFormat:@"%@", User_ID] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if ([dict[@"Data"] count]) {
                for (NSDictionary *subDict in dict[@"Data"]) {
                    self.model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setUpMJRefresh];
                });
            }
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}


//加载网络数据
- (void)loadDataWithIndexWithProjectId:(NSInteger)projectId Page:(int)pages {
    [[AppHttpManager shareInstance] getGetReportListWithUserid:User_ID Token:User_TOKEN projectId:[NSString stringWithFormat:@"%ld",(long)projectId] pageInex:pages pageSize:15 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if (pages == 0) {
            [_dataArr removeAllObjects];
        }
        if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            if (_netBackEvery) {
                _netBackEvery();
            }
        }else if ([dict[@"Data"] count] > 1 || (pages == 0 && [dict[@"Data"] count] > 0)) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                for (NSDictionary *subDict in dict[@"Data"]) {
                    EveryDPKPMModel *model = [[EveryDPKPMModel alloc] initWithDictionary:subDict error:nil];
                    [_dataArr addObject:model];
                }
                
                if (_dataArr.count > 1) {
                    EveryDPKPMModel *model = (EveryDPKPMModel *)_dataArr[1];
                    [subHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.photourl] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
                    if ([self.model.BackgroundImg isEqualToString:@""] || self.model.BackgroundImg == nil) {
                        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.pkImg] placeholderImage:[UIImage imageNamed:@"placepic.png"]];
                    } else {
                        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.model.BackgroundImg]];
                    }
                    
                    subLabel.text = [NSString stringWithFormat:@"%@ 占领了你的首页",model.nickname];
                }else {
                    EveryDPKPMModel *model = (EveryDPKPMModel *)_dataArr[0];
                    [subHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.photourl] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
                    if ([self.model.BackgroundImg isEqualToString:@""] || self.model.BackgroundImg == nil) {
                        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.pkImg] placeholderImage:[UIImage imageNamed:@"placepic.png"]];
                    } else {
                        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.model.BackgroundImg]];
                    }
                    subLabel.text = [NSString stringWithFormat:@"%@ 占领了你的首页",model.nickname];
                }
            }else if ([dict[@"Code"] integerValue] == 1000) {
                subHeadImageView.image = [UIImage imageNamed:@""];
                subLabel.text = @"";
                paimingLabel.text = @"";
                nameLabel.text = @"";
                classLabel.text = @"";
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
            [pkEveryDayTableView reloadData];
        }else {
            [SVProgressHUD showImage:nil status:@"没有更多数据"];
        }
        
        [self endRefresh];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [self endRefresh];
    }];
}

#pragma mark - 填充数据
- (void)pkShowCollectionGetDataWithIndex:(EveryDayPKModel *)model {
    myModel = model;
    
    [pkEveryDayTableView.mj_header beginRefreshing];
}

#pragma mark - UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 65.f;
    }
    return 70.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *EveryDayPKViewCellid = @"EveryDayPKViewCellid";
        EveryDayPKViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EveryDayPKViewCellid];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"EveryDayPKViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_dataArr.count) {
            EveryDPKPMModel *model = _dataArr[indexPath.row];
            
            cell.paimingLabel.text = model.orderNum;
            cell.nameLabel.text = model.nickname;
            cell.classLabel.text = [NSString stringWithFormat:@"%@%@",model.repItemNum,model.unit];
        }

        return cell;
    }
    
    static NSString *EveryPKTableViewCellId = @"EveryPKTableViewCellId";
    EveryPKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EveryPKTableViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"EveryPKTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.pkEveryBackImageView.image = [UIImage imageNamed:@"cellbg.png"];
    
    cell.headButton.tag = 2001 + indexPath.row;
    [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //点赞,取消赞
    [cell setZanButtonClick:^(NSInteger cellTouchIndex) {
        EveryDPKPMModel *model = (EveryDPKPMModel *)_dataArr[cellTouchIndex+1];
        [self touchZanWithModel:model withIndex:cellTouchIndex+1];
    }];
    
    cell.lingProgressView.progress = 0.0;
    static float progress = 0;
    if (_dataArr.count) {
        EveryDPKPMModel *model = (EveryDPKPMModel *)_dataArr[indexPath.row];
        [cell updateEveryDayPKDataWithIndex:indexPath.row-1 withModel:model];
        
        if (indexPath.row == 1) {
            progress = [model.repItemNum floatValue];
        }
        if (indexPath.row != 0) {
//            cell.withImageView.hidden = NO;
//            cell.withRightAutoLayout.constant = 52.f;
            if (indexPath.row == 1) {
                if (progress >= 0) {
                    cell.lingProgressView.progress = 1.0;
                }else {
                    cell.lingProgressView.progress = 0.0;
//                    cell.withImageView.hidden = YES;
                }
            }else {
                if (progress == 0) {
                    cell.lingProgressView.progress = 0.0;
//                    cell.withImageView.hidden = YES;
                }else {
                    cell.lingProgressView.progress = [model.repItemNum floatValue]/progress;
//                    if ([model.repItemNum floatValue]/progress <0.5) {
//                        cell.withImageView.hidden = YES;
//                    }else {
//                        cell.withRightAutoLayout.constant = 177*(Screen_width/320)*(1-[model.repItemNum floatValue]/progress)+52;
//                    }
                }
            }
        }
    }
    
    return cell;
}
//头视图
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 260.f;
}
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    subHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 260)];
    subHeadView.backgroundColor = [UIColor whiteColor];
    subHeadView.alpha = 0.0;
    
    return subHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count && indexPath.row != 0) {
        EveryDPKPMModel *model = (EveryDPKPMModel *)_dataArr[indexPath.row];
        if (_otherCellTouch) {
            _otherCellTouch(model);
        }
    }else {
        if (_jumpToMineEveryDayPK) {
            _jumpToMineEveryDayPK();
        }
    }
}

#pragma mark - 头像点击事件,跳转到指定用户界面
- (void)headButtonClick:(UIButton *)button {
    if (_dataArr.count) {
        EveryDPKPMModel *model = (EveryDPKPMModel *)_dataArr[button.tag - 2001];
        if (_headButtonTouchu) {
            _headButtonTouchu(model);
        }
    }
}

#pragma mark - 点赞,取消点赞
- (void)touchZanWithModel:(EveryDPKPMModel *)model withIndex:(NSInteger)index {
    int type = 2;
    if ([model.haslike integerValue] == 0) {
        type = 1;
    }else {
        type = 2;
    }
    
    [[AppHttpManager shareInstance] getZanReportItemWithType:type UserId:[User_ID intValue] Token:User_TOKEN RepItemId:[model.repItemId intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            EveryDPKPMModel *subModel = (EveryDPKPMModel *)_dataArr[index];
            if (type == 2) {
                subModel.haslike = @"0";
                [SVProgressHUD showImage:nil status:@"取消赞"];
            }else {
                subModel.haslike = @"1";
                [SVProgressHUD showImage:nil status:@"点赞成功"];
            }
            
            [_dataArr replaceObjectAtIndex:index withObject:subModel];
            [pkEveryDayTableView reloadData];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        subHeadView.alpha = 0.0;
    }else {
        subHeadView.alpha = 1 * scrollView.contentOffset.y/260.f;
    }
}


@end
