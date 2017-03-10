//
//  SinglePromiseDetailsVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SinglePromiseDetailsVC.h"
#import "FSCalendar.h"
#import "CalendarCell.h"
#import "Masonry.h"

@interface SinglePromiseDetailsVC ()<FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance>

@property (nonatomic, strong) UIButton *exitBackground;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, weak) FSCalendar *calendar;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSDictionary *dates;

@end

@implementation SinglePromiseDetailsVC

- (NSDictionary *)dates {
    if (!_dates) {
        self.dates = [NSDictionary dictionary];
    }
    return _dates;
}

- (void)createHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, Screen_width, 180);
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel setText:@"蹲起"];
    [titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:20]];
    [titleLabel setTextColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1]];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.centerX.equalTo(headerView);
    }];
    
    UILabel *durationTitle = [UILabel new];
    [durationTitle setText:@"目标时长"];
    [durationTitle setFont:[UIFont systemFontOfSize:12]];
    [headerView addSubview:durationTitle];
    [durationTitle setTextColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]];
    [durationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@60);
        make.top.equalTo(@75);
    }];
    
    UILabel *durationLabel = [UILabel new];
    [durationLabel setText:@"10天"];
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
    [promiseLabel setText:@"10个"];
    [promiseLabel setFont:[UIFont systemFontOfSize:15]];
    [promiseLabel setTextColor:[UIColor blackColor]];
    [headerView addSubview:promiseLabel];
    [promiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promiseTitle.mas_top).with.offset(20);
        make.centerX.equalTo(promiseTitle);
    }];
    
    UILabel *finishTimeLabel = [UILabel new];
    [finishTimeLabel setText:@"完成目标第4/10天"];
    [finishTimeLabel setFont:[UIFont systemFontOfSize:12]];
    [finishTimeLabel setTextColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]];
    [headerView addSubview:finishTimeLabel];
    [finishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(durationLabel.mas_bottom).with.offset(15);
    }];
    
    UILabel *finishLabel = [UILabel new];
    [finishLabel setText:@"完成"];
    [finishLabel setFont:[UIFont systemFontOfSize:12]];
    [finishLabel setTextColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]];
    [headerView addSubview:finishLabel];
    [finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-55);
        make.top.equalTo(promiseLabel.mas_bottom).with.offset(15);
    }];
    
    UILabel *finishPercentage = [UILabel new];
    [finishPercentage setText:@"40%"];
    [finishPercentage setFont:[UIFont systemFontOfSize:12]];
    [finishPercentage setTextColor:[UIColor blackColor]];
    [headerView addSubview:finishPercentage];
    [finishPercentage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.top.equalTo(promiseLabel.mas_bottom).with.offset(15);
    }];
    
    UIView *percentageView = [UIView new];
    [percentageView setBackgroundColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:0.3]];
    [headerView addSubview:percentageView];
    [percentageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.width.equalTo(@(Screen_width - 30));
        make.height.equalTo(@7);
        make.bottom.equalTo(@-20);
        percentageView.layer.cornerRadius = 7 / 2;
        CALayer *percentageLayer = [CALayer layer];
        CGFloat percentage = (Screen_width - 30) * 0.4;
        percentageLayer.frame = CGRectMake(0.0f, 0.0f, percentage, 7);
        percentageLayer.cornerRadius = 7 / 2;
        percentageLayer.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
        percentageLayer.shadowColor = percentageLayer.backgroundColor;
        percentageLayer.shadowOpacity = 0.5;
        percentageLayer.shadowOffset = CGSizeMake(2, 2);
        [percentageView.layer addSublayer:percentageLayer];
    }];
//    percentageView.layer.cornerRadius = 7/ 2;
//    CALayer *percentageLayer = [CALayer layer];
//    CGFloat percentage = percentageView.frame.size.width * 0.4;
//    percentageLayer.frame = CGRectMake(0.0f, 0.0f, percentage, percentageView.frame.size.height);
//    percentageLayer.cornerRadius = 7 / 2;
//    percentageLayer.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
//    percentageLayer.shadowColor = percentageLayer.backgroundColor;
//    percentageLayer.shadowOpacity = 0.5;
//    percentageLayer.shadowOffset = CGSizeMake(2, 2);
//    [percentageView.layer addSublayer:percentageLayer];
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
//    [self getAllDate];
    [self createHeaderView];
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 180, view.frame.size.width, 300)];
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
    
    [calendar selectDate:[NSDate date] scrollToDate:YES]; // 默认选择今天
    calendar.today = nil; // 隐藏今天的背景
    calendar.appearance.titleSelectionColor = [UIColor colorWithRed:255/255.0 green:225/255.0 blue:20/255.0 alpha:1]; // 选中时文字的颜色
    calendar.appearance.selectionColor = [UIColor clearColor]; // 去除选中时的背景颜色
    calendar.appearance.weekdayTextColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1]; // 日的字体颜色
    calendar.appearance.titleDefaultColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]; // 星期的字体颜色
    calendar.headerHeight = 0; // 顶部月份隐藏
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
    
}

- (void)getData {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    
    
    
}

// 当前月份的行数变化时日历控件的高度也随之变化
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    
    // 底部阴影浮层
    self.exitBackground = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exitBackground.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.exitBackground.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.exitBackground.alpha = 0;
    [self.exitBackground addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.exitBackground];
    
    // 创建底部View
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_width, 130)];
    [self.exitBackground addSubview:self.bottomView];
    
    // 退出目标按钮
    UIButton *exitPromise = [UIButton new];
    [exitPromise setTitle:@"退出目标" forState:UIControlStateNormal];
    [exitPromise setTitleColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
    [exitPromise setBackgroundColor:[UIColor whiteColor]];
    [exitPromise addTarget:self action:@selector(exitPromise) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:exitPromise];
    [exitPromise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.width.equalTo(self.bottomView.mas_width).with.offset(-20);
        make.height.equalTo(@50);
        make.top.equalTo(@10);
    }];
    exitPromise.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
    exitPromise.layer.shadowOpacity = 0.3;
    exitPromise.layer.shadowRadius = 3;
    exitPromise.layer.shadowOffset = CGSizeMake(0, 0);
    
    // 取消按钮
    UIButton *cancelButton = [UIButton new];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.width.equalTo(self.bottomView.mas_width).with.offset(-20);
        make.height.equalTo(@50);
        make.top.equalTo(exitPromise.mas_bottom).with.offset(10);
    }];
    
    CGPoint addPoint = self.bottomView.center;
    addPoint.y -= self.bottomView.frame.size.height;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:2
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.bottomView.center = addPoint;
                         self.exitBackground.alpha = 1;
    } completion:nil];
    
}

- (void)cancel {
    CGPoint cancelPoint = self.bottomView.center;
    cancelPoint.y += self.bottomView.frame.size.height;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.bottomView.center = cancelPoint;
        self.exitBackground.alpha = 0;
    } completion:^(BOOL finished) {
        [self.exitBackground removeFromSuperview];
    }];
}

// 退出目标
- (void)exitPromise {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"目标详情";
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    [self setupRightNavBarWithimage:@"Promise_Del"];
    
    [self createHeaderView];
    
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
