//
//  ConfirmPormiseVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ConfirmPormiseVC.h"
#import "FSCalendar.h"
#import "CalendarCell.h"
#import "Masonry.h"

@interface ConfirmPormiseVC ()<FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance> {
    NSInteger duration;
    NSInteger promise;
    NSString *promise_unit;
}

@property (nonatomic, assign) NSInteger Count;

@property (nonatomic, weak) FSCalendar *calendar;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSMutableDictionary *dates;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation ConfirmPormiseVC

- (NSMutableDictionary *)dates {
    if (!_dates) {
        self.dates = [NSMutableDictionary dictionary];
    }
    return _dates;
}

- (void)createHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, Screen_width, 150);
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel setText:self.model.name];
    [titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:20]];
    [titleLabel setTextColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1]];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.centerX.equalTo(headerView);
    }];
    
    UILabel *durationTitle = [UILabel new];
    [durationTitle setText:@"目标时长"];
    durationTitle.textAlignment = NSTextAlignmentCenter;
    [durationTitle setFont:[UIFont systemFontOfSize:12]];
    [headerView addSubview:durationTitle];
    [durationTitle setTextColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]];
    [durationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@60);
        make.top.equalTo(@75);
    }];
    
    UILabel *durationLabel = [UILabel new];
    [durationLabel setText:[NSString stringWithFormat:@"%ld天",(unsigned long)self.dates.count]];
    [durationLabel setFont:[UIFont systemFontOfSize:15]];
    [durationLabel setTextColor:[UIColor blackColor]];
    [headerView addSubview:durationLabel];
    [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(durationTitle.mas_top).with.offset(20);
        make.centerX.equalTo(durationTitle);
    }];
    
    UILabel *promiseTitle = [UILabel new];
    [promiseTitle setText:@"每日目标"];
    [promiseTitle setFont:[UIFont systemFontOfSize:12]];
    [promiseTitle setTextColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]];
    [headerView addSubview:promiseTitle];
    [promiseTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-60);
        make.top.equalTo(@75);
    }];
    
    UILabel *promiseLabel = [UILabel new];
    [promiseLabel setText:[NSString stringWithFormat:@"%ld%@", (long)self.promise_number, self.model.unit]];
    [promiseLabel setFont:[UIFont systemFontOfSize:15]];
    [promiseLabel setTextColor:[UIColor blackColor]];
    [headerView addSubview:promiseLabel];
    [promiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promiseTitle.mas_top).with.offset(20);
        make.centerX.equalTo(promiseTitle);
    }];
    
    if ([self.model.unit isEqualToString:@"天"]) {
        [durationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(titleLabel);
            make.top.equalTo(@75);
        }];
        promiseTitle.hidden = YES;
        promiseLabel.hidden = YES;
    }
    
}

- (void)createSureButton {
    self.sureButton = [[UIButton alloc] init];
    [self.sureButton setTitle:@"完成制定" forState:UIControlStateNormal];
    [self.sureButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendar.mas_bottom).with.offset(80);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(Screen_width * 0.6));
        make.height.equalTo(@45);
    }];
    self.sureButton.layer.cornerRadius = 45 / 2;
    self.sureButton.layer.shadowOpacity = 0.5;
    self.sureButton.layer.shadowOffset = CGSizeMake(0, 2);
    [self.sureButton addTarget:self action:@selector(addPromise) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *sureLabel = [[UILabel alloc] init];
    if (self.dates.count < 5) {
        self.sureButton.enabled = NO;
        [self.sureButton setBackgroundColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]];
        self.sureButton.layer.shadowColor = [UIColor blackColor].CGColor;
        [sureLabel setText:@"制定目标最少要求5天"];
    } else {
        self.sureButton.enabled = YES;
        [self.sureButton setBackgroundColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1]];
        self.sureButton.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
        [sureLabel setText:@"制定完成后,不可更改"];
    }
    [sureLabel setFont:[UIFont systemFontOfSize:12]];
    [sureLabel setTextColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]];
    [self.view addSubview:sureLabel];
    [sureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureButton.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.sureButton);
    }];
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    [self getAllDate];
    [self createHeaderView];

    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 150, view.frame.size.width, 300)];
    calendar.scope = FSCalendarScopeWeek;
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = [UIColor whiteColor];
    
    // 星期的view下面添加底部边框
    CALayer *headerView_bottomBorder = [CALayer layer];
    CGFloat h_y = 25;
    CGFloat h_w = view.frame.size.width;
    headerView_bottomBorder.frame = CGRectMake(0.0f, h_y, h_w, 1.0f);
    headerView_bottomBorder.backgroundColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:0.6].CGColor;
    [calendar.calendarWeekdayView.layer addSublayer:headerView_bottomBorder];
    
    [calendar selectDate:self.startDate scrollToDate:YES]; // 默认选择今天
    calendar.today = nil; // 隐藏今天的背景
    calendar.appearance.titleSelectionColor = [UIColor colorWithRed:255/255.0 green:225/255.0 blue:20/255.0 alpha:1]; // 选中时文字的颜色
    calendar.appearance.selectionColor = [UIColor clearColor]; // 去除选中时的背景颜色
    calendar.appearance.weekdayTextColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1]; // 日的字体颜色
    calendar.appearance.titleDefaultColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]; // 星期的字体颜色
//    calendar.headerHeight = 0; // 顶部月份隐藏
    calendar.appearance.headerTitleColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1]; // 顶部月份文字颜色
    calendar.appearance.headerDateFormat = @"yyyy-MM"; // 顶部月份显示格式
    calendar.appearance.headerMinimumDissolvedAlpha = 0; // 顶部上下月份显示的透明度
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesSingleUpperCase; // 修改星期显示文字
    
    // 给calendar底部添加阴影
    CALayer *calendar_bottomBorder = [CALayer layer];
    CGFloat c_y = calendar.frame.size.height;
    CGFloat c_w = calendar.frame.size.width;
    calendar_bottomBorder.frame = CGRectMake(0.0f, c_y, c_w, 1.0f);
    calendar_bottomBorder.backgroundColor = [UIColor clearColor].CGColor;
    [calendar.layer addSublayer:calendar_bottomBorder];
    calendar.layer.shadowOpacity = 0.2;
    calendar.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
    calendar.layer.shadowOffset = CGSizeMake(0, 4);
    calendar.layer.shadowRadius = 3;
    [calendar registerClass:[CalendarCell class] forCellReuseIdentifier:@"cell"]; // 注册CalendarCell
    
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    [self createSureButton];
}

- (void)hintView {
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.cancelButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.cancelButton addTarget:self action:@selector(hintKnow) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.cancelButton];
    
    UIView *hintView = [[UIView alloc] init];
    hintView.backgroundColor = [UIColor whiteColor];
    [self.cancelButton addSubview:hintView];
    [hintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cancelButton);
        make.centerY.equalTo(self.cancelButton);
        make.width.equalTo(self.cancelButton).multipliedBy(0.6);
        make.height.equalTo(@150);
    }];
    hintView.layer.cornerRadius = 20;
    hintView.layer.shadowColor = [UIColor blackColor].CGColor;
    hintView.layer.shadowOpacity = 0.2;
    hintView.layer.shadowRadius = 3;
    hintView.layer.shadowOffset = CGSizeMake(0, 0);
    
    UILabel *hintLabel = [[UILabel alloc] init];
    [hintLabel setText:@"您在这个时间段中已有相同的目标"];
    hintLabel.font = [UIFont systemFontOfSize:14];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.numberOfLines = 0;
    [hintView addSubview:hintLabel];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hintView).with.offset(-20);
        make.centerX.equalTo(hintView);
        make.width.equalTo(hintView).multipliedBy(0.7);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    [hintView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(hintView).with.offset(-40);
        make.left.equalTo(hintView);
        make.right.equalTo(hintView);
        make.height.equalTo(@1);
    }];
    
    UIButton *know = [UIButton new];
    know.adjustsImageWhenHighlighted = NO;
    [know setTitle:@"确认" forState:UIControlStateNormal];
    [know setTitleColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
    [know addTarget:self action:@selector(hintKnow) forControlEvents:UIControlEventTouchUpInside];
    [hintView addSubview:know];
    [know mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).with.offset(5);
        make.width.equalTo(hintView);
        make.centerX.equalTo(hintView);
    }];
    
}

- (void)hintKnow {
    [self.cancelButton removeFromSuperview];
}

// 获取所有时间
- (void)getAllDate {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
    
    long nowTime = [[self.startDate dateByAddingTimeInterval:interval] timeIntervalSince1970]; //开始时间
    long endTime = [[self.endDate dateByAddingTimeInterval:interval] timeIntervalSince1970]; //结束时间
    long dayTime = 24*60*60;
    long time = nowTime - (nowTime % dayTime);
    
    while (time <= endTime) {
        NSString *showOldDate = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        [self.dates setValue:@"NO" forKey:showOldDate];
        time += dayTime;
    }
    
}

// 添加承诺
- (void)addPromise {
    
    self.sureButton.enabled = NO;
    
    NSString *startDate_str = [self.dateFormatter stringFromDate:self.startDate];
    NSString *endDate_str = [self.dateFormatter stringFromDate:self.endDate];
    
    NSString *postStr = [NSString stringWithFormat:@"【%@的公众承诺】，从%@至%@ ，每天完成%@项目%ld%@。我将坚守承诺，每天全力以赴，完成目标，若食言，将无法获得奖励积分，并追加扣除100积分作为惩罚，立帖为证！【来自能量圈APP-公众承诺】", User_NAME, startDate_str, endDate_str, self.model.name, self.promise_number, self.model.unit];
    
    [[AppHttpManager shareInstance] getAddTargetWithUserID:[User_ID intValue] Token:User_TOKEN StartDate:startDate_str EndDate:endDate_str ProjectID:[self.model.myId integerValue] ReportNum:self.promise_number PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [[AppHttpManager shareInstance] postAddArticleWithTitle:@"" Content:postStr VideoUrl:@"" UserId:[User_ID intValue] token:User_TOKEN List:nil Location:@"" UserList:nil PostOrGet:@"post" success:^(NSDictionary *dict) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController *backVC = self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:backVC animated:YES];
                });
                
            } failure:^(NSString *str) {
                NSLog(@"%@", str);
            }];
        } else if ([dict[@"Code"] integerValue] == 402 && [dict[@"IsSuccess"] integerValue] == 0) {
            self.sureButton.enabled = YES;
            [self hintView];
            
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

// 当前月份的行数变化时日历控件的高度也随之变化
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"目标概览";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FSCalendarDataSourse

// 返回自定义cell方法
- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position {
    CalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:position];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

// 设置每个选中的日期的文字颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    NSString *key = [self.dateFormatter stringFromDate:date];
    if ([self.dates.allKeys containsObject:key]) {
        return [UIColor whiteColor];
    }
    return nil;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

// 点击方法
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

// 取消点击方法
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

#pragma mark - Private methods

// 重新配置cell的方法
- (void)configureVisibleCells {
    
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
    
}

// 设置自定义的cell方法
- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    CalendarCell *calendarCell = (CalendarCell *)cell;
    
    if (monthPosition == FSCalendarMonthPositionCurrent) {
        
        SelectionType selectionType = SelectionTypeNone;
        NSString *key = [self.dateFormatter stringFromDate:date];
        if ([self.dates.allKeys containsObject:key]) {
            selectionType = SelectionTypeUndone;
        } else {
            selectionType = SelectionTypeNone;
        }
        
        calendarCell.selectionType = selectionType;
    }
    
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
