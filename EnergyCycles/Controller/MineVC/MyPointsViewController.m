//
//  MyPointsViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyPointsViewController.h"

#import "MyPointTableViewCell.h"
#import "JiFenHistoryModel.h"
#import "GifHeader.h"

@interface MyPointsViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> {
    int page;
    NSMutableArray *_dataArr;
}

@end

@implementation MyPointsViewController

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//积分记录
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分记录";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    _dataArr = [[NSMutableArray alloc] init];
    
    pointTableView.backgroundColor = [UIColor clearColor];
    pointTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    pointTableView.showsVerticalScrollIndicator = NO;
    pointTableView.showsHorizontalScrollIndicator = NO;
    
    self.shuLineView.backgroundColor = [UIColor clearColor];
    
    //
    [self setUpMJRefresh];
    [self.numButton setTitle:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserJiFen"]] forState:UIControlStateNormal];
}

- (IBAction)leftButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    pointTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf loadDataWithIndexWithPage:page];
    }];
    
    pointTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithIndexWithPage:page];
    }];
    [pointTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [pointTableView.mj_header endRefreshing];
    [pointTableView.mj_footer endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexWithPage:(int)pages {
    [[AppHttpManager shareInstance] getGetJiFenListByUseridWithUserid:[User_ID intValue] Page:pages PostOrGet:@"get" success:^(NSDictionary *dict) {
            if (pages == 1) {
                [_dataArr removeAllObjects];
            }
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                for (NSDictionary *subDict in dict[@"Data"]) {
                    JiFenHistoryModel *model = [[JiFenHistoryModel alloc] initWithDictionary:subDict error:nil];
                    [_dataArr addObject:model];
                }
            }else if ([dict[@"Code"] integerValue] == 10000) {
                [SVProgressHUD showImage:nil status:@"登录失效"];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
            [self endRefresh];
            [pointTableView reloadData];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [self endRefresh];
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
    return 77.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyPointTableViewCellId = @"MyPointTableViewCellId";
    MyPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyPointTableViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyPointTableViewCell" owner:self options:nil].lastObject;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.upLineView.hidden = NO;
    if (indexPath.row == 0) {
        cell.upLineView.hidden = YES;
    }
    
    if (_dataArr.count) {
        JiFenHistoryModel *model = (JiFenHistoryModel *)_dataArr[indexPath.row];
        cell.pointImageView.backgroundColor = [UIColor whiteColor];
        cell.pointImageView.layer.masksToBounds = YES;
        cell.pointImageView.layer.cornerRadius = 4.f;
        cell.pointImageView.layer.borderWidth = 2.f;
        cell.pointImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        cell.titleLabel.text = model.jifenType;
        if ([model.jifen integerValue] > 0) {
            cell.pointImageView.layer.borderColor = [UIColor redColor].CGColor;
            
            cell.numLabel.textColor = [UIColor colorWithRed:253/255.0 green:83/255.0 blue:83/255.0 alpha:1];
            cell.numLabel.text = [NSString stringWithFormat:@"+%@",model.jifen];
        }else {
            cell.pointImageView.layer.borderColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1].CGColor;
            
            cell.numLabel.textColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
            cell.numLabel.text = [NSString stringWithFormat:@"%@",model.jifen];
        }
        
        NSArray *timeArr = [model.AddTime componentsSeparatedByString:@"T"];
        NSArray *subTimeArr = [timeArr.firstObject componentsSeparatedByString:@"-"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@年%@月%@日",subTimeArr.firstObject,subTimeArr[1],subTimeArr.lastObject];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y >= 370.f) {
//        self.shuLineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
//    }else {
//        self.shuLineView.backgroundColor = [UIColor clearColor];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
