//
//  MessageViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MessageViewController.h"
#import "MineWhisperTableViewCell.h"
#import "MineMessageTableViewCell.h"
#import "GifHeader.h"
#import "MessageModel.h"
#import "MineChatViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) int commentPage;

@property (nonatomic, assign) int likePage;

@property (nonatomic, assign) int messagePage;

@property (nonatomic, assign) BOOL unCommentRead;

@property (nonatomic, assign) BOOL unLikeRead;

@property (nonatomic, assign) BOOL unMessageRead;
// 评论
@property (nonatomic, strong) NSMutableArray *commentArray;
// 点赞
@property (nonatomic, strong) NSMutableArray *likeArray;
// 私信
@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation MessageViewController

- (NSMutableArray *)commentArray {
    if (!_commentArray) {
        self.commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (NSMutableArray *)likeArray {
    if (!_likeArray) {
        self.likeArray = [NSMutableArray array];
    }
    return _likeArray;
}

- (NSMutableArray *)messageArray {
    if (!_messageArray) {
        self.messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 3) {
        return 100;
    }
    return 160;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == 1) {
        return self.commentArray.count;
    } else if (self.type == 2) {
        return self.likeArray.count;
    } else if (self.type == 3) {
        return self.messageArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 3) {
        static NSString *mineWhisperTableViewCell = @"mineWhisperTableViewCell";
        MineWhisperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineWhisperTableViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineWhisperTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MessageModel *model = [[MessageModel alloc] init];
        model = self.messageArray[indexPath.row];
        [cell updateDataWithModel:model];
        
        return cell;
    } else {
        static NSString *mineMessageTableViewCell = @"mineMessageTableViewCell";
        MineMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineMessageTableViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineMessageTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GetMessageModel *model = [[GetMessageModel alloc] init];
        if (self.type == 1) {
            model = self.commentArray[indexPath.row];
        } else {
            model = self.likeArray[indexPath.row];
        }
        [cell updateDataWithModel:model];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 3) {
        MessageModel *model = self.messageArray[indexPath.row];
        MineChatViewController *chatVC = MainStoryBoard(@"MineChatViewController");
        chatVC.useredId = model.UserID;
        chatVC.chatName = model.nickname;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        if (self.type == 1) {
            self.commentPage = 0 ;
            [weakSelf updateDataWithPage:self.commentPage];
        } else if (self.type == 2) {
            self.likePage = 0;
            [weakSelf updateDataWithPage:self.likePage];
        } else if (self.type == 3) {
            self.messagePage = 0;
            [weakSelf updateMessageData];
        }
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.type == 1) {
            self.commentPage ++ ;
            [weakSelf updateDataWithPage:self.commentPage];
        } else if (self.type == 2) {
            self.likePage ++;
            [weakSelf updateDataWithPage:self.likePage];
        } else if (self.type == 3) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)updateDataWithPage:(int)page {
    [[AppHttpManager shareInstance] getMessageGetWithType:self.type Userid:[User_ID intValue] PageIndex:page PageSize:10 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            
            if (self.commentPage == 0) {
                [self.commentArray removeAllObjects];
            } else if (self.likePage == 0) {
                [self.likeArray removeAllObjects];
            }
            
            for (NSDictionary *data in dict[@"Data"]) {
                GetMessageModel *model = [[GetMessageModel alloc] initWithDictionary:data error:nil];
                if (self.type == 1) {
                    if ([model.NotifyIsRead isEqualToString:@"0"] || model.NotifyIsRead == nil) {
                        self.unCommentRead = YES;
                    }
                    [self.commentArray addObject:model];
                } else if (self.type == 2) {
                    if ([model.NotifyIsRead isEqualToString:@"0"] || model.NotifyIsRead == nil) {
                        self.unLikeRead = YES;
                    }
                    [self.likeArray addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endRefresh];
                GetMessageModel *model = [[GetMessageModel alloc] init];
                if (self.type == 1) {
                    model = self.commentArray[0];
                } else {
                    model = self.likeArray[0];
                }
                if ((page + 1) * 10 >= [model.RowCounts intValue]) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                if (self.unCommentRead) {
                    self.unreadComment.hidden = NO;
                }
                if (self.unLikeRead) {
                    self.unreadLike.hidden = NO;
                }
                [self.tableView reloadData];
            });
        } else {
            [self endRefresh];
            GetMessageModel *model = [[GetMessageModel alloc] init];
            if (self.type == 1) {
                model = self.commentArray[0];
            } else {
                model = self.likeArray[0];
            }
            if ((page + 1) * 10 >= [model.RowCounts intValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if ((self.commentArray.count == 0 && self.type == 1) || (self.likeArray.count == 0 && self.type == 2)) {
                [self.tableView reloadData];
            }
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
        }
    } failure:^(NSString *str) {
        [self endRefresh];
        NSLog(@"%@", str);
    }];
}

// 第一次加载数据
- (void)updateDataWithType:(int)type {
    [[AppHttpManager shareInstance] getMessageGetWithType:type Userid:[User_ID intValue] PageIndex:0 PageSize:10 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self.likeArray removeAllObjects];
            for (NSDictionary *data in dict[@"Data"]) {
                GetMessageModel *model = [[GetMessageModel alloc] initWithDictionary:data error:nil];
                if ([model.NotifyIsRead isEqualToString:@"0"] || model.NotifyIsRead == nil) {
                    self.unLikeRead = YES;
                }
                [self.likeArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endRefresh];
                if (self.unLikeRead) {
                    self.unreadLike.hidden = NO;
                }
                [self.tableView reloadData];
            });
        }
    } failure:^(NSString *str) {
        [self endRefresh];
        NSLog(@"%@", str);
    }];
}

- (void)updateMessageData {
    [[AppHttpManager shareInstance] getGetTopOnePeopleWithUserid:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if (self.messagePage == 0) {
                [self.messageArray removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"Data"]) {
                MessageModel *model = [[MessageModel alloc] initWithDictionary:dic error:nil];
                if ([model.MessageIsRead isEqualToString:@"0"] || model.MessageIsRead == nil) {
                    self.unMessageRead = YES;
                }
                [self.messageArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endRefresh];
                if (self.unMessageRead) {
                    self.unreadMessage.hidden = NO;
                }
                [self.tableView reloadData];
            });
        } else {
            if (self.messageArray.count == 0) {
                [self.tableView reloadData];
            }
//            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        [self endRefresh];
        NSLog(@"%@", str);
    }];
}

- (void)getMessageReaded {
    [[AppHttpManager shareInstance] getMessageReadedWithType:self.type Userid:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            NSLog(@"置为已读");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.type == 1) {
                    [self updateDataWithPage:self.commentPage];
                } else if (self.type == 2) {
                    [self updateDataWithPage:self.likePage];
                }
            });
        } else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self setUpMJRefresh];
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    self.title = @"消息";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.unreadComment.hidden = YES;
    self.unreadLike.hidden = YES;
    self.unreadMessage.hidden = YES;
    
    self.commentPage = 0;
    self.likePage = 0;
    self.messagePage = 0;
    
//    [self updateDataWithType:1];
    [self updateDataWithType:2];
    [self updateMessageData];
    
    [self commentClick:self.commentButton];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushReloadData) name:@"pushReloadData" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
//    [self messageClick:self.messageButton];
    self.unreadMessage.hidden = YES;
    self.unMessageRead = NO;
    [self updateMessageData];
}

- (void)pushReloadData {
    [self updateMessageData];
}

- (IBAction)commentClick:(id)sender {
    self.unreadComment.hidden = YES;
    self.unCommentRead = NO;
//    self
    [self changeLineFrameAndTextColor:sender];
    self.type = 1;
    [self getMessageReaded];
//    [self updateDataWithPage:self.commentPage];
}

- (IBAction)likeClick:(id)sender {
    self.unreadLike.hidden = YES;
    self.unLikeRead = NO;
    [self changeLineFrameAndTextColor:sender];
    self.type = 2;
    [self getMessageReaded];
//    [self updateDataWithPage:self.likePage];
}

- (IBAction)messageClick:(id)sender {
    self.unreadMessage.hidden = YES;
    self.unMessageRead = NO;
    self.type = 3;
    [self changeLineFrameAndTextColor:sender];
    [self updateMessageData];
}

// 改变下划线的位置与按钮的颜色
- (void)changeLineFrameAndTextColor:(UIButton *)button {
    [self.commentButton setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.8] forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.8] forState:UIControlStateNormal];
    [self.messageButton setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.8] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.1 animations:^{
        self.underLine.frame = CGRectMake(button.frame.origin.x, self.underLine.frame.origin.y, self.underLine.frame.size.width, self.underLine.frame.size.height);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
