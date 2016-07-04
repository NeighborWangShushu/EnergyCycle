//
//  ShipAddressViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ShipAddressViewController.h"

#import "AddressTableViewCell.h"
#import "AddressTwoTableViewCell.h"

@interface ShipAddressViewController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate> {
    UIButton *rightButton;
    
    NSMutableDictionary *addressDict;
    BOOL isChange;
    
    UIView *backView;
}

@end

@implementation ShipAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    self.title = @"送货地址";
    
    //
    shipAddressTableView.showsHorizontalScrollIndicator = NO;
    shipAddressTableView.showsVerticalScrollIndicator = NO;
    shipAddressTableView.backgroundColor = [UIColor clearColor];
    shipAddressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 10)];
    headView.backgroundColor = [UIColor clearColor];
    shipAddressTableView.tableHeaderView = headView;
    
    //
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 75)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *footButton = [UIButton buttonWithType:UIButtonTypeSystem];
    footButton.frame = CGRectMake(12, 20, Screen_width-24, 50);
    footButton.layer.masksToBounds = YES;
    footButton.layer.cornerRadius = 3.f;
    footButton.backgroundColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
    [footButton setTitle:@"确定" forState:UIControlStateNormal];
    [footButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [footButton addTarget:self action:@selector(footButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:footButton];
    shipAddressTableView.tableFooterView = footView;
    
    //
    addressDict = [[NSMutableDictionary alloc] init];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"AddressDict"];
    if (dict.count) {
        for (NSString *str in dict.allKeys) {
            [addressDict setObject:[dict objectForKey:str] forKey:str];
        }
    }
    
    //
    if (addressDict.count > 0) {
        rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.frame = CGRectMake(0, 0, 35, 30);
        [rightButton setTitle:@"修改" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark -
- (void)rightAction {
    if (!isChange) {
        isChange = YES;
    }
    
    [shipAddressTableView reloadData];
}

#pragma mark - 底部按键响应事件
- (void)footButtonClick {
    if ([addressDict[@"name"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入收货人"];
    }else if ([addressDict[@"phone"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入联系电话"];
    }else if (![[AppHelpManager sharedInstance] isPhoneNum:addressDict[@"phone"]]) {
        [SVProgressHUD showImage:nil status:@"请输入合法手机号"];
    }else if ([addressDict[@"address"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入收货地址"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:addressDict forKey:@"AddressDict"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:@"提交中.."];
        
        if ([self.drawType isEqualToString:@"0"]) {//兑换
            [[AppHttpManager shareInstance] getdoExchangeWithUserid:[User_ID intValue] merchantId:[self.shangPinID intValue] name:addressDict[@"name"] Phoneno:addressDict[@"phone"] Address:addressDict[@"address"] PostOrGet:@"get" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] ==1) {
                    [self creatSuccessViewWithType:0];
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
        }else {//抽奖
            [[AppHttpManager shareInstance] getdoChouJiangRecordWithUserid:[User_ID intValue] merchantId:[self.shangPinID intValue] name:addressDict[@"name"] Phoneno:addressDict[@"phone"] Address:addressDict[@"address"] PostOrGet:@"get" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] ==1) {
                    [self creatSuccessViewWithType:1];
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

#pragma mark - 创建提示界面
- (void)creatSuccessViewWithType:(NSInteger)type {
    [SVProgressHUD dismiss];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(20, Screen_Height/2-90, Screen_width-40, 180)];
    subView.backgroundColor = [UIColor whiteColor];
    subView.layer.masksToBounds = YES;
    subView.layer.cornerRadius = 4.f;
    [backView addSubview:subView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, Screen_width-40, 25)];
    label.text = @"兑换成功！";
    if (type == 1) {
        label.text = @"操作成功！";
    }
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:19];
    label.textAlignment = NSTextAlignmentCenter;
    [subView addSubview:label];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 77, Screen_width-44, 16)];
    subLabel.text = @"您可前往兑换纪录查看订单";
    subLabel.textColor = [UIColor blackColor];
    subLabel.font = [UIFont systemFontOfSize:13];
    subLabel.textAlignment = NSTextAlignmentCenter;
    [subView addSubview:subLabel];
    
    UIView *llineView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, Screen_width-40, 1)];
    llineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [subView addSubview:llineView];
    
    NSArray *titleArr = @[@"返回首页",@"兑换记录"];
    for (NSInteger i=0; i<titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((Screen_width/2-20)*i, 136, Screen_width/2-20, 44);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:0.5] forState:UIControlStateNormal];
        if (i == 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(Screen_width/2-21, 136, 1, 44)];
            lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
            [subView addSubview:lineView];
            
            [button setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        }
        button.tag = 4501 + i;
        
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(subButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [subView addSubview:button];
    }

    
}

- (void)subButtonClick:(UIButton *)button {
    [backView removeFromSuperview];
    backView = nil;
    
    if (button.tag == 4501) {//返回首页
        [self.navigationController popToRootViewControllerAnimated:NO];
//        EnetgyCycle.energyTabBar.selectedIndex = 0;
    }else {//兑换记录
        [self performSegueWithIdentifier:@"AddAddressViewToRecordView" sender:nil];
    }
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        CGFloat hight = [self textHeightFromTextString:addressDict[@"address"] width:Screen_width-100 fontSize:15];
        return 35.f + (hight<20?(hight+10):hight);
    }
    return 55.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        static NSString *AddressTwoTableViewCellId = @"AddressTwoTableViewCellId";
        AddressTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddressTwoTableViewCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.inputTextView.placehoder = @"请输入收货人地址";
        cell.inputTextView.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        cell.inputTextView.delegate = self;
        cell.inputTextView.text = addressDict[@"address"];
        
        if ((!isChange && [addressDict[@"address"] length] <= 0) || isChange) {
            cell.inputTextView.userInteractionEnabled = YES;
        }else {
            cell.inputTextView.userInteractionEnabled = NO;
        }
        
        return cell;
    }
    
    static NSString *AddressTableViewCellID = @"AddressTableViewCellID";
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddressTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.rightButton.hidden = NO;
    cell.inputTextView.tag = 4401 + indexPath.row;
    cell.inputTextView.delegate = self;
    [cell.inputTextView addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    if (indexPath.row == 0) {
        cell.leftLabel.text = @"收货人";
        cell.inputTextView.placeholder = @"请输入收货人姓名";
        cell.inputTextView.text = addressDict[@"name"];
        
        if ((!isChange && [addressDict[@"name"] length] <= 0) || isChange) {
            cell.inputTextView.userInteractionEnabled = YES;
            cell.rightButton.hidden = NO;
        }else {
            cell.inputTextView.userInteractionEnabled = NO;
            cell.rightButton.hidden = YES;
        }
    }else {
        cell.leftLabel.text = @"联系电话";
        cell.inputTextView.placeholder = @"请输入联系人电话";
        cell.rightButton.hidden = YES;
        cell.inputTextView.text = addressDict[@"phone"];
        cell.inputTextView.keyboardType = UIKeyboardTypeNumberPad;
        
        if ((!isChange && [addressDict[@"phone"] length] <= 0) || isChange) {
            cell.inputTextView.userInteractionEnabled = YES;
        }else {
            cell.inputTextView.userInteractionEnabled = NO;
        }
    }
    
    return cell;
}

- (void)textFieldValueChange:(UITextField *)textField {
    if (textField.tag == 4401) {
        [addressDict setObject:textField.text forKey:@"name"];
    }else {
        [addressDict setObject:textField.text forKey:@"phone"];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    [addressDict setObject:textView.text forKey:@"address"];
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddAddressViewToRecordView"]) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
