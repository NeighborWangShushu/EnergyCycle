//
//  MessageViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MessageViewController.h"
#import "MineMessageTableViewCell.h"
#import "GifHeader.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) int page;

@property (nonatomic, assign) int commentPage;

@property (nonatomic, assign) int likePage;

@property (nonatomic, assign) int messagePage;

@property (nonatomic, assign) BOOL unCommentRead;

@property (nonatomic, assign) BOOL unLikeRead;

@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, strong) NSMutableArray *likeArray;

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
//        static NSString *
        return nil;
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
        NSLog(@"%@", [model class]);
        [cell updateDataWithModel:model];
        return cell;
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
        }
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [weakSelf updateDataWithPage:self.page];
    }];
    [self.tableView.mj_header beginRefreshing];
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
                    if (model.NotifyRead == 0) {
                        self.unCommentRead = YES;
                    }
                    [self.commentArray addObject:model];
                } else if (self.type == 2) {
                    if (model.NotifyRead == 0) {
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
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        [self endRefresh];
        NSLog(@"%@", str);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self setUpMJRefresh];
    
    self.commentPage = 0;
    self.likePage = 0;
    self.messagePage = 0;
    
    [self commentClick:self.commentButton];
    
    self.tabBarController.tabBar.hidden = YES;
    
    // Do any additional setup after loading the view.
}

- (IBAction)commentClick:(id)sender {
    self.unreadComment.hidden = YES;
    [self changeLineFrameAndTextColor:sender];
    self.type = 1;
    [self updateDataWithPage:self.commentPage];
}

- (IBAction)likeClick:(id)sender {
    self.unreadLike.hidden = YES;
    [self changeLineFrameAndTextColor:sender];
    self.type = 2;
    [self updateDataWithPage:self.likePage];
}

- (IBAction)messageClick:(id)sender {
    self.type = 3;
    [self changeLineFrameAndTextColor:sender];
}

// 改变下划线的位置与按钮的颜色
- (void)changeLineFrameAndTextColor:(UIButton *)button {
    [self.commentButton setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.8] forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.8] forState:UIControlStateNormal];
    [self.messageButton setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.8] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
    self.underLine.frame = CGRectMake(button.frame.origin.x, self.underLine.frame.origin.y, self.underLine.frame.size.width, self.underLine.frame.size.height);
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
