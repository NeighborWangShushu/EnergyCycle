//
//  MyProfileViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyProfileViewController.h"

#import "MyProfileViewCell.h"
#import "ChangeProfileViewController.h"
#import "VerificationPhoneViewController.h"
#import "UserModel.h"

#import "CityDataManager.h"
#import "IntroViewController.h"

@interface MyProfileViewController () <UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    NSArray *titleArr;
    NSArray *keyArr;
    NSInteger touchuIndex;
    UIPickerView *onePickerView;
    NSArray *pickerArray;
    UIDatePicker *_datePicker;
    
    NSMutableDictionary *postDict;
    
    UIPickerView *subPickView;
    NSInteger oneSelect;
    NSInteger twoSelect;
    NSInteger thrSelect;
    
    BOOL judgeSex;
    BOOL judgeDate;
    BOOL judgeAddress;
}

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UILabel *chooseLabel;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSArray *shengDataArr;
@property (nonatomic, strong) NSMutableArray *shiDataArr;
@property (nonatomic, strong) NSMutableArray *xianDataArr;


@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftNavBarWithimage:@"loginfanhui"];

//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    self.title = @"我的资料";
    titleArr = @[@"昵称",@"姓名",@"性别",@"生日",@"电话",@"邮箱",@"城市",@"简介"];
    pickerArray = @[@"男",@"女"];
    touchuIndex = 0;
    postDict = [[NSMutableDictionary alloc] init];
    
    mineProfileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mineProfileTableView.showsVerticalScrollIndicator = NO;
    mineProfileTableView.showsHorizontalScrollIndicator = NO;
    
    //
//    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProfileDict:) name:@"isChangeProfileDict" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneNumberChange:) name:@"PhoneNumberChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(introUpdate:) name:@"MyProfileIntroUpdate" object:nil];
    oneSelect = 0;
    twoSelect = 0;
    thrSelect = 0;
    self.shiDataArr = [[NSMutableArray alloc] init];
    self.xianDataArr = [[NSMutableArray alloc] init];
    
    judgeSex = NO;
    judgeDate = NO;
    judgeAddress = NO;
    
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
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

    [postDict setObject:@"请输入昵称" forKey:@"nickname"];
    [postDict setObject:@"请输入姓名" forKey:@"username"];
    [postDict setObject:@"请选择性别" forKey:@"sex"];
    [postDict setObject:@"请选择生日" forKey:@"birth"];
    [postDict setObject:@"未设置手机号" forKey:@"phoneno"];
    [postDict setObject:@"请输入邮箱" forKey:@"email"];
    [postDict setObject:@"请选择城市" forKey:@"city"];
    [postDict setObject:@"暂无简介" forKey:@"Brief"];
    keyArr = @[@"nickname", @"username", @"sex", @"birth", @"phoneno", @"email", @"city", @"Brief"];
    
    [self createButton];
}

#pragma mark - 键盘事件
- (void)keyboardWillShow:(NSNotification *)notif {
    [onePickerView removeFromSuperview];
    onePickerView = nil;
    
    [subPickView removeFromSuperview];
    subPickView = nil;
}


#pragma mark - 消息中心提交数据
- (void)changeProfileDict:(NSNotification *)notification {
    NSDictionary *getDict = [notification object];
    MyProfileViewCell *cell = (MyProfileViewCell *)[self.view viewWithTag:4201+[getDict[@"index"] integerValue]];
    cell.rightLabel.text = getDict[@"text"];
    
    if ([getDict[@"index"] isEqualToString:@"0"]) {
        [postDict setObject:getDict[@"text"] forKey:@"nickname"];
    }else if ([getDict[@"index"] isEqualToString:@"1"]) {
        [postDict setObject:getDict[@"text"] forKey:@"username"];
    }else if ([getDict[@"index"] isEqualToString:@"4"]) {
        [postDict setObject:getDict[@"text"] forKey:@"phoneno"];
    }else if ([getDict[@"index"] isEqualToString:@"5"]) {
        [postDict setObject:getDict[@"text"] forKey:@"email"];
    }else if ([getDict[@"index"] isEqualToString:@"6"]) {
        [postDict setObject:getDict[@"text"] forKey:@"city"];
    }
}

- (void)phoneNumberChange:(NSNotification *)notification {
    NSDictionary *dic = [notification object];
    MyProfileViewCell *cell = (MyProfileViewCell *)[self.view viewWithTag:4201+4];
    cell.rightLabel.text = dic[@"phoneNumber"];
    
    [postDict setObject:dic[@"phoneNumber"] forKey:@"phoneno"];
}

- (void)introUpdate:(NSNotification *)notification {
    NSDictionary *dic = [notification object];
    MyProfileViewCell *cell = (MyProfileViewCell *)[self.view viewWithTag:4201+7];
    cell.rightLabel.text = dic[@"Brief"];
    
    [postDict setObject:dic[@"Brief"] forKey:@"Brief"];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
//}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 修改个人资料按键
- (void)rightAction {
    [_datePicker removeFromSuperview];
    _datePicker = nil;
    
    [onePickerView removeFromSuperview];
    onePickerView = nil;
    
    [subPickView removeFromSuperview];
    subPickView = nil;
    
    [self.view endEditing:YES];
    
    if ([postDict[@"nickname"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入昵称"];
    }else if ([postDict[@"username"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入姓名"];
    }else if ([postDict[@"sex"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请选择性别"];
    }else if ([postDict[@"birth"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请选择生日"];
    }else if ([postDict[@"email"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入邮箱"];
    }else if ([postDict[@"city"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入城市"];
    }else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:@"更新中.."];
        NSLog(@"%@",[NSString stringWithFormat:@"%@", User_TOKEN]);
        
        [[AppHttpManager shareInstance] getFinishRegisterWithNickname:postDict[@"nickname"]
                                                             Username:postDict[@"username"]
                                                                  Sex:postDict[@"sex"]
                                                                Birth:postDict[@"birth"]
                                                              Phoneno:postDict[@"phoneno"]
                                                                Email:postDict[@"email"]
                                                                 City:postDict[@"city"]
                                                               userId:[User_ID intValue]
                                                                Token:User_TOKEN
                                                            PostOrGet:@"get"
                                                              success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
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
        
        [[AppHttpManager shareInstance] changeBriefWithUserid:[User_ID intValue] Token:User_TOKEN Brief:postDict[@"Brief"] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                NSLog(@"修改成功");
            } else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
        
        [[AppHttpManager shareInstance] updateAppUserTelUpdWithUserid:[User_ID intValue] Tel:postDict[@"phoneno"] PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                NSLog(@"手机修改成功");
            } else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
    }
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.f;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyProfileViewCellId = @"MyProfileViewCellId";
    MyProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyProfileViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyProfileViewCell" owner:self options:nil].lastObject;
    }
    cell.titleLabel.text = titleArr[indexPath.row];
    cell.tag = 4201 + indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if (indexPath.row == 0) {
//        cell.rightLabel.text = [self.inforDict[@"nickname"] length]<=0?postDict[@"nickname"]:self.inforDict[@"nickname"];
//        [postDict setObject:[self.inforDict[@"nickname"] length]<=0?@"":self.inforDict[@"nickname"] forKey:@"nickname"];
//    }else if (indexPath.row == 1) {
//        cell.rightLabel.text = [self.inforDict[@"username"] length]<=0?postDict[@"username"]:self.inforDict[@"username"];
//        [postDict setObject:[self.inforDict[@"username"] length]<=0?@"":self.inforDict[@"username"] forKey:@"username"];
//    }else if (indexPath.row == 2) {
//        cell.rightLabel.text = [self.inforDict[@"sex"] length]<=0?postDict[@"sex"]:self.inforDict[@"sex"];
//        [postDict setObject:[self.inforDict[@"sex"] length]<=0?@"":self.inforDict[@"sex"] forKey:@"sex"];
//    }else if (indexPath.row == 3) {
//        cell.rightLabel.text = [self.inforDict[@"birth"] length]<=0?postDict[@"birth"]:self.inforDict[@"birth"];
//        [postDict setObject:[self.inforDict[@"birth"] length]<=0?@"":self.inforDict[@"birth"] forKey:@"birth"];
//    }else if (indexPath.row == 4) {
//        cell.rightLabel.text = [self.inforDict[@"phone"] length]<=0?postDict[@"phoneno"]:self.inforDict[@"phone"];
//        [postDict setObject:[self.inforDict[@"phone"] length]<=0?@"":self.inforDict[@"phone"] forKey:@"phoneno"];
//    }else if (indexPath.row == 5) {
//        cell.rightLabel.text = [self.inforDict[@"email"] length]<=0?postDict[@"email"]:self.inforDict[@"email"];
//        [postDict setObject:[self.inforDict[@"email"] length]<=0?@"":self.inforDict[@"email"] forKey:@"email"];
//    }else if (indexPath.row == 6) {
//        cell.rightLabel.text = [self.inforDict[@"city"] length]<=0?postDict[@"city"]:self.inforDict[@"city"];
//        [postDict setObject:[self.inforDict[@"city"] length]<=0?@"":self.inforDict[@"city"] forKey:@"city"];
//    }
    if (indexPath.row == 0) {
        cell.rightLabel.text = [self.model.nickname length]<=0?postDict[@"nickname"]:self.model.nickname;
        [postDict setObject:[self.model.nickname length]<=0?@"":self.model.nickname forKey:@"nickname"];
    }else if (indexPath.row == 1) {
        cell.rightLabel.text = [self.model.username length]<=0?postDict[@"username"]:self.model.username;
        [postDict setObject:[self.model.username length]<=0?@"":self.model.username forKey:@"username"];
    }else if (indexPath.row == 2) {
        cell.rightLabel.text = [self.model.sex length]<=0?postDict[@"sex"]:self.model.sex;
        [postDict setObject:[self.model.sex length]<=0?@"":self.model.sex forKey:@"sex"];
    }else if (indexPath.row == 3) {
        cell.rightLabel.text = [self.model.birth length]<=0?postDict[@"birth"]:self.model.birth;
        [postDict setObject:[self.model.birth length]<=0?@"":self.model.birth forKey:@"birth"];
    }else if (indexPath.row == 4) {
        NSString *string = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginType"]];
        if ([string isEqualToString:@"0"]) {
            cell.userInteractionEnabled = NO;
            cell.constraint.constant = 17;
            cell.rightImage.hidden = YES;
            cell.rightLabel.text = [self.model.phone length]<=0?postDict[@"phoneno"]:self.model.phone;
            [postDict setObject:[self.model.phone length]<=0?@"":self.model.phone forKey:@"phoneno"];
        } else {
            cell.rightLabel.text = [self.model.Tel length]<=0?postDict[@"phoneno"]:self.model.phone;
            [postDict setObject:[self.model.Tel length]<=0?@"":self.model.Tel forKey:@"phoneno"];
        }
        
    }else if (indexPath.row == 5) {
        cell.rightLabel.text = [self.model.email length]<=0?postDict[@"email"]:self.model.email;
        [postDict setObject:[self.model.email length]<=0?@"":self.model.email forKey:@"email"];
    }else if (indexPath.row == 6) {
        cell.rightLabel.text = [self.model.city length]<=0?postDict[@"city"]:self.model.city;
        [postDict setObject:[self.model.city length]<=0?@"":self.model.city forKey:@"city"];
    }else if (indexPath.row == 7) {
        cell.rightLabel.text = [self.model.Brief length]<=0?postDict[@"Brief"]:self.model.Brief;
        [postDict setObject:[self.model.Brief length]<=0?@"":self.model.Brief forKey:@"Brief"];
    }
    
    return cell;
}

- (void)createButton {
    self.leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.leftButton.frame = CGRectMake(0, 0, Screen_width, Screen_Height);
    self.leftButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    [self.leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.hidden = YES;
    [self.view addSubview:self.leftButton];
    self.chooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Screen_Height - 180 -94, Screen_width, 30)];
    self.chooseLabel.font = [UIFont systemFontOfSize:18];
    self.chooseLabel.textAlignment = NSTextAlignmentCenter;
    self.chooseLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:231/255.0 alpha:1];
    self.chooseLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    self.chooseLabel.hidden = YES;
    [self.view addSubview:self.chooseLabel];
    self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightButton.frame = CGRectMake(Screen_width - 100, Screen_Height - 180 - 94, 100, 30);
    self.rightButton.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:231/255.0 alpha:1];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.rightButton setTitle:@"确定" forState:UIControlStateNormal];
    self.rightButton.hidden = YES;
    [self.view addSubview:self.rightButton];
    
}

- (void)addTargetWithNum:(int)num {
    if (num == 1) {
        [self.rightButton addTarget:self action:@selector(sureSex) forControlEvents:UIControlEventTouchUpInside];
        self.chooseLabel.text = @"你的性别";
    } else if (num == 2) {
        [self.rightButton addTarget:self action:@selector(sureDate) forControlEvents:UIControlEventTouchUpInside];
        self.chooseLabel.text = @"你的生日";
    } else if (num == 3) {
        [self.rightButton addTarget:self action:@selector(sureAddress) forControlEvents:UIControlEventTouchUpInside];
        self.chooseLabel.text = @"你的城市";
    }
}

- (void)sureSex {
    if (!judgeSex) {
        NSString *name = pickerArray[0];
        MyProfileViewCell *cell=  (MyProfileViewCell*) [self.view viewWithTag:4203];
        cell.rightLabel.text = name;
        [postDict setObject:name forKey:@"sex"];
        //        judgeSex = NO;
    }
    [self cancel];
}

- (void)sureDate {
    if (!judgeDate) {
        UIDatePicker *picker = [[UIDatePicker alloc] init];
        NSString *dateStr = [NSString stringWithFormat:@"%@",picker.date];
        NSArray *timeArr = [dateStr componentsSeparatedByString:@" "];
        
        MyProfileViewCell *cell=  (MyProfileViewCell*) [self.view viewWithTag:4204];
        cell.rightLabel.text = timeArr.firstObject;
        [postDict setObject:timeArr.firstObject forKey:@"birth"];
        //        judgeDate = NO;
    }
    [self cancel];
}

- (void)sureAddress {
    if (!judgeAddress) {
        NSDictionary *oneDict = self.shengDataArr[oneSelect];
        NSDictionary *twoDict = self.shiDataArr[oneSelect][twoSelect];
        NSDictionary *thrDict = self.xianDataArr[oneSelect][twoSelect][thrSelect];
        NSString *addStr = [NSString stringWithFormat:@"%@ %@ %@",oneDict[@"region_name"],twoDict[@"region_name"],thrDict[@"region_name"]];
        MyProfileViewCell *cell=  (MyProfileViewCell*) [self.view viewWithTag:4207];
        cell.rightLabel.text = addStr;
        [postDict setObject:addStr forKey:@"city"];
        //        judgeAddress = NO;
    }
    [self cancel];
}

- (void)cancel {
    [_datePicker removeFromSuperview];
    _datePicker = nil;
    
    [onePickerView removeFromSuperview];
    onePickerView = nil;
    
    [subPickView removeFromSuperview];
    subPickView = nil;
    
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.chooseLabel.hidden = YES;
}

- (void)show {
    self.leftButton.hidden = NO;
    self.rightButton.hidden = NO;
    self.chooseLabel.hidden = NO;
}

#pragma mark - 跳转界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    touchuIndex = indexPath.row;
    
    [self cancel];
    
    if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 6) {
        if (indexPath.row == 3) {
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
            [self show];
            [self addTargetWithNum:2];
            [self.view addSubview:_datePicker];
        }else if (indexPath.row == 6) {
            [self.view endEditing:YES];
            
            subPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Screen_Height-180-64, Screen_width, 180)];
            subPickView.delegate = self;
            subPickView.dataSource = self;
            subPickView.tag = 4402;
            subPickView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
            [self show];
            [self addTargetWithNum:3];
            [self.view addSubview:subPickView];
        }else {
            onePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Screen_Height-180-64, Screen_width, 180)];
            onePickerView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
            onePickerView.delegate = self;
            onePickerView.dataSource = self;
            onePickerView.tag = 4401;
            [self show];
            [self addTargetWithNum:1];
            [self.view addSubview:onePickerView];
        }
    } else if (indexPath.row == 7) {
        IntroViewController *introVC = MainStoryBoard(@"IntroViewController");
        introVC.introString = self.model.Brief;
        introVC.isMyProfile = YES;
        [self.navigationController pushViewController:introVC animated:YES];
    } else if (indexPath.row == 4) {
        VerificationPhoneViewController *verVC = MainStoryBoard(@"VerificationPhoneViewController");
        verVC.isOtherLogin = YES;
        [self.navigationController pushViewController:verVC animated:YES];
    } else {
        [self performSegueWithIdentifier:@"MyProfieViewToChangeProfireViuew" sender:nil];
    }
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
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
        judgeAddress = YES;
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
        MyProfileViewCell *cell=  (MyProfileViewCell*) [self.view viewWithTag:4207];
        cell.rightLabel.text = addStr;
        [postDict setObject:addStr forKey:@"city"];
    }else {
        judgeSex = YES;
        NSString *name = pickerArray[row];
        MyProfileViewCell *cell=  (MyProfileViewCell*) [self.view viewWithTag:4203];
        cell.rightLabel.text = name;
        [postDict setObject:name forKey:@"sex"];
    }
}

#pragma mark - 时间选择按键响应事件
- (void)datePickerChangeValue:(UIDatePicker *)picker {
    judgeDate = YES;
    NSString *dateStr = [NSString stringWithFormat:@"%@",picker.date];
    NSArray *timeArr = [dateStr componentsSeparatedByString:@" "];
    
    MyProfileViewCell *cell=  (MyProfileViewCell*) [self.view viewWithTag:4204];
    cell.rightLabel.text = timeArr.firstObject;
    [postDict setObject:timeArr.firstObject forKey:@"birth"];
}

#pragma mark - 传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MyProfieViewToChangeProfireViuew"]) {
        ChangeProfileViewController *changVC = segue.destinationViewController;
        changVC.changeProType = @"MyPro";
        changVC.showStr = titleArr[touchuIndex];
        changVC.touchIndex = [NSString stringWithFormat:@"%ld",(long)touchuIndex];
        changVC.touchSection = @"0";
        changVC.value = postDict[keyArr[touchuIndex]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
