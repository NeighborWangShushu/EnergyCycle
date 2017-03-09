//
//  SetProjectVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SetProjectVC.h"
#import "SetProjectCell.h"
#import "ConfirmPormiseVC.h"

@interface SetProjectVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSDate *startDate; // 日期控件开始时间
    NSDate *endDate; // 日期控件结束时间
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *startTimeTextField;
@property (nonatomic, strong) UITextField *endTimeTextField;
@property (nonatomic, strong) UITextField *dailyNumberTextField;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, assign) NSInteger dailyNumber;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation SetProjectVC

static NSString * const setProjectCell = @"SetProjectCell";

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 195) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.masksToBounds = NO;
    self.tableView.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
    self.tableView.layer.shadowOpacity = 0.2;
    self.tableView.layer.shadowOffset = CGSizeMake(0, 2);
    [self.view addSubview:self.tableView];
    
}

- (void)createNextButton {
    
    CGFloat nextButton_x = Screen_width * 0.2;
    CGFloat nextButton_y = CGRectGetMaxY(self.tableView.frame) + 80;
    CGFloat nextButton_w = Screen_width * 0.6;
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(nextButton_x, nextButton_y, nextButton_w, 45)];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:[UIColor clearColor]];
    self.nextButton.layer.cornerRadius = self.nextButton.frame.size.height / 2;
    [self.nextButton.layer setBorderWidth:1];
    [self.nextButton.layer setBorderColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor];
    self.nextButton.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
    self.nextButton.layer.shadowOpacity = 0.5;
    self.nextButton.layer.shadowOffset = CGSizeMake(0, 2);
    self.nextButton.enabled = NO;
    [self.nextButton addTarget:self action:@selector(fullPromise) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
}

- (void)setStartAndEndDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    startDate = [NSDate date];
//    NSString *startDate_str = [formatter stringFromDate:startDate];
//    startDate = [formatter dateFromString:startDate_str];
    endDate = [formatter dateFromString:@"2099-12-31"];
}

- (void)fullPromise {
    NSLog(@"%@,%@",startDate, endDate);
    
    // 加上时差
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
    ConfirmPormiseVC *cpVC = [[ConfirmPormiseVC alloc] init];
    cpVC.model = self.model;
    cpVC.startDate = [startDate dateByAddingTimeInterval:interval];;
    cpVC.endDate = [endDate dateByAddingTimeInterval:interval];;
    cpVC.promise_number = self.dailyNumberTextField.text.integerValue;
    [self.navigationController pushViewController:cpVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"制定目标";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    [self createTableView];
    [self createNextButton];
    [self setStartAndEndDate];
    
    // Do any additional setup after loading the view.
}

#pragma mark - UITablViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SetProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:setProjectCell];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:setProjectCell owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell getDataWithModelIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        self.startTimeTextField = cell.timeTextField;
        self.startTimeTextField.delegate = self;
        [cell lineView];
    } else if (indexPath.row == 1) {
        self.endTimeTextField = cell.timeTextField;
        self.endTimeTextField.delegate = self;
        [cell lineView];
    } else if (indexPath.row == 2) {
        cell.unitLabel.text = self.model.unit;
        self.dailyNumberTextField = cell.numberTextField;
        [self.dailyNumberTextField addTarget:self action:@selector(judgeNext) forControlEvents:UIControlEventEditingChanged];
        self.dailyNumberTextField.delegate = self;
    }
    
    return cell;
    
}

#pragma mark - UITextFieldDelagete

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (self.datePicker.superview) {
        [self.datePicker removeFromSuperview];
    }

    if (textField == self.startTimeTextField) {
        [self createDatePickerWithNum:1];
        return NO;
    } else if (textField == self.endTimeTextField) {
        [self createDatePickerWithNum:2];
        return NO;
    } else if (textField == self.dailyNumberTextField) {
        return YES;
    }
    
    return NO;
    
}

- (void)judgeNext {
    
    if (self.startTimeTextField.text.length && self.endTimeTextField.text.length && self.dailyNumberTextField.text.length) {
        self.nextButton.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nextButton.enabled = YES;
    } else {
        self.nextButton.backgroundColor = [UIColor clearColor];
        [self.nextButton setTitleColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
        self.nextButton.enabled = NO;
    }
    
}

- (void)createDatePickerWithNum:(NSInteger)num {
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, Screen_Height- 180 - 64, Screen_width, 180)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setDate:[NSDate date] animated:YES];
    // 设置日期选择器的时区为系统时区
    [self.datePicker setTimeZone:[NSTimeZone systemTimeZone]];
    if (num == 1) {
        self.datePicker.minimumDate = startDate;
        self.datePicker.maximumDate = endDate;
    } else if (num == 2) {
        self.datePicker.minimumDate = startDate;
    }
    [self addTargetWithNum:num];
    [self.view addSubview:self.datePicker];
    
}

- (void)addTargetWithNum:(NSInteger)num {
    
    if (num == 1) {
        [self.datePicker addTarget:self action:@selector(sureStartTime:) forControlEvents:UIControlEventValueChanged];
    } else if (num == 2) {
        [self.datePicker addTarget:self action:@selector(sureEndTime:) forControlEvents:UIControlEventValueChanged];
    }
    
}

- (void)sureStartTime:(UIDatePicker *)picker {
    
    NSDate *selectedDate = picker.date;
    startDate = selectedDate;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm +0800"];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    startDate = [selectedDate dateByAddingTimeInterval:[zone secondsFromGMTForDate:selectedDate]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:selectedDate];
    self.startTimeTextField.text = dateString;
    [self judgeNext];
    
}


- (void)sureEndTime:(UIDatePicker *)picker {
    
    NSDate *selectedDate = picker.date;
    endDate = selectedDate;
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    endDate = [selectedDate dateByAddingTimeInterval:[zone secondsFromGMTForDate:selectedDate]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:selectedDate];
    self.endTimeTextField.text = dateString;
    [self judgeNext];
    
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