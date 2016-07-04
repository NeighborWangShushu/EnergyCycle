//
//  SocialCollectionViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SocialCollectionViewCell.h"

#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"

#import "SoicalTableViewCell.h"
#import "CoustomGiftView.h"
#import "SetNoteNameView.h"
#import "GifHeader.h"

@interface SocialCollectionViewCell () <MGSwipeTableCellDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate> {
    NSInteger touchType;
    NSMutableArray *_dataArr;
    NSInteger cellTouchuIndex;
}

@end

@implementation SocialCollectionViewCell

- (void)awakeFromNib {
    _dataArr = [[NSMutableArray alloc] init];
    
    self.socialTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.socialTableView.showsHorizontalScrollIndicator = NO;
    self.socialTableView.showsVerticalScrollIndicator = NO;
    self.socialTableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    self.socialTableView.dataSource = self;
    self.socialTableView.delegate = self;
    
    [self setUpMJRefresh];
}
//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.socialTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        [weakSelf getNetDataWithType:touchType];
    }];
}
//结束刷新
- (void)endRefresh {
    [self.socialTableView.mj_header endRefreshing];
}

#pragma mark - 获取数据
- (void)updateDataWithType:(NSInteger)type withIsRefresh:(BOOL)isRefresh {
    touchType = type;
    if (isRefresh) {
        [self.socialTableView.mj_header beginRefreshing];
    }
}

#pragma mark - 获取网络数据
- (void)getNetDataWithType:(NSInteger)type {
    touchType = type;
    
    [_dataArr removeAllObjects];
    [self.socialTableView reloadData];
    
    if (type == 0) {//好友
        [[AppHttpManager shareInstance] getBothHeartWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
            [_dataArr removeAllObjects];
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                for (NSDictionary *subDict in dict[@"Data"]) {
                    UserModel *model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                    [_dataArr addObject:model];
                }
                [self endRefresh];
                [self.socialTableView reloadData];
            }else {
                [self endRefresh];
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
            [self endRefresh];
        }];
    }else if (type == 1) {//关注
        [[AppHttpManager shareInstance] getMyHeartWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
            [_dataArr removeAllObjects];
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                for (NSDictionary *subDict in dict[@"Data"]) {
                    UserModel *model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                    [_dataArr addObject:model];
                }
                [self endRefresh];
                [self.socialTableView reloadData];
            }else {
                [self endRefresh];
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
            [self endRefresh];
        }];
    }else {//粉丝
        [[AppHttpManager shareInstance] getHeartMeWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
            [_dataArr removeAllObjects];
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                for (NSDictionary *subDict in dict[@"Data"]) {
                    UserModel *model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                    [_dataArr addObject:model];
                }
                [self endRefresh];
                [self.socialTableView reloadData];
            }else {
                [self endRefresh];
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
            [self endRefresh];
        }];
    }
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SoicalTableViewCellId = @"SoicalTableViewCellId";
    SoicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SoicalTableViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SoicalTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.tag = 4101 + indexPath.row;
    cell.rightButtons = [self creatRightDelegate];
    
    if (_dataArr.count) {
        UserModel *model = (UserModel *)_dataArr[indexPath.row];
        cell.nameLabel.text = model.nickname;
        [cell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.photourl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
        
        [cell.rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
        cell.rightButton.userInteractionEnabled = YES;
        
        //头像点击事件
        [cell setSoicalHeadButtonClick:^(NSInteger index) {
            if (_soicalTouchIndex) {
                _soicalTouchIndex(model);
            }
        }];
        
        //认证期数（一阶 二阶   三阶）
        //老学员认证 状态 --> 审核通过 审核未通过 待审核 ""
        cell.prizeImageView.image = [UIImage imageNamed:@""];
        NSString *verCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserVerifyCount"];
        if ([verCount length] > 0) {
            if (!(model.VerifyCount == nil || [model.VerifyCount isKindOfClass:[NSNull class]] || [model.VerifyCount isEqual:[NSNull null]] || [model.VerifyCount length] <= 0)) {
                if ([model.VerifyCount isEqualToString:@"一阶"]) {
                    cell.prizeImageView.image = [UIImage imageNamed:@"jiangpai04.png"];
                }else if ([model.VerifyCount isEqualToString:@"二阶"]) {
                    cell.prizeImageView.image = [UIImage imageNamed:@"jiangpai02.png"];
                }else if ([model.VerifyCount isEqualToString:@"三阶"]) {
                    cell.prizeImageView.image = [UIImage imageNamed:@"jiangpai03.png"];
                }
            }
        }
        
        if (touchType == 0) {
            [cell.rightButton setImage:[[UIImage imageNamed:@"yingbi.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [cell.rightButton setTitle:@"送礼" forState:UIControlStateNormal];
        }else if (touchType == 1) {
            [cell.rightButton setImage:[[UIImage imageNamed:@"yingbi.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [cell.rightButton setTitle:@"送礼" forState:UIControlStateNormal];
        }else {
            if ([model.isFriend integerValue] == 0) {
                [cell.rightButton setImage:[[UIImage imageNamed:@"45tianjia01.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                [cell.rightButton setTitle:@"关注" forState:UIControlStateNormal];
            }else {
                [cell.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.rightButton setBackgroundColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1]];
                
                [cell.rightButton setImage:[[UIImage imageNamed:@"46gou_.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                [cell.rightButton setTitle:@"已关注" forState:UIControlStateNormal];
                cell.rightButton.userInteractionEnabled = NO;
            }
        }
        
        [cell setSoicalButtonClick:^(NSInteger index) {
            UserModel *model = (UserModel *)_dataArr[index-4101];
            __block NSString *otherId = model.use_id;
            
            if (touchType != 2) {
                CoustomGiftView *coustomView = [[CoustomGiftView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height) withNickName:model.nickname];
                
                __weak CoustomGiftView *weakCusotm = coustomView;
                [coustomView setCustomGitView:^(NSString *str, NSInteger index) {
                    if (index != 0) {//确定
                        [[AppHttpManager shareInstance] getSendJifenWithUserid:[User_ID intValue] withUseredId:[otherId intValue] Jifen:[str intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
                            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                                [SVProgressHUD showImage:nil status:@"赠送成功"];
                                
                                int jifen = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserJiFen"] intValue] - [str intValue];
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",jifen] forKey:@"UserJiFen"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                            }else {
                                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                            }
                        } failure:^(NSString *str) {
                            NSLog(@"%@",str);
                        }];
                    }
                    [weakCusotm removeFromSuperview];
                }];
                
                [[UIApplication sharedApplication].keyWindow addSubview:coustomView];
            }else {
                [[AppHttpManager shareInstance] getAddOrCancelFriendWithType:1 UserId:[User_ID intValue] Token:User_TOKEN OUserId:[model.use_id intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
                    if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                        [SVProgressHUD showImage:nil status:@"关注成功"];
                        [self.socialTableView.mj_header beginRefreshing];
                    }else {
                        [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                    }
                } failure:^(NSString *str) {
                    NSLog(@"%@",str);
                }];
            }
        }];
    }
    cell.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    return cell;
}

#pragma mark -
- (NSArray *)creatRightDelegate {
    NSMutableArray *buttonArr = [[NSMutableArray alloc] init];
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor colorWithRed:246/255.0 green:100/255.0 blue:98/255.0 alpha:1] callback:^BOOL(MGSwipeTableCell *sender) {
        [self creatActionSheetWithTag:sender.tag];
        return 1;
    }];
    [buttonArr addObject:button];
    
    if (touchType == 0) {
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"备注" backgroundColor:[UIColor colorWithRed:46/255.0 green:49/255.0 blue:50/255.0 alpha:0.3] callback:^BOOL(MGSwipeTableCell *sender) {
            [self setFirendNameWithTag:sender.tag];
            return 1;
        }];
        [buttonArr addObject:button];
    }
    
    
    return buttonArr;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    return YES;
}

- (void)swipeTableCellWillBeginSwiping:(MGSwipeTableCell *)cell {
    SoicalTableViewCell *soCell = (SoicalTableViewCell *)[self viewWithTag:cell.tag];
    soCell.rightButton.hidden = YES;
}

- (void)swipeTableCellWillEndSwiping:(MGSwipeTableCell *)cell {
    SoicalTableViewCell *soCell = (SoicalTableViewCell *)[self viewWithTag:cell.tag];
    soCell.rightButton.hidden = NO;
}

#pragma mark - 设置备注名
- (void)setFirendNameWithTag:(NSInteger)tag {
    SetNoteNameView *setView = [[SetNoteNameView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height) withTag:tag];
    
    __weak SetNoteNameView *_weakSetView = setView;
    [setView setSetNoteNameStr:^(NSString *inputStr, NSInteger getTag) {
        if (getTag == 1) {
            UserModel *model = (UserModel *)_dataArr[tag-4101];
            
            [[AppHttpManager shareInstance] getAddNoteNameWithuserId:[User_ID intValue] Token:User_TOKEN OuId:[model.use_id intValue] NoteName:inputStr PostOrGet:@"post" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                    [SVProgressHUD showImage:nil status:@"操作成功"];
                    [self.socialTableView.mj_header beginRefreshing];
                }else {
                    [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                }
            } failure:^(NSString *str) {
                NSLog(@"%@",str);
            }];
        }
        [_weakSetView removeFromSuperview];
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:setView];
}

#pragma mark - 创建UIActionSheet
- (void)creatActionSheetWithTag:(NSInteger)tag {
    UserModel *model = (UserModel *)_dataArr[tag-4101];
    cellTouchuIndex = tag-4101;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"确定取消关注%@吗？",model.nickname] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消关注" otherButtonTitles: nil];
    if (touchType == 2 || touchType == 0) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"确定要移除%@吗？",model.nickname] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"移除" otherButtonTitles: nil];
    }
    [actionSheet showInView:self];
}

#pragma mark - UIActionSheet代理事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UserModel *model = (UserModel *)_dataArr[cellTouchuIndex];
        if (touchType == 0 || touchType == 1) {
            [[AppHttpManager shareInstance] getDeleteHeartMeWithHeartObjectId:model.use_id userId:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                    if (touchType == 0) {
                        [SVProgressHUD showImage:nil status:@"删除好友成功"];
                    }else if (touchType == 1) {
                        [SVProgressHUD showImage:nil status:@"取消关注成功"];
                    }
                    
                    [self.socialTableView.mj_header beginRefreshing];
                }else {
                    [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                }
            } failure:^(NSString *str) {
                NSLog(@"%@",str);
            }];
        }else {
            [[AppHttpManager shareInstance] getDeleteMeHeartWithHeartObjectId:model.use_id userId:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                    [SVProgressHUD showImage:nil status:@"删除粉丝成功"];
                    [self.socialTableView.mj_header beginRefreshing];
                }else {
                    [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                }
            } failure:^(NSString *str) {
                NSLog(@"%@",str);
            }];
        }
    }
}


@end
