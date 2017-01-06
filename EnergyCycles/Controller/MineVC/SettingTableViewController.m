//
//  SettingTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SettingTableViewController.h"
#import "MyProfileViewController.h"

#import "SettingOneViewCell.h"
#import "SettingTwoViewCell.h"
#import "SettingThreeViewCell.h"
#import "SettingFourViewCell.h"
#import "SettingRadioCell.h"
#import "SettingPlayRadioCell.h"
#import "RadioDurationTimeVC.h"
#import "RadioPlaySettingVC.h"
#import "CacheManager.h"
#import "RadioClockModel.h"

@interface SettingTableViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    BOOL isPhoneLogin;
}
@property (nonatomic,strong)RadioClockModel*radioModel;
@end

@implementation SettingTableViewController

// 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

// 每一组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 2;
    }else if (section == 3){
        return 3;
    }else {
        return 1;
    }
}

//// 每一组的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 14.f;
//}

// 每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isPhoneLogin) {
        if (indexPath.section == 0) {
            return 0;
        }
    }
    return 50.f;
}

// 每一组的底部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 44.f;
    }
    return 14.f;
}

//// 设置分区头的View
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
//    return view;
//}

// 设置分区尾的View
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    if (section == 1) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(31, 2, Screen_width - 50, 30);
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize:12];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.6];
        label.text = @"要开启或关闭能量圈的推送通知,请在iPhone的“设置”-“通知”中找到“能量圈”进行设置";
        [view addSubview:label];
    }
    return view;
}

// 每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) { // 能量源
            static NSString *oneViewCell = @"oneViewCell";
            SettingOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:oneViewCell];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"SettingOneViewCell" owner:self options:nil].lastObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateDataWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPowerSource"]]]; // 获取能量源
            
            return cell;
        }
    } else if (indexPath.section == 1) { // 推送通知
        static NSString *fourViewCell = @"fourViewCell";
        SettingFourViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fourViewCell];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SettingFourViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateDataWithJudge:[self isAllowedNotification]]; // 获取推送通知开关状态
        return cell;
    }else if (indexPath.section == 2){ //定时电台
        if (indexPath.row == 0) {
            static NSString *fourViewCell = @"radioViewCell";
            SettingRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:fourViewCell];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"SettingRadioCell" owner:self options:nil].lastObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTimeValue:[self.radioModel durationTime]];
            return cell;
        }else {
            static NSString *fourViewCell = @"radioPlayViewCell";
            SettingPlayRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:fourViewCell];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"SettingPlayRadioCell" owner:self options:nil].lastObject;
            }
            [cell setWeekdayValue:[self.radioModel notificationWeekydays]];
            [cell setTimeAndChannel:[NSString stringWithFormat:@"%@  %@",[self.radioModel specificTime], [self.radioModel channelName]]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    else if (indexPath.section == 3) { // 清楚缓存
        if (indexPath.row == 0) {
            static NSString *threeViewCell = @"threeViewCell";
            SettingThreeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:threeViewCell];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"SettingThreeViewCell" owner:self options:nil].lastObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateDataWithData:[CacheManager getCachesSizeCount]]; // 获取缓存大小
            NSLog(@"%f",[CacheManager getCachesSizeCount]);
            
            return cell;
        }
    }
    
    static NSString *twoViewCell = @"twoViewCell";
    SettingTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoViewCell];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SettingTwoViewCell" owner:self options:nil].lastObject;
    }
    if (!isPhoneLogin && indexPath.section == 0) {
        [cell isOtherLogin];
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateDataWithSection:indexPath.section index:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        if (indexPath.row == 0) { // 个人资料
//            [self performSegueWithIdentifier:@"MyProfileViewController" sender:nil];
//        }
        if (indexPath.row == 0) { // 账号管理
            NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"];
            if ([phoneNumber isEqualToString:@""] || phoneNumber == nil) {
                [self performSegueWithIdentifier:@"AMBoundPhoneViewController" sender:nil];
            } else {
                [self performSegueWithIdentifier:@"AMChangePhoneViewController" sender:nil];
            }
        }
    } else if (indexPath.section == 1) { // 消息推送
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=NOTIFICATIONS_ID&&path=%@",[[NSBundle mainBundle] bundleIdentifier]]]];
    }else if (indexPath.section == 2) {
        //电台
        if (indexPath.row == 0) {
            //定时停止电台
            RadioDurationTimeVC *vc = [[RadioDurationTimeVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            //定时播放电台
            RadioPlaySettingVC * vc = [[RadioPlaySettingVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) { // 清除缓存
            [self clearDisk];
        } else if (indexPath.row == 1) { // 意见反馈
            [self performSegueWithIdentifier:@"IWillAdviseViewController" sender:nil];
        } else if (indexPath.row == 2) { // 关于
            [self performSegueWithIdentifier:@"AboutViewController" sender:nil];
        }
    }
//    } else { // 确认退出
//        [self exit];
//    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MyProfileViewController"]) {
        MyProfileViewController *myVC = segue.destinationViewController;
        myVC.model = self.model;
    }
}

// 获取应用通知开关状态
- (BOOL)isAllowedNotification
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) { // system is iOS8 +
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else { // iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    return NO;
}

// 退出登录
- (void)exit {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"USERID"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"TOKEN"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"PHONE"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"PASSWORD"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"UserPowerSource"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isUnLoginSetAPService" object:nil];
        EnetgyCycle.energyTabBar.selectedIndex = 0;
        [self.tableView reloadData];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:exitAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 清理缓存
- (void)clearDisk {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认清除缓存" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [CacheManager cleadDisk];
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:exitAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *string = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginType"]];
    
    if ([string isEqualToString:@"0"]) {
        isPhoneLogin = YES;
    } else {
        isPhoneLogin = NO;
    }
}


#pragma mark GET

- (RadioClockModel*)radioModel {
    if (!_radioModel) {
        NSArray * arr = [RadioClockModel findAll];
        if (arr.count) {
            _radioModel = [arr firstObject];
        }else {
            _radioModel = [[RadioClockModel alloc] init];
            [_radioModel saveOrUpdate];
        }
    }else {
        _radioModel = [RadioClockModel findByPK:_radioModel.pk];
    }
    return _radioModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftNavBarWithimage:@"loginfanhui"];

    self.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView = [UITableView alloc]
    
//    self.tableView.style = UITableViewStyleGrouped;
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}


- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}
    
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
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
