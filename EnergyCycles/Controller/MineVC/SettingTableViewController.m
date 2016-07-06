//
//  SettingTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SettingTableViewController.h"

#import "SettingOneViewCell.h"
#import "SettingTwoViewCell.h"
#import "SettingThreeViewCell.h"
#import "SettingFourViewCell.h"

#import "CacheManager.h"

@interface SettingTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SettingTableViewController

// 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

// 每一组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 3;
    } else {
        return 1;
    }
}

// 每一组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

// 每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

// 每一组的底部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 15.f;
    }
    return 0;
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
        NSLog(@"%@",[[UIApplication sharedApplication] isRegisteredForRemoteNotifications]?@"yes":@"no");
        [cell updateDataWithJudge:[[UIApplication sharedApplication] isRegisteredForRemoteNotifications]]; // 获取推送通知开关状态
        
        return cell;
    } else if (indexPath.section == 2) { // 清楚缓存
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
    } else if (indexPath.section == 3) { // 退出当前账号
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"退出当前账号";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        
        return cell;
    }
    
    static NSString *twoViewCell = @"twoViewCell";
    SettingTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoViewCell];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SettingTwoViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateDataWithSection:indexPath.section index:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"AMChangePhoneViewController" sender:nil];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [CacheManager cleadDisk];
            NSLog(@"clear");
            [self.tableView reloadData];
        }
    } else if (indexPath.section == 1) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] == NO) {
                UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            } else {
                [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            }
            NSLog(@"Notification");
            [self.tableView reloadData];
        } else {
            if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == 0) {
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            } else {
                [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            }
            
        }
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
