//
//  TheOldStuCerViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TheOldStuCerViewController.h"

#import "ChangeProfileViewController.h"
#import "CourseChooseTableViewCell.h"

#import "CityDataManager.h"

@interface TheOldStuCerViewController () <UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    NSArray *oneArr;
    NSArray *twoArr;
    NSInteger oneSection;
    NSInteger twoIndex;
    
    UIPickerView *onePickerView;
    NSArray *pickerArray;
    NSMutableArray *addressArr;
    UIDatePicker *_datePicker;
    
    NSMutableDictionary *postDict;
    
    UIPickerView *subPickView;
    NSInteger oneSelect;
    NSInteger twoSelect;
    NSInteger thrSelect;
}

@property (nonatomic, strong) NSArray *shengDataArr;
@property (nonatomic, strong) NSMutableArray *shiDataArr;
@property (nonatomic, strong) NSMutableArray *xianDataArr;


@end

@implementation TheOldStuCerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    self.title = @"申请老学员认证";
    oneArr = @[@"学员姓名",@"性别",@"生日",@"电话",@"邮箱",@"城市",@"地址",@"学校/年级/班级"];
    twoArr = @[@"父亲姓名",@"父亲电话",@"母亲姓名",@"母亲电话"];
    pickerArray = @[@"男",@"女"];
    postDict = [[NSMutableDictionary alloc] init];
    addressArr = [[NSMutableArray alloc] init];
    //
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    oldStuTableView.showsHorizontalScrollIndicator = NO;
    oldStuTableView.showsVerticalScrollIndicator = NO;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oldChangeProfileDict:) name:@"isOldChangeProfileDict" object:nil];
    
    [postDict setObject:@"请输入" forKey:@"oldName"];
    [postDict setObject:@"选择性别" forKey:@"oldSex"];
    [postDict setObject:@"请选择生日" forKey:@"oldBirth"];
    [postDict setObject:@"输入电话" forKey:@"oldPhone"];
    [postDict setObject:@"请输入邮箱" forKey:@"oldEmail"];
    [postDict setObject:@"请选择城市" forKey:@"oldCity"];
    [postDict setObject:@"添加地址" forKey:@"OldAddress"];
    [postDict setObject:@"添加学校/年级/班级" forKey:@"OldGrade"];
    [postDict setObject:@"父亲姓名" forKey:@"OldFatherName"];
    [postDict setObject:@"父亲电话" forKey:@"OldFatherPhone"];
    [postDict setObject:@"母亲姓名" forKey:@"OldMotherName"];
    [postDict setObject:@"母亲电话" forKey:@"OldMotherPhone"];
    [postDict setObject:@"最近参加的期数" forKey:@"OldCount"];
    [postDict setObject:User_PHONE forKey:@"phoneno"];
    
    [self getCityData];
    
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark -
- (void)oldChangeProfileDict:(NSNotification *)notification {
    NSDictionary *getDict = [notification object];
    if ([getDict[@"section"] isEqualToString:@"0"]) {
        if ([getDict[@"index"] isEqualToString:@"0"]) {
            [postDict setObject:getDict[@"text"] forKey:@"oldName"];
        }else if ([getDict[@"index"] isEqualToString:@"3"]) {
            [postDict setObject:getDict[@"text"] forKey:@"oldPhone"];
        }else if ([getDict[@"index"] isEqualToString:@"4"]) {
            [postDict setObject:getDict[@"text"] forKey:@"oldEmail"];
        }else if ([getDict[@"index"] isEqualToString:@"6"]) {
            [postDict setObject:getDict[@"text"] forKey:@"OldAddress"];
        }else if ([getDict[@"index"] isEqualToString:@"7"]) {
            [postDict setObject:getDict[@"text"] forKey:@"OldGrade"];
        }
    }else if ([getDict[@"section"] isEqualToString:@"1"]) {
        if ([getDict[@"index"] isEqualToString:@"0"]) {
            [postDict setObject:getDict[@"text"] forKey:@"OldFatherName"];
        }else if ([getDict[@"index"] isEqualToString:@"1"]) {
            [postDict setObject:getDict[@"text"] forKey:@"OldFatherPhone"];
        }else if ([getDict[@"index"] isEqualToString:@"2"]) {
            [postDict setObject:getDict[@"text"] forKey:@"OldMotherName"];
        }else if ([getDict[@"index"] isEqualToString:@"3"]) {
            [postDict setObject:getDict[@"text"] forKey:@"OldMotherPhone"];
        }
    }else {
        if ([getDict[@"index"] isEqualToString:@"0"]) {
            [postDict setObject:getDict[@"text"] forKey:@"OldCount"];
        }
    }
    
    [oldStuTableView reloadData];
}

#pragma mark - 提交按键
- (void)rightAction {
    [_datePicker removeFromSuperview];
    _datePicker = nil;
    
    [onePickerView removeFromSuperview];
    onePickerView = nil;
    
    [subPickView removeFromSuperview];
    subPickView = nil;
    
    [self.view endEditing:YES];
        
    if ([postDict[@"oldName"] isEqualToString:@"请输入"]) {
        [SVProgressHUD showImage:nil status:@"请输入姓名"];
    }else if ([postDict[@"oldSex"] isEqualToString:@"选择性别"]) {
        [SVProgressHUD showImage:nil status:@"选择性别"];
    }else if ([postDict[@"oldBirth"] isEqualToString:@"请选择生日"]) {
        [SVProgressHUD showImage:nil status:@"请选择生日"];
    }else if ([postDict[@"oldCity"] isEqualToString:@"请选择城市"]) {
        [SVProgressHUD showImage:nil status:@"请选择城市"];
    }else if ([postDict[@"OldAddress"] isEqualToString:@"添加地址"]) {
        [SVProgressHUD showImage:nil status:@"请添加地址"];
    }else if ([postDict[@"OldGrade"] isEqualToString:@"添加学校/年级/班级"]) {
        [SVProgressHUD showImage:nil status:@"请添加学校/年级/班级"];
    }else if ([postDict[@"OldFatherName"] isEqualToString:@"父亲姓名"]) {
        [SVProgressHUD showImage:nil status:@"请输入父亲姓名"];
    }else if ([postDict[@"OldFatherPhone"] isEqualToString:@"父亲电话"]) {
        [SVProgressHUD showImage:nil status:@"请输入父亲电话"];
    }else if ([postDict[@"OldMotherName"] isEqualToString:@"母亲姓名"]) {
        [SVProgressHUD showImage:nil status:@"请输入母亲姓名"];
    }else if ([postDict[@"OldMotherPhone"] isEqualToString:@"母亲电话"]) {
        [SVProgressHUD showImage:nil status:@"请输入母亲电话"];
    }else if ([postDict[@"OldCount"] isEqualToString:@"最近参加的期数"]) {
        [SVProgressHUD showImage:nil status:@"请输入最近参加的期数"];
    }else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:@"提交中.."];
        
        if ([postDict[@"oldPhone"] isEqualToString:@"输入电话"]) {
            [postDict setObject:@"" forKey:@"oldPhone"];
        }
        if ([postDict[@"oldEmail"] isEqualToString:@"请输入邮箱"]) {
            [postDict setObject:@"" forKey:@"oldEmail"];
        }
        
        [[AppHttpManager shareInstance] getOldPeopleVerifyWithOldName:postDict[@"oldName"]
                                                               OldSex:postDict[@"oldSex"]
                                                             OldBirth:postDict[@"oldBirth"]
                                                             OldPhone:postDict[@"oldPhone"]
                                                             OldEmail:postDict[@"oldEmail"]
                                                              OldCity:postDict[@"oldCity"]
                                                           OldAddress:postDict[@"OldAddress"]
                                                             OldGrade:postDict[@"OldGrade"]
                                                        OldFatherName:postDict[@"OldFatherName"]
                                                       OldFatherPhone:postDict[@"OldFatherPhone"]
                                                        OldMotherName:postDict[@"OldMotherName"]
                                                       OldMotherPhone:postDict[@"OldMotherPhone"]
                                                             OldCount:[postDict[@"OldCount"] intValue]
                                                              phoneno:postDict[@"phoneno"]
                                                               userId:[User_ID intValue]
                                                                Token:User_TOKEN
                                                            PostOrGet:@"get" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                     [SVProgressHUD showImage:nil status:@"信息已提交，请等待审核"];
                     [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - 获取城市接口
- (void)getCityData {
    [addressArr addObject:@"上海"];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    }else if (section == 1) {
        return 4;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.f;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CourseChooseTableViewCellId = @"CourseChooseTableViewCellId";
    CourseChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CourseChooseTableViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CourseChooseTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.rightLabel.text = @"";
    cell.tag = 4401+indexPath.row;
    
    cell.leftTwoLabel.text = @"";
    if (indexPath.section == 0) {
        cell.leftOneLabel.text = oneArr[indexPath.row];
        if (indexPath.row == 3 || indexPath.row == 4) {
            cell.leftTwoLabel.text = @"(选填)";
        }
        
        if (indexPath.row == 0) {
            cell.rightLabel.text = [postDict objectForKey:@"oldName"];
        }else if (indexPath.row == 1) {
            cell.rightLabel.text = [postDict objectForKey:@"oldSex"];
        }else if (indexPath.row == 2) {
            cell.rightLabel.text = [postDict objectForKey:@"oldBirth"];
        }else if (indexPath.row == 3) {
            cell.rightLabel.text = [postDict objectForKey:@"oldPhone"];
        }else if (indexPath.row == 4) {
            cell.rightLabel.text = [postDict objectForKey:@"oldEmail"];
        }else if (indexPath.row == 5) {
            cell.rightLabel.text = [postDict objectForKey:@"oldCity"];
        }else if (indexPath.row == 6) {
            cell.rightLabel.text = [postDict objectForKey:@"OldAddress"];
        }else if (indexPath.row == 7) {
            cell.rightLabel.text = [postDict objectForKey:@"OldGrade"];
        }
    }else if (indexPath.section == 1) {
        cell.leftOneLabel.text = twoArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.rightLabel.text = [postDict objectForKey:@"OldFatherName"];
        }else if (indexPath.row == 1) {
            cell.rightLabel.text = [postDict objectForKey:@"OldFatherPhone"];
        }else if (indexPath.row == 2) {
            cell.rightLabel.text = [postDict objectForKey:@"OldMotherName"];
        }else {
            cell.rightLabel.text = [postDict objectForKey:@"OldMotherPhone"];
        }
    }else {
        cell.rightLabel.text = [postDict objectForKey:@"OldCount"];
        cell.leftOneLabel.text = @"最近参加的期数";
    }
    
    return cell;
}

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
        if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 7) {
            [self performSegueWithIdentifier:@"OldStuViewToPrefileView" sender:nil];
        }else {
            if (indexPath.row == 1) {
                onePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Screen_Height-180-64, Screen_width, 180)];
                onePickerView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
                onePickerView.delegate = self;
                onePickerView.dataSource = self;
                onePickerView.tag = 4401;
                [self.view addSubview:onePickerView];
            }else if (indexPath.row == 5) {
                subPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Screen_Height-180-64, Screen_width, 180)];
                subPickView.delegate = self;
                subPickView.dataSource = self;
                subPickView.tag = 4402;
                subPickView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
                [self.view addSubview:subPickView];
            }else if (indexPath.row == 2) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *mindateStr =  @"1900-01-01 00:00:00";
                NSDate *mindate = [formatter dateFromString:mindateStr];
                
                _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, Screen_Height-180-64, Screen_width, 180)];
                _datePicker.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
                _datePicker.datePickerMode = UIDatePickerModeDate;
                
                _datePicker.minimumDate = mindate;
                _datePicker.maximumDate = [NSDate date];
                
                [_datePicker addTarget:self action:@selector(datePickerChangeValue:) forControlEvents:UIControlEventValueChanged];
                [self.view addSubview:_datePicker];
            }
        }
    }else {
        [self performSegueWithIdentifier:@"OldStuViewToPrefileView" sender:nil];
    }
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 10.f;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
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
        if (thrDict.count) {
            NSString *addStr = [NSString stringWithFormat:@"%@ %@ %@",oneDict[@"region_name"],twoDict[@"region_name"],thrDict[@"region_name"]];
            [postDict setObject:addStr forKey:@"oldCity"];
        }
    }else {
        [postDict setObject:pickerArray[row] forKey:@"oldSex"];
    }
    
    [oldStuTableView reloadData];
}

#pragma mark - 时间选择按键响应事件
- (void)datePickerChangeValue:(UIDatePicker *)picker {
    NSString *dateStr = [NSString stringWithFormat:@"%@",picker.date];
    NSArray *timeArr = [dateStr componentsSeparatedByString:@" "];
    [postDict setObject:timeArr.firstObject forKey:@"oldBirth"];
    [oldStuTableView reloadData];
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OldStuViewToPrefileView"]) {
        ChangeProfileViewController *changeVC = segue.destinationViewController;
        
        changeVC.changeProType = @"OldStu";
        changeVC.touchIndex = [NSString stringWithFormat:@"%ld",(long)twoIndex];
        changeVC.touchSection = [NSString stringWithFormat:@"%ld",(long)oneSection];
        if (oneSection == 0) {
            changeVC.showStr = oneArr[twoIndex];
        }else if (oneSection == 1) {
            changeVC.showStr = twoArr[twoIndex];
        }else {
            changeVC.showStr = @"最近参加的期数";
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
