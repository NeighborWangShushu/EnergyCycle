//
//  CoursesCompletedViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CoursesCompletedViewController.h"

#import "CoursesInputViewController.h"
#import "CourseChooseTableViewCell.h"

#import "CityDataManager.h"

#import "CourseDetailViewController.h"

@interface CoursesCompletedViewController () <UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    UIButton *rightButton;
    
    NSArray *oneArr;
    NSArray *twoArr;
    NSInteger oneSection;
    NSInteger twoIndex;
    
    NSMutableDictionary *postDict;
    NSMutableArray *addressArr;
    NSArray *pickerArray;
    
    UIPickerView *onePickerView;
    UIDatePicker *_datePicker;
    
    
    UIPickerView *subPickView;
    NSInteger oneSelect;
    NSInteger twoSelect;
    NSInteger thrSelect;
}

@property (nonatomic, strong) NSArray *shengDataArr;
@property (nonatomic, strong) NSMutableArray *shiDataArr;
@property (nonatomic, strong) NSMutableArray *xianDataArr;


@end

@implementation CoursesCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程";
    
    oneArr = @[@"学员姓名",@"性别",@"生日",@"电话",@"邮箱",@"城市",@"地址",@"学校/年级/班级"];
    twoArr = @[@"父亲姓名",@"父亲电话",@"母亲姓名",@"母亲电话"];
    
    postDict = [[NSMutableDictionary alloc] init];
    pickerArray = @[@"男",@"女"];
    addressArr = [[NSMutableArray alloc] init];
    
    [addressArr addObject:@"上海"];
    //
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    //
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baomingChangeProfileDict:) name:@"isBaoMingChangeProfileDict" object:nil];
    
    //
    [postDict setObject:self.getSubDict[@"people"] forKey:@"people"];
    [postDict setObject:self.getSubDict[@"courseTime"] forKey:@"courseTime"];
    [postDict setObject:self.getSubDict[@"coursePath"] forKey:@"coursePath"];
    [postDict setObject:self.getSubDict[@"courseServer"] forKey:@"courseServer"];
    [postDict setObject:self.getSubDict[@"back"] forKey:@"back"];//备注
    
    [postDict setObject:@"请输入" forKey:@"stuName"];
    [postDict setObject:@"选择性别" forKey:@"stuSex"];
    [postDict setObject:@"请选择生日" forKey:@"stuBirth"];
    [postDict setObject:@"输入电话" forKey:@"stuPhone"];
    [postDict setObject:@"请输入邮箱" forKey:@"stuEmail"];
    [postDict setObject:@"请选择城市" forKey:@"stuCity"];
    [postDict setObject:@"添加地址" forKey:@"stuAddress"];
    [postDict setObject:@"添加学校/年级/班级" forKey:@"stuGrade"];
    [postDict setObject:@"父亲姓名" forKey:@"stuFatherName"];
    [postDict setObject:@"父亲电话" forKey:@"stuFatherPhone"];
    [postDict setObject:@"母亲姓名" forKey:@"stuMotherName"];
    [postDict setObject:@"母亲电话" forKey:@"stuMotherPhone"];
    
    oneSelect = 0;
    twoSelect = 0;
    thrSelect = 0;
    self.shiDataArr = [[NSMutableArray alloc] init];
    self.xianDataArr = [[NSMutableArray alloc] init];
    
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

#pragma mark - 键盘事件
- (void)keyboardWillShow:(NSNotification *)notif {
    [onePickerView removeFromSuperview];
    onePickerView = nil;
    
    [subPickView removeFromSuperview];
    subPickView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.shengDataArr.count && !self.shiDataArr.count && !self.xianDataArr.count) {
        //选择省份
        self.shengDataArr = [NSArray arrayWithArray:[CityDataManager getProvinceData]];
        
        //选择城市
        for (NSDictionary *dict in self.shengDataArr) {
            NSArray *shiArr = [NSArray arrayWithArray:[CityDataManager getCityDataWithProvince:dict]];
            [self.shiDataArr addObject:shiArr];
        }
        
        //选择县区
        for (NSArray *cityArr in self.shiDataArr) {
            NSMutableArray *cityXianArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in cityArr) {
                NSArray *xianArr = [NSArray arrayWithArray:[CityDataManager getCountiesWithCity:dict]];
                [cityXianArr addObject:xianArr];
            }
            [self.xianDataArr addObject:cityXianArr];
        }
    }
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 消息中心提交数据
- (void)baomingChangeProfileDict:(NSNotification *)notification {
    NSDictionary *getDict = [notification object];
    
    if ([getDict[@"section"] integerValue] == 0) {
        if ([getDict[@"index"] integerValue] == 0) {
            [postDict setObject:getDict[@"text"] forKey:@"stuName"];
        }else if ([getDict[@"index"] integerValue] == 1) {
            [postDict setObject:getDict[@"text"] forKey:@"stuSex"];
        }else if ([getDict[@"index"] integerValue] == 2) {
            [postDict setObject:getDict[@"text"] forKey:@"stuBirth"];
        }else if ([getDict[@"index"] integerValue] == 3) {
            [postDict setObject:getDict[@"text"] forKey:@"stuPhone"];
        }else if ([getDict[@"index"] integerValue] == 4) {
            [postDict setObject:getDict[@"text"] forKey:@"stuEmail"];
        }else if ([getDict[@"index"] integerValue] == 5) {
            [postDict setObject:getDict[@"text"] forKey:@"stuCity"];
        }else if ([getDict[@"index"] integerValue] == 6) {
            [postDict setObject:getDict[@"text"] forKey:@"stuAddress"];
        }else if ([getDict[@"index"] integerValue] == 7) {
            [postDict setObject:getDict[@"text"] forKey:@"stuGrade"];
        }
    }else {
        if ([getDict[@"index"] integerValue] == 0) {
            [postDict setObject:getDict[@"text"] forKey:@"stuFatherName"];
        }else if ([getDict[@"index"] integerValue] == 1) {
            [postDict setObject:getDict[@"text"] forKey:@"stuFatherPhone"];
        }else if ([getDict[@"index"] integerValue] == 2) {
            [postDict setObject:getDict[@"text"] forKey:@"stuMotherName"];
        }else {
            [postDict setObject:getDict[@"text"] forKey:@"stuMotherPhone"];
        }
    }
    [courseComTableView reloadData];
}

#pragma mark - 完成按键响应事件
- (void)rightAction {
    [_datePicker removeFromSuperview];
    _datePicker = nil;
    
    [onePickerView removeFromSuperview];
    onePickerView = nil;
    
    [subPickView removeFromSuperview];
    subPickView = nil;
    
    [self.view endEditing:YES];
    
    if (User_TOKEN.length <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        if ([postDict[@"stuName"] isEqualToString:@"请输入"]) {
            [SVProgressHUD showImage:nil status:@"请输入姓名"];
        }else if ([postDict[@"stuSex"] isEqualToString:@"选择性别"]) {
            [SVProgressHUD showImage:nil status:@"选择性别"];
        }else if ([postDict[@"stuBirth"] isEqualToString:@"请选择生日"]) {
            [SVProgressHUD showImage:nil status:@"请选择生日"];
        }else if ([postDict[@"stuCity"] isEqualToString:@"请选择城市"]) {
            [SVProgressHUD showImage:nil status:@"请选择城市"];
        }else if ([postDict[@"stuAddress"] isEqualToString:@"添加地址"]) {
            [SVProgressHUD showImage:nil status:@"请添加地址"];
        }else if ([postDict[@"stuGrade"] isEqualToString:@"添加学校/年级/班级"]) {
            [SVProgressHUD showImage:nil status:@"请添加学校/年级/班级"];
        }else if ([postDict[@"stuFatherName"] isEqualToString:@"父亲姓名"]) {
            [SVProgressHUD showImage:nil status:@"请输入父亲姓名"];
        }else if ([postDict[@"stuFatherPhone"] isEqualToString:@"父亲电话"]) {
            [SVProgressHUD showImage:nil status:@"请输入父亲电话"];
        }else if ([postDict[@"stuMotherName"] isEqualToString:@"母亲姓名"]) {
            [SVProgressHUD showImage:nil status:@"请输入母亲姓名"];
        }else if ([postDict[@"stuMotherPhone"] isEqualToString:@"母亲电话"]) {
            [SVProgressHUD showImage:nil status:@"请输入母亲电话"];
        }else {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showWithStatus:@"提交中.."];
            
            if ([postDict[@"stuPhone"] isEqualToString:@"输入电话"]) {
                [postDict setObject:@"" forKey:@"stuPhone"];
            }
            if ([postDict[@"stuEmail"] isEqualToString:@"请输入邮箱"]) {
                [postDict setObject:@"" forKey:@"stuEmail"];
            }
            
            [[AppHttpManager shareInstance] getGetStudyGoodListWithPeople:postDict[@"people"]
                                                                 courseId:[self.courseID intValue]
                                                               CourseTime:postDict[@"courseTime"]
                                                               CoursePath:postDict[@"coursePath"]
                                                             CourseServer:postDict[@"courseServer"]
                                                                     Back:postDict[@"back"]
                                                                  StuName:postDict[@"stuName"]
                                                                   StuSex:postDict[@"stuSex"]
                                                                 StuBirth:postDict[@"stuBirth"]
                                                                 StuPhone:postDict[@"stuPhone"]
                                                                 StuEmail:postDict[@"stuEmail"]
                                                                  StuCity:postDict[@"stuCity"]
                                                               StuAddress:postDict[@"stuAddress"]
                                                                 StuGrade:postDict[@"stuGrade"]
                                                            StuFatherName:postDict[@"stuFatherName"]
                                                           StuFatherPhone:postDict[@"stuFatherPhone"]
                                                            StuMotherName:postDict[@"stuMotherName"]
                                                           StuMotherPhone:postDict[@"stuMotherPhone"]
                                                                PostOrGet:@"post" success:^(NSDictionary *dict) {
                                                                    NSLog(@"报名：%@",dict);
                                                                    if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                                                                        [SVProgressHUD showImage:nil status:@"报名成功"];
                                                                        
                                                                        for (UIViewController *subVC in self.navigationController.viewControllers) {
                                                                            if ([subVC isKindOfClass:[CourseDetailViewController class]]) {
                                                                                [self.navigationController popToViewController:subVC animated:YES];
                                                                            }
                                                                        }
                                                                    }else if ([dict[@"Code"] integerValue] == 10000) {
                                                                        [SVProgressHUD showImage:nil status:@"登录失效"];
                                                                        [self.navigationController popToRootViewControllerAnimated:NO];
                                                                    }else {
                                                                        [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                                                                    }
                                                                } failure:^(NSString *str) {
                                                                    NSLog(@"%@",str);
                                                                    [SVProgressHUD dismiss];
                                                                }];
        }
    }
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return oneArr.count;
    }
    return twoArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CourseChooseTableViewCellId = @"CourseChooseTableViewCellId";
    CourseChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CourseChooseTableViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CourseChooseTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.leftTwoLabel.text = @"";
    if (indexPath.section == 0) {
        cell.leftOneLabel.text = oneArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.rightLabel.text = postDict[@"stuName"];
        }else if (indexPath.row == 1) {
            cell.rightLabel.text = postDict[@"stuSex"];
        }else if (indexPath.row == 2) {
            cell.rightLabel.text = postDict[@"stuBirth"];
        }else if (indexPath.row == 3) {
            cell.leftTwoLabel.text = @"(选填)";
            cell.rightLabel.text = postDict[@"stuPhone"];
        }else if (indexPath.row == 4) {
            cell.leftTwoLabel.text = @"(选填)";
            cell.rightLabel.text = postDict[@"stuEmail"];
        }else if (indexPath.row == 5) {
            cell.rightLabel.text = postDict[@"stuCity"];
        }else if (indexPath.row == 6) {
            cell.rightLabel.text = postDict[@"stuAddress"];
        }else if (indexPath.row == 7) {
            cell.rightLabel.text = postDict[@"stuGrade"];
        }
    }else {
        cell.leftOneLabel.text = twoArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.rightLabel.text = postDict[@"stuFatherName"];
        }else if (indexPath.row == 1) {
            cell.rightLabel.text = postDict[@"stuFatherPhone"];
        }else if (indexPath.row == 2) {
            cell.rightLabel.text = postDict[@"stuMotherName"];
        }else {
            cell.rightLabel.text = postDict[@"stuMotherPhone"];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 10)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 25.f;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 25)];
        footView.backgroundColor = [UIColor clearColor];
        return footView;
    }
    return nil;
}

//点击TableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    oneSection = indexPath.section;
    twoIndex = indexPath.row;
    [self.view endEditing:YES];
    
    [_datePicker removeFromSuperview];
    _datePicker = nil;
    
    [onePickerView removeFromSuperview];
    onePickerView = nil;
    
    [subPickView removeFromSuperview];
    subPickView = nil;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5) {
            if (indexPath.row == 2) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *mindateStr =  @"1900-01-01 00:00:00";
                NSDate *mindate = [formatter dateFromString:mindateStr];
                
                _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, Screen_Height-180-64, Screen_width, 180)];
                _datePicker.backgroundColor = [UIColor whiteColor];
                _datePicker.datePickerMode = UIDatePickerModeDate;
                
                _datePicker.minimumDate = mindate;
                _datePicker.maximumDate = [NSDate date];
                
                [_datePicker addTarget:self action:@selector(datePickerChangeValue:) forControlEvents:UIControlEventValueChanged];
                [self.view addSubview:_datePicker];
            }else if (indexPath.row == 5) {
                subPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Screen_Height-180-64, Screen_width, 180)];
                subPickView.delegate = self;
                subPickView.dataSource = self;
                subPickView.tag = 4402;
                subPickView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:244/255.0 alpha:1];
                [self.view addSubview:subPickView];
            }else {
                onePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Screen_Height-180-64, Screen_width, 180)];
                onePickerView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:244/255.0 alpha:1];
                onePickerView.delegate = self;
                onePickerView.dataSource = self;
                subPickView.tag = 4401;
                [self.view addSubview:onePickerView];
            }
        }else {
            [self performSegueWithIdentifier:@"CompletedViewToCourseInputView" sender:nil];
        }
    }else {
        [self performSegueWithIdentifier:@"CompletedViewToCourseInputView" sender:nil];
    }
}

#pragma mark - PickerView协议方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView.tag == 4402) {
        return 3;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 4402) {
        if (component == 0) {
            return self.shengDataArr.count;
        }else if (component == 1) {
            return [self.shiDataArr[oneSelect] count];
        }
        return [self.xianDataArr[oneSelect][twoSelect] count];
    }
    return [pickerArray count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 4402) {
        if (component == 0) {
            NSDictionary *dict = self.shengDataArr[row];
            return dict[@"region_name"];
        }else if (component == 1) {
            NSDictionary *dict = self.shiDataArr[oneSelect][row];
            return dict[@"region_name"];
        }
        NSDictionary *subDict = self.xianDataArr[oneSelect][twoSelect][row];
        return subDict[@"region_name"];
    }
    return [pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 4402) {
        if (component == 0) {
            oneSelect = row;
            twoSelect = 0;
            [subPickView reloadComponent:1];
            [subPickView reloadComponent:2];
            [subPickView selectRow:0 inComponent:1 animated:YES];
            [subPickView selectRow:0 inComponent:2 animated:YES];
        }else if (component == 1) {
            twoSelect = row;
            thrSelect = 0;
            [subPickView reloadComponent:2];
            [subPickView selectRow:0 inComponent:2 animated:YES];
        }else {
            thrSelect = row;
        }
        
        NSDictionary *oneDict = self.shengDataArr[oneSelect];
        NSDictionary *twoDict = self.shiDataArr[oneSelect][twoSelect];
        NSDictionary *thrDict = self.xianDataArr[oneSelect][twoSelect][thrSelect];
        NSString *addStr = [NSString stringWithFormat:@"%@ %@ %@",oneDict[@"region_name"],twoDict[@"region_name"],thrDict[@"region_name"]];
        [postDict setObject:addStr forKey:@"stuCity"];
    }else {
        [postDict setObject:pickerArray[row] forKey:@"stuSex"];
    }
    
    [courseComTableView reloadData];
}

#pragma mark - 时间选择按键响应事件
- (void)datePickerChangeValue:(UIDatePicker *)picker {
    NSString *dateStr = [NSString stringWithFormat:@"%@",picker.date];
    NSArray *timeArr = [dateStr componentsSeparatedByString:@" "];
    [postDict setObject:timeArr.firstObject forKey:@"stuBirth"];
    [courseComTableView reloadData];
}


#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CompletedViewToCourseInputView"]) {
        CoursesInputViewController *courVC = segue.destinationViewController;
        
        
        
        courVC.touchuIndex = [NSString stringWithFormat:@"%ld",(long)twoIndex];
        courVC.touchuSection = [NSString stringWithFormat:@"%ld",(long)oneSection];
        if (oneSection == 0) {
            courVC.inputLeftStr = oneArr[twoIndex];
        }else {
            courVC.inputLeftStr = twoArr[twoIndex];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
