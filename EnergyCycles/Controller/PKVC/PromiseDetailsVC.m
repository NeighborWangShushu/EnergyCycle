//
//  PromiseDetailsVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PromiseDetailsVC.h"
#import "CalendarCell.h"
#import "Masonry.h"
#import "DailyPromiseTableViewCell.h"
#import "PromiseDetailModel.h"

@interface PromiseDetailsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSCalendar *greforian;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSMutableDictionary *dates;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *datesDic;

@property (strong, nonatomic) NSString *selectedDate;

@end

@implementation PromiseDetailsVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return self;
}

- (NSMutableDictionary *)datesDic {
    if (!_datesDic) {
        self.datesDic = [NSMutableDictionary dictionary];
    }
    return _datesDic;
}

- (NSMutableDictionary *)dates {
    if (!_dates) {
        self.dates = [NSMutableDictionary dictionary];
    }
    return _dates;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 300)];
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
    CGRect rect = self.view.bounds;
    rect.origin.y += CGRectGetMaxY(self.calendar.frame);
    rect.size.height -= CGRectGetMaxY(self.calendar.frame);
    self.tableView.frame = rect;
//    self.bottomContainer.frame = kContainerFrame;
}

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

// 切换月份的方法
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    [self getData];
}

// 点击日期的方法
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

// 取消当前日期的方法
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    [self.tableView reloadData];
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (void)createView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -15, Screen_width, 15)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIView *tagView = [UIView new];
    tagView.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    [headerView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).with.offset(10);
        make.width.equalTo(@30);
        make.centerX.equalTo(headerView);
        make.height.equalTo(@3);
        tagView.layer.cornerRadius = 1.5;
    }];
    
    
}

- (void)createTableView {
    
    CGRect rect = self.view.bounds;
    rect.origin.y += CGRectGetMaxY(self.calendar.frame);
    rect.size.height -= CGRectGetMaxY(self.calendar.frame);
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
}

- (void)createIndicatorImg {
    self.indicatorImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ecpicker_drop"]];
    self.indicatorImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.calendar addSubview:self.indicatorImg];
    [self.indicatorImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.calendar.mas_centerX).with.offset(40);
        make.top.equalTo(@15);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self createView];
    [self createIndicatorImg];
    [self createTableView];
    self.greforian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
//    [self configureVisibleCells];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    
    // 获取上个月月初和下个月月末的日期,获取三个月的数据
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self.calendar.currentPage];
    NSDateComponents *newComps = [[NSDateComponents alloc] init];
    [newComps setMonth:-1];
    NSDate *startDate = [calendar dateByAddingComponents:newComps toDate:self.calendar.currentPage options:0];
    [newComps setMonth:3];
    [newComps setDay:-1];
    NSDate *endDate = [calendar dateByAddingComponents:newComps toDate:self.calendar.currentPage options:0];
    NSString *startDate_str = [self.dateFormatter stringFromDate:startDate];
    NSString *endDate_str = [self.dateFormatter stringFromDate:endDate];
    
    // 请求数据
    [[AppHttpManager shareInstance] getMyTargetDetailsListWithUserID:[User_ID integerValue] StartDate:startDate_str EndDate:endDate_str PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            NSDictionary *dataDic = dict[@"Data"];
            [self.dates removeAllObjects];
            [self.datesDic removeAllObjects];
            for (NSDictionary *dateDic in dataDic) {
                NSMutableArray *dateArray = [NSMutableArray array];
                BOOL isFinish = YES;
                for (NSDictionary *dic in dataDic[dateDic]) {
                    PromiseDetailModel *model = [[PromiseDetailModel alloc] initWithDictionary:dic error:nil];
                    if ([model.IsFinish isEqualToString:@"0"]) {
                        isFinish = NO;
                    }
                    [dateArray addObject:model];
                }
                if (isFinish) {
                    [self.dates setObject:@"YES" forKey:dateDic];
                } else {
                    [self.dates setObject:@"NO" forKey:dateDic];
                }
                
                [self.datesDic setObject:dateArray forKey:dateDic];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.calendar reloadData];
                [self.tableView reloadData];
            });
            
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
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
    
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - TableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *date = [self.dateFormatter stringFromDate:self.calendar.selectedDate];
    return [self.datesDic[date] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *dailyPromiseTableViewCell = @"DailyPromiseTableViewCell";
    DailyPromiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dailyPromiseTableViewCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:dailyPromiseTableViewCell owner:self options:nil].firstObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *date = [self.dateFormatter stringFromDate:self.calendar.selectedDate];
    PromiseDetailModel *model = self.datesDic[date][indexPath.row];
    [cell getDataWithModel:model];
    
    return cell;
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
