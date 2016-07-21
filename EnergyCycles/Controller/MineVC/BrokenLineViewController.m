//
//  BrokenLineViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BrokenLineViewController.h"

#import "RecordSubViewCell.h"
#import "BrokenModel.h"

#import "LineChartView.h"
#import "TwoLineChartView.h"

#import "NSDate+Category.h"
#import "GifHeader.h"

@interface BrokenLineViewController () <UITableViewDataSource,UITableViewDelegate> {
    //折线图背景
    UIView *brokenLineBackView;
    
    int page;
    int showType;
    
    NSMutableArray *_dataArr;
    NSString *unit;
}

@end

@implementation BrokenLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [[NSMutableArray alloc] init];
    showType = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    brokenTableView.showsHorizontalScrollIndicator = NO;
    brokenTableView.showsVerticalScrollIndicator = NO;
    brokenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = [NSString stringWithFormat:@"%@记录",self.showStr];
//    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
//    //去掉阴影
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    //
    self.brokenSegmentedControl.selectedSegmentIndex = 0;
    [self setUpMJRefresh];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    self.navigationController.navigationBar.translucent = YES;
//}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
//}

//#pragma mark - 返回按键
//- (void)leftAction {
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    EnetgyCycle.energyTabBar.tabBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
//}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    brokenTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        page = 0;
        [weakSelf loadDataWithIndexWithType:showType Page:page];
    }];
    
    brokenTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithIndexWithType:showType Page:page];
    }];
    [brokenTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [brokenTableView.mj_header endRefreshing];
    [brokenTableView.mj_footer endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexWithType:(int)type Page:(int)pages {
    [[AppHttpManager shareInstance] getGetMyPkProjectInfoWithUserId:[User_ID intValue] Token:User_TOKEN ProjectId:[self.projectID intValue] Type:type PageIndex:pages PageSize:15 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if (pages == 0) {
            [_dataArr removeAllObjects];
        }
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            unit = dict[@"Data"][@"unit"];
            
            for (NSDictionary *subDict in dict[@"Data"][@"childrenPkHistoryInfo"]) {
                BrokenModel *model = [[BrokenModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            
            if (type == 1 || type == 2) {
                [self creatMPGraphViewWithArr:_dataArr];
            }else {
                UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 45)];
                twoView.backgroundColor = [UIColor whiteColor];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 100, 22)];
                label.text = @"总计";
                label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
                label.textAlignment = NSTextAlignmentLeft;
                [twoView addSubview:label];
                
                UILabel *otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_width-77-100, 9, 150, 27)];
                otherLabel.textColor = [UIColor colorWithRed:247/255.0 green:204/255.0 blue:62/255.0 alpha:1];
                otherLabel.font = [UIFont systemFontOfSize:22];
                otherLabel.textAlignment = NSTextAlignmentRight;
                otherLabel.text = [NSString stringWithFormat:@"%@%@",dict[@"Data"][@"count"],dict[@"Data"][@"unit"]];
                [twoView addSubview:otherLabel];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, Screen_width, 1)];
                lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
                [twoView addSubview:lineView];
                
                brokenTableView.tableHeaderView = twoView;
            }
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
        [self endRefresh];
        [brokenTableView reloadData];
    } failure:^(NSString *str) {
        [self endRefresh];
        NSLog(@"%@",str);
    }];
}

#pragma mark - 创建折线图
- (void)creatMPGraphViewWithArr:(NSArray *)values {
    for (UIView *subView in brokenLineBackView.subviews) {
        [subView removeFromSuperview];
    }
    [brokenLineBackView removeFromSuperview];
    brokenLineBackView = nil;
    
    int days;
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    
    NSArray *daTimeArr = [locationString componentsSeparatedByString:@"-"];
    NSInteger year = [daTimeArr.firstObject integerValue];
    NSString *month = daTimeArr[1];
    NSString *now = daTimeArr.lastObject;
    if ([month isEqualToString:@"02"]) {
        if((year%400 == 0) || ((year%4 == 0)&&(year%100 != 0))) {//闰年
            days = 29;
        }else {
            days = 28;
        }
    }else if ([month isEqualToString:@"01"] || [month isEqualToString:@"03"] || [month isEqualToString:@"05"] || [month isEqualToString:@"07"] || [month isEqualToString:@"08"] || [month isEqualToString:@"10"] || [month isEqualToString:@"12"]) {
        days = 31;
    }else {
        days = 30;
    }
    
    //获取数值
    NSMutableArray *pointArr = [[NSMutableArray alloc] init];
    NSMutableArray *subPointArr = [[NSMutableArray alloc] init];
    if (showType == 1) {//本周
        if (values.count < 7) {
            NSMutableDictionary *subsDict = [[NSMutableDictionary alloc] init];
            for (BrokenModel *model in values) {
                NSArray *time = [model.addtime componentsSeparatedByString:@" "];
                NSArray *subTime = [time.firstObject componentsSeparatedByString:@"-"];
                
                [subsDict setObject:[NSString stringWithFormat:@"%@",model.num] forKey:[NSString stringWithFormat:@"%d",[subTime.lastObject intValue]]];
            }
            
            for (NSInteger i=[now integerValue]-6; i<=[now integerValue]; i++) {
                if ([[subsDict objectForKey:[NSString stringWithFormat:@"%ld",(long)i]] isEqualToString:@"(null)"]) {
                    [pointArr addObject:@"0"];
                }else {
                    [pointArr addObject:[NSString stringWithFormat:@"%f",[[subsDict objectForKey:[NSString stringWithFormat:@"%ld",(long)i]] integerValue]*0.05]];
                }
            }
        }else {
            for (BrokenModel *model in values) {
                if (subPointArr.count <= 6) {
                    [subPointArr addObject:[NSString stringWithFormat:@"%@",model.num]];
                }
            }
            for (NSInteger i=subPointArr.count-1; i>=0; i--) {
                NSInteger subNum = [subPointArr[i] integerValue];
                [pointArr addObject:[NSString stringWithFormat:@"%f",(long)subNum*0.05]];
            }
        }
    }else {//本月
        NSMutableDictionary *pointDict = [[NSMutableDictionary alloc] init];
        for (BrokenModel *model in values) {
            NSArray *time = [model.addtime componentsSeparatedByString:@" "];
            NSArray *subTime = [time.firstObject componentsSeparatedByString:@"-"];
            
            [pointDict setObject:model.num forKey:[NSString stringWithFormat:@"%d",[subTime.lastObject intValue]]];
        }
        
        NSMutableArray *subPointArr = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<days; i++) {
            if ([[pointDict objectForKey:[NSString stringWithFormat:@"%ld",(long)i]] isEqualToString:@"(null)"]) {
                [subPointArr addObject:@"0"];
            }else {
                [subPointArr addObject:[NSString stringWithFormat:@"%f",[[pointDict objectForKey:[NSString stringWithFormat:@"%ld",(long)i]] integerValue]*0.05]];
            }
        }
        
        
        for (NSInteger i=0; i<subPointArr.count; i++) {
            if (i == 0) {
                [pointArr addObject:subPointArr[i]];
            }else {
                static float one = 0;
                static float two = 0;
                static float thr = 0;
                static float fou = 0;
                
                if (i < 8) {
                    one = [subPointArr[i] floatValue] + one;
                }else if (i == 8) {
                    one = [subPointArr[i] floatValue] + one;
                    [pointArr addObject:[NSString stringWithFormat:@"%f",one]];
                    one = 0;
                }else if (i < 15) {
                    two = [subPointArr[i] floatValue] + two;
                }else if (i == 15) {
                    two = [subPointArr[i] floatValue] + two;
                    [pointArr addObject:[NSString stringWithFormat:@"%f",two]];
                    two = 0;
                }else if (i < 22) {
                    thr = [subPointArr[i] floatValue] + thr;
                }else if (i == 22) {
                    thr = [subPointArr[i] floatValue] + thr;
                    [pointArr addObject:[NSString stringWithFormat:@"%f",thr]];
                    thr = 0;
                }else {
                    if (days == 28 || days == 29) {
                        if (i < subPointArr.count-1) {
                            fou = [subPointArr[i] floatValue] + fou;
                        }else if (i == subPointArr.count-1) {
                            fou = [subPointArr[i] floatValue] + fou;
                            [pointArr addObject:[NSString stringWithFormat:@"%f",fou]];
                            fou = 0;
                        }
                    }else if (days == 30 || days == 31) {
                        static float sub = 0;
                        if (i < days-2) {
                            sub = [subPointArr[i] floatValue] + sub;
                        }else if (i == days-2) {
                            sub = [subPointArr[i] floatValue] + sub;
                            [pointArr addObject:[NSString stringWithFormat:@"%f",sub]];
                        }else {
                            [pointArr addObject:[NSString stringWithFormat:@"%f",[subPointArr.lastObject floatValue]]];
                            sub = 0;
                        }
                    }
                }
            }
        }
    }
    
    //获取日期
    NSMutableArray *timeArr = [[NSMutableArray alloc] init];
    if (showType == 1) {//本周
        NSArray *subTime;
        NSString *subTimeStr;
        for (NSInteger i=6; i>=1; i--) {
            NSDate *getData = [[NSDate date] dateBySubtractingDays:i];
            NSArray *dateArr = [[dateformatter stringFromDate:getData] componentsSeparatedByString:@" "];
            subTime = [dateArr.firstObject componentsSeparatedByString:@"-"];
            
            if ([subTime.lastObject integerValue] == 1) {
                subTimeStr = [NSString stringWithFormat:@"%@月%@日",subTime[1],subTime.lastObject];
            }else if (i == 6) {
                subTimeStr = [NSString stringWithFormat:@"%@月%@日",subTime[1],subTime.lastObject];
            }else {
                subTimeStr = [NSString stringWithFormat:@"%@",subTime.lastObject];
            }
            [timeArr addObject:subTimeStr];
        }
        
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *locationString = [dateformatter stringFromDate:[NSDate date]];
        
        NSArray *nowTime = [locationString componentsSeparatedByString:@" "];
        NSArray *nowSubTime = [nowTime.firstObject componentsSeparatedByString:@"-"];
        if ([nowSubTime.lastObject integerValue] == 1) {
            [timeArr addObject:[NSString stringWithFormat:@"%@月%@日",nowSubTime[1],nowSubTime.lastObject]];
        }else {
            [timeArr addObject:nowSubTime.lastObject];
        }
    }else {//本月
        BrokenModel *model = values.lastObject;
        NSArray *time = [model.addtime componentsSeparatedByString:@" "];
        NSArray *subTime = [time.firstObject componentsSeparatedByString:@"-"];
        
        NSString *timeStr;
        timeStr = [NSString stringWithFormat:@"%@月%@日",subTime[1],@"1"];
        [timeArr addObject:timeStr];
        
        for (int i=1; i<=4; i++) {
            timeStr = [NSString stringWithFormat:@"%d",i*7+1];
            if (i == 4 && days == 28) {
                timeStr = [NSString stringWithFormat:@"%d",i*7];
            }
            [timeArr addObject:timeStr];
        }
        
        int shenDay = days - 29;
        if (shenDay > 0) {
            timeStr = [NSString stringWithFormat:@"%d",29+shenDay];
            [timeArr addObject:timeStr];
        }
    }
    
    //头视图
    brokenLineBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 200)];
    brokenTableView.tableHeaderView = brokenLineBackView;
    
    //
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, Screen_width-20, 184)];
    backImageView.image = [UIImage imageNamed:@"minebeijing.png"];
    [brokenLineBackView addSubview:backImageView];
    
    //
    UILabel *headTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 12, 76, 26)];
    headTitleLabel.textColor = [UIColor whiteColor];
    headTitleLabel.font = [UIFont systemFontOfSize:19];
    headTitleLabel.text = @"本周累计";
    if (showType == 2) {
        headTitleLabel.text = @"本月累计";
    }
    [brokenLineBackView addSubview:headTitleLabel];
    
    //
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_width-20, 20, 8, 18)];
    unitLabel.text = unit;
    unitLabel.textColor = [UIColor whiteColor];
    unitLabel.font = [UIFont systemFontOfSize:16];
    [brokenLineBackView addSubview:unitLabel];
    
    CGSize size = [unitLabel systemLayoutSizeFittingSize:CGSizeMake(MAXFLOAT, 0)];
    unitLabel.frame = CGRectMake(Screen_width-size.width-12-10, 19, size.width, 18);
    
    UILabel *liejiLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_width-size.width-12-100-10, 15, 100, 23)];
    NSInteger allNum = 0;
    for (NSString *num in pointArr) {
        allNum = allNum + [num floatValue]/0.05;
    }
    
    liejiLabel.text = [NSString stringWithFormat:@"%ld",(long)allNum];
    liejiLabel.textColor = [UIColor whiteColor];
    liejiLabel.textAlignment = NSTextAlignmentRight;
    liejiLabel.font = [UIFont systemFontOfSize:19];
    [brokenLineBackView addSubview:liejiLabel];
    
    //
    UIView *witLineView = [[UIView alloc] initWithFrame:CGRectMake(22, 48, Screen_width-44, 1)];
    witLineView.backgroundColor = [UIColor whiteColor];
    [brokenLineBackView addSubview:witLineView];
    
    //
    UIView *downLineView = [[UIView alloc] initWithFrame:CGRectMake(22, 153, Screen_width-44, 1)];
    downLineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [brokenLineBackView addSubview:downLineView];
    
    //转换
    NSMutableArray *subPoint = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<pointArr.count; i++) {
        [subPoint addObject:@([pointArr[i] floatValue]/0.05)];
    }
    
    NSArray *subSubPoint = [subPoint sortedArrayUsingSelector:@selector(compare:)];
    [pointArr removeAllObjects];
    for (NSInteger i=0; i<subPoint.count; i++) {
        CGFloat poin = [subSubPoint.lastObject integerValue]/0.75;
        [pointArr addObject:[NSString stringWithFormat:@"%f",[subPoint[i] integerValue]/poin]];
    }
    
    //创建虚线部分
    UILabel *unitSubLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width-20, 88, 20, 12)];
    unitSubLabel.text = unit;
    unitSubLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
    unitSubLabel.font = [UIFont systemFontOfSize:8];
    [brokenLineBackView addSubview:unitSubLabel];
    CGSize unitSubLabelSize = [unitSubLabel systemLayoutSizeFittingSize:CGSizeMake(MAXFLOAT, 0)];
    unitSubLabel.frame = CGRectMake(Screen_width-10-12-unitSubLabelSize.width, 88, unitSubLabelSize.width, 12);
    
    UILabel *julSubLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width-20, 88, 20, 12)];
    julSubLabel.text = [NSString stringWithFormat:@"%.f",[subSubPoint.lastObject integerValue]*0.75];
    julSubLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
    julSubLabel.font = [UIFont systemFontOfSize:8];
    julSubLabel.textAlignment = NSTextAlignmentRight;
    [brokenLineBackView addSubview:julSubLabel];
    CGSize julSubLabelSize = [unitSubLabel systemLayoutSizeFittingSize:CGSizeMake(MAXFLOAT, 0)];
    julSubLabel.frame = CGRectMake(Screen_width-10-12-julSubLabelSize.width-unitSubLabelSize.width-8, 88, julSubLabelSize.width+5, 12);
    
    UIImageView *xuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 94, Screen_width-46-julSubLabelSize.width-unitSubLabelSize.width-5, 1)];
    xuImageView.image = [UIImage imageNamed:@"Path1195.png"];
    xuImageView.alpha = 0.5;
    [brokenLineBackView addSubview:xuImageView];
    
    //创建折线图
    [self creatZheXinWithPoint:pointArr];
    
    //
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 199, Screen_width, 1)];
    lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [brokenLineBackView addSubview:lineView];
    
    if (showType == 1) {//本周
        CGFloat space = (Screen_width-10-12-10-38)/7;
        for (NSInteger i=0; i<timeArr.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10+12+space*i, 164, space, 16)];
            if (Screen_width > 375.f) {
                label.frame = CGRectMake(10+8+space*i, 164, space, 16);
            }
            
            label.text = timeArr[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor whiteColor];
            
            [brokenLineBackView addSubview:label];
        }
    }else {//本月
        CGFloat space = (Screen_width-10-12-10-38)/5;
        for (NSInteger i=0; i<timeArr.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8+(space-8)*i, 164, space-8, 16)];
            
            if (days == 28 || days == 29) {
                label.frame = CGRectMake(8+(space)*i, 164, space, 16);
                if (Screen_width <= 320.f) {
                    label.frame = CGRectMake(12+(space)*i, 164, space, 16);
                }
            }else {
                if (Screen_width <= 320.f) {
                    label.frame = CGRectMake(10+(space-5)*i, 164, space-5, 16);
                    if (i == timeArr.count-2) {
                        label.frame = CGRectMake(10+(space-5)*i-3, 164, space-5, 16);
                    }else if (i == timeArr.count-1) {
                        label.frame = CGRectMake(10+(space-5)*i-6, 164, space-5, 16);
                    }
                }
                if (Screen_width > 375.f) {
                    if (i == 0) {
                        label.frame = CGRectMake(8+(space-9)*i, 164, space-9, 16);
                    }else {
                        label.frame = CGRectMake(8+(space-10)*i, 164, space-10, 16);
                    }
                }
            }
            
            label.text = timeArr[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor whiteColor];
            
            [brokenLineBackView addSubview:label];
        }
    }
}
//
- (void)creatZheXinWithPoint:(NSArray *)pointArr {
    //折线图
    LineChartData *d1x = [[LineChartData alloc] init];
    d1x.rateArray = pointArr;
    d1x.itemCount = pointArr.count;
    
    LineChartView *chartView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 50, Screen_width, 105)];
    chartView.monthPadding=roundf((Screen_width-28-45)/d1x.itemCount)+1;
    chartView.data=@[d1x];
    
    chartView.userInteractionEnabled = NO;
    chartView.backgroundColor = [UIColor clearColor];
    [brokenLineBackView addSubview:chartView];

}

#pragma mark - UISegmentedControl响应事件
- (IBAction)brokenSegmentdConClick:(UISegmentedControl *)sender {
    showType = (int)sender.selectedSegmentIndex + 1;
    [brokenTableView.mj_header beginRefreshing];
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
    static NSString *RecordSubViewCellID = @"RecordSubViewCellID";
    RecordSubViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordSubViewCellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RecordSubViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count) {
        BrokenModel *model = (BrokenModel *)_dataArr[indexPath.row];
        
        cell.jiluLabel.text = [NSString stringWithFormat:@"%@%@",model.num,unit];
        cell.paiminLabel.text = model.ordernum;
        
        NSArray *timeArr = [model.addtime componentsSeparatedByString:@" "];
        NSArray *subTimeArr = [timeArr.firstObject componentsSeparatedByString:@"-"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@/%@/%@",subTimeArr.firstObject,subTimeArr[1],subTimeArr.lastObject];
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
