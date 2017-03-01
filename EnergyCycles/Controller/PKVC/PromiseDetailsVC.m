//
//  PromiseDetailsVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PromiseDetailsVC.h"
#import "CalendarCell.h"

@interface PromiseDetailsVC ()

@property (strong, nonatomic) NSCalendar *greforian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSDictionary *dates;

@end

@implementation PromiseDetailsVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy/MM/dd";
        
        self.dates = @{@"2017/02/07" : @"YES",
                       @"2017/02/08" : @"YES",
                       @"2017/02/09" : @"YES",
                       @"2017/02/10" : @"NO",
                       @"2017/02/11" : @"YES",
                       @"2017/02/12" : @"NO",
                       @"2017/02/13" : @"YES",
                       @"2017/02/14" : @"NO",
                       @"2017/02/15" : @"NO",
                       @"2017/02/16" : @"NO",
                       @"2017/02/17" : @"NO",
                       @"2017/02/18" : @"NO"};
        
    }
    return self;
}


- (NSDictionary *)dates {
    if (!_dates) {
        self.dates = [NSDictionary dictionary];
    }
    return _dates;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, view.frame.size.width, 300)];
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
    calendar.placeholderType = FSCalendarPlaceholderTypeNone; // 隐藏其他月份的日,只显示当前月份的日期
//    calendar.headerHeight = 0; // 顶部月份隐藏
    calendar.appearance.headerTitleColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1]; // 顶部月份文字颜色
    calendar.appearance.headerDateFormat = @"yyyy/MM"; // 顶部月份显示格式
    calendar.appearance.headerMinimumDissolvedAlpha = 0; // 顶部上下月份显示的透明度
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesSingleUpperCase; // 修改星期显示文字
//    calendar.layer.borderColor = [UIColor clearColor].CGColor;
//    calendar.calendarWeekdayView.layer.borderColor = [UIColor clearColor].CGColor;
    
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

// 当前月份的行数变化时日历控件的高度也随之变化
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
//    self.bottomContainer.frame = kContainerFrame;
}

//- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
//{
//    return [self.dateFormatter dateFromString:@"2016-01-08"];
//}
//
//- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
//{
//    return [self.dateFormatter dateFromString:@"2018-10-08"];
//}

#pragma mark - FSCalendarDataSource

// 提醒为今日的下标
- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date
{
    if ([self.greforian isDateInToday:date]) {
        UIImage *markImage = [UIImage imageNamed:@"calendar_mark"];
        return markImage;
    }
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position {
    CalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:position];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

//// 标记数量
//- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
//    if ([self.greforian isDateInToday:date]) {
//        return 1;
//    }
//    return 0;
//}
//
//// 标记颜色
//- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date {
//    if ([self.greforian isDateInToday:date]) {
//        return @[[UIColor redColor]];
//    }
//    return @[appearance.eventDefaultColor];
//}

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

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.greforian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
//    [self configureVisibleCells];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)configureVisibleCells {
    
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
    
}


- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    CalendarCell *calendarCell = (CalendarCell *)cell;
    
    if (monthPosition == FSCalendarMonthPositionCurrent) {
        
        SelectionType selectionType = SelectionTypeNone;
        NSString *key = [self.dateFormatter stringFromDate:date];
        if ([self.dates.allKeys containsObject:key]) {
            if ([self.dates[key] isEqualToString:@"YES"]) {
                selectionType = SelectionTypeFinish;
            } else {
                selectionType = SelectionTypeUndone;
            }
        } else {
            selectionType = SelectionTypeNone;
        }
        
        calendarCell.selectionType = selectionType;
        
    }
    
    if ([self.greforian isDateInToday:date]) {
        calendarCell.titleLabel.tintColor = [UIColor colorWithRed:255/255.0 green:225/255.0 blue:20/255.0 alpha:1];
        calendarCell.appearance.titleSelectionColor = [UIColor colorWithRed:255/255.0 green:225/255.0 blue:20/255.0 alpha:1];
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
