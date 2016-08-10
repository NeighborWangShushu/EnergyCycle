//
//  PKGatherViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PKGatherViewController.h"
#import "HMSegmentedControl.h"
#import "BrokenLineViewController.h"

#import "ToDayPKTableViewCell.h"
#import "MinePKRecordViewTableViewCell.h"

#import "XMShareView.h"

@interface PKGatherViewController () <UITableViewDelegate, UITableViewDataSource> {
    XMShareView *shareView;
}

@property (nonatomic, strong) NSMutableArray *toDayArr;

@property (nonatomic, strong) NSMutableArray *pkRecordArr;

@property (nonatomic, strong) HMSegmentedControl *segControl;

@property (nonatomic, assign) BOOL isToDay;

@property (nonatomic, assign) BOOL noData;

@end

@implementation PKGatherViewController

- (NSMutableArray *)toDayArr {
    if (!_toDayArr) {
        self.toDayArr = [NSMutableArray array];
    }
    return _toDayArr;
}

- (NSMutableArray *)pkRecordArr {
    if (!_pkRecordArr) {
        self.pkRecordArr = [NSMutableArray array];
    }
    return _pkRecordArr;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isToDay) {
        if ([self.toDayArr count] == 0) {
            self.noData = YES;
            return 1;
        } else {
            self.noData = NO;
            return [self.toDayArr count];
        }
    } else {
        if ([self.pkRecordArr count] == 0) {
            self.noData = YES;
            return 1;
        } else {
            self.noData = NO;
            return [self.pkRecordArr count];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] init];
//    [view addSubview:self.segControl];
    return self.segControl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isToDay) {
        static NSString *toDayPKTableViewCell = @"toDayPKTableViewCell";
        ToDayPKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:toDayPKTableViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ToDayPKTableViewCell" owner:self options:nil].lastObject;
        }
        
        if (self.noData) {
            [cell noData];
            return cell;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // Configure the cell...
        OtherReportModel *model = self.toDayArr[indexPath.row];
        [cell updateDataWithModel:model];
        
        return cell;
    } else {
        static NSString *minePKRecordViewTableViewCell = @"minePKRecordViewTableViewCell";
        MinePKRecordViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:minePKRecordViewTableViewCell];
        
        if (cell  == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MinePKRecordViewTableViewCell" owner:self options:nil].lastObject;
        }
        
        if (self.noData) {
            [cell noData];
            return cell;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        MyPkEveryModel *model = self.pkRecordArr[indexPath.row];
        [cell getDataWithModel:model];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isToDay) {
        return;
    } else {
        BrokenLineViewController *blVC = MainStoryBoard(@"BrokenLineViewController");
        MyPkEveryModel *model = self.pkRecordArr[indexPath.row];
        blVC.projectID = model.pId;
        blVC.showStr = model.name;
        [self.navigationController pushViewController:blVC animated:YES];
    }
}

- (void)getToDayPKData {
    [[AppHttpManager shareInstance] getGetReportByUserWithUserid:[User_ID intValue] Token:User_TOKEN OUserId:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self.toDayArr removeAllObjects];
            NSLog(@"%@", User_ID);
            for (NSDictionary *dic in dict[@"Data"][@"reportItemInfo"]) {
                OtherReportModel *model = [[OtherReportModel alloc] initWithDictionary:dic error:nil];
                [self.toDayArr addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

- (void)getPkRecordData {
    [[AppHttpManager shareInstance] getGetMyPkHistoryProjectWithUserId:[User_ID intValue] Token:@"" PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self.pkRecordArr removeAllObjects];
            for (NSDictionary *dic in dict[@"Data"]) {
                MyPkEveryModel *model = [[MyPkEveryModel alloc] initWithDictionary:dic error:nil];
                [self.pkRecordArr addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSegmentControl];
    
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    [self setupRightNavBarWithTitle:@"分享"];
    self.isToDay = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getToDayPKData];
    self.title = @"每日PK";

//    [self segmentedControlChangedValue:self.segControl];
    
    // Do any additional setup after loading the view.
}

- (void)rightAction {
    NSString *contentStr = @"";
    for (NSInteger i=0; i<self.toDayArr.count; i++) {
        OtherReportModel *model = (OtherReportModel *)self.toDayArr[i];
        
        if (i == self.toDayArr.count-1) {
            contentStr = [NSString stringWithFormat:@"%@%@%@%@",contentStr,model.RI_Name,model.RI_Num,model.RI_Unit];
        }else {
            contentStr = [NSString stringWithFormat:@"%@%@%@%@、",contentStr,model.RI_Name,model.RI_Num,model.RI_Unit];
        }
    }
    NSString *shareStr = [NSString stringWithFormat:@"我今天%@，加入能量圈，和我一起PK吧！",contentStr];
    shareView = [[XMShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
    shareView.alpha = 0.0;
    shareView.shareTitle = shareStr;
    shareView.shareText = @"";
    NSString * share_url = @"";
    share_url = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",MYJYAppId];
    shareView.shareUrl = [NSString stringWithFormat:@"%@&is_Share=1",share_url];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    [UIView animateWithDuration:0.25 animations:^{
        shareView.alpha = 1.0;
    }];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.isToDay = YES;
        self.title = @"每日PK";
        [self getToDayPKData];
    } else if (sender.selectedSegmentIndex == 1) {
        self.isToDay = NO;
        self.title = @"历史记录";
        [self getPkRecordData];
    }
}

// 创建分段控件
- (void)createSegmentControl {
    self.segControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 40)];
    self.segControl.sectionTitles = @[@"今日PK                  ",@"PK记录                  "];
    // 横线的高度
    self.segControl.selectionIndicatorHeight = 2.0f;
    // 背景颜色
    self.segControl.backgroundColor = [UIColor whiteColor];
    // 横线的颜色
    self.segControl.selectionIndicatorColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    // 横线在底部出现
    self.segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    // 横线根据文本的长度自适应长度
    self.segControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    // 为选中时的文本样式
    self.segControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:14]};
    // 选中后的文本样式
    self.segControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:242/ 255.0 green:77/255.0 blue:77/255.0 alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:14]};
    // 初始位置
    self.segControl.selectedSegmentIndex = 0;
    // 边界样式
    self.segControl.borderType = HMSegmentedControlBorderTypeBottom;
    // 边界颜色
    self.segControl.borderColor = [UIColor lightGrayColor];
    // 触发方法
    [self.segControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
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
