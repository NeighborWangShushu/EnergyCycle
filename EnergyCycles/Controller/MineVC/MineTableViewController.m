//
//  MineTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineTableViewController.h"

#import "MineHomePageViewController.h"
#import "IntroViewController.h"
#import "MineHomePageHeadModel.h"
#import "MineHeadTableViewCell.h"
#import "MineTableViewCell.h"

#import "AttentionAndFansTableViewController.h"

@interface MineTableViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *userInfoDict;
@property (nonatomic, strong) MineHomePageHeadModel *model;

@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) NSData *headImageData;

@end

@implementation MineTableViewController

// 用户信息
- (NSMutableDictionary *)userInfoDict {
    if (!_userInfoDict) {
        self.userInfoDict = [[NSMutableDictionary alloc] init];
    }
    return _userInfoDict;
}

// 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

// 每一组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 6;
    } else {
        return 1;
    }
}

// 每一组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 14.f;
}

// 每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 113.f;
    }
    return 50.f;
}

// 每一组的底部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

// 设置分区头的View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    return view;
}

// 设置分区尾的View
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    return view;
}

// 每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *mineHeadTableViewCell = @"mineHeadTableViewCell";
        MineHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineHeadTableViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineHeadTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updataDataWithImage:self.userInfoDict[@"photourl"] name:self.userInfoDict[@"nickname"] sex:self.userInfoDict[@"sex"] signIn:0 address:self.userInfoDict[@"city"] intro:self.userInfoDict[@"Brief"]];
//        [cell updateDataWithModel:self.model signIn:0];

        return cell;
    } else {
        static NSString *mineTableViewCell = @"mineTableViewCell";
        MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineTableViewCell];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateDataWithSection:indexPath.section index:indexPath.row count:nil]; 
        return cell;
    }
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // 个人主页
        [self performSegueWithIdentifier:@"MineHomePageViewController" sender:nil];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) { // 能量圈
            
        } else if (indexPath.row == 1) { // 关注
            AttentionAndFansTableViewController *afVC = [[AttentionAndFansTableViewController alloc] init];
            afVC.type = 1;
            [self.navigationController pushViewController:afVC animated:YES];
        } else if (indexPath.row == 2) { // 粉丝
            AttentionAndFansTableViewController *afVC = [[AttentionAndFansTableViewController alloc] init];
            afVC.type = 2;
            [self.navigationController pushViewController:afVC animated:YES];
        } else if (indexPath.row == 3) { // 消息
            
        } else if (indexPath.row == 4) { // PK记录
            
        } else if (indexPath.row == 5) { // 推荐用户
            
        }
    } else if (indexPath.section == 2) { // 积分榜
        
    } else if (indexPath.section == 3) { // 设置
        [self performSegueWithIdentifier:@"SettingTableViewController" sender:nil];
    }
}

- (void)jumpToIntroViewController {
    [self performSegueWithIdentifier:@"IntroViewController" sender:nil];
}

// 传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MineHomePageViewController"]) {
        MineHomePageViewController *mineHomePageVC = segue.destinationViewController;
        mineHomePageVC.userInfoDic = self.userInfoDict;
    } else if([segue.identifier isEqualToString:@"IntroViewController"]){
        IntroViewController *introVC = segue.destinationViewController;
//        [introVC.introTextView setText:self.userInfoDict[@"Brief"]];
        introVC.introString = self.userInfoDict[@"Brief"];
    }
}

// 获取用户信息
- (void)getUserInfo {
    [[AppHttpManager shareInstance] getGetInfoByUseridWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            
            if ([dict[@"Data"] count]) {
                
//                for(NSDictionary *dic in dict[@"Data"][0]) {
//                    [self.model setValuesForKeysWithDictionary:dic];
//                }
//                NSLog(@"%@",dict[@"Data"][0]);
                
                [self.userInfoDict setObject:[dict[@"Data"][0][@"nickname"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"nickname"] forKey:@"nickname"]; // 昵称
                [self.userInfoDict setObject:[dict[@"Data"][0][@"username"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"username"] forKey:@"username"]; // 姓名
                [self.userInfoDict setObject:[dict[@"Data"][0][@"sex"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"sex"] forKey:@"sex"]; // 性别
                [self.userInfoDict setObject:[dict[@"Data"][0][@"birth"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"birth"] forKey:@"birth"]; // 出生年月
                [self.userInfoDict setObject:[dict[@"Data"][0][@"phone"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"phone"] forKey:@"phone"]; // 手机号
                [self.userInfoDict setObject:[dict[@"Data"][0][@"email"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"email"] forKey:@"email"]; // 邮箱
                [self.userInfoDict setObject:[dict[@"Data"][0][@"city"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"city"] forKey:@"city"]; // 地址
                [self.userInfoDict setObject:[dict[@"Data"][0][@"photourl"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"photourl"] forKey:@"photourl"]; // 头像
                [self.userInfoDict setObject:[dict[@"Data"][0][@"Brief"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"Brief"] forKey:@"Brief"]; // 简介
                [self.userInfoDict setObject:[dict[@"Data"][0][@"BackgroundImg"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"BackgroundImg"] forKey:@"BackgroundImg"]; // 背景图片
            
                NSLog(@"wangbin  %@",self.userInfoDict);
                
//                NSLog(@"dofigfdoighoidfhgohdfoighofdhgoidfhgoidfhgohd%@",self.model.nickname);
                
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"VerifyCount"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"VerifyCount"] forKey:@"UserVerifyCount"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"jifen"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"jifen"] forKey:@"UserJiFen"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0 ][@"studyVal"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"studyVal"] forKey:@"UserStudyValues"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"powerSource"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"powerSource"] forKey:@"UserPowerSource"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"nickname"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"nickname"] forKey:@"UserNickName"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"photourl"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"photourl"] forKey:@"headpic"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self getUserInfo];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToIntroViewController) name:@"JumpToIntroViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadImage) name:@"ChangeHeadImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadData" object:nil];
    // Do any additional setup after loading the view.
}

- (void)changeHeadImage {
    
    if (!self.picker) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        self.picker.allowsEditing = YES;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *photoAciton = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cameraAction];
    [alert addAction:photoAciton];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.headImageData = UIImageJPEGRepresentation(image, 0.01);
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    
    [[AppHttpManager shareInstance] postAddImgWithPhoneNo:User_ID Img:self.headImageData PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self getUserInfo];
        } else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

// 刷新视图
- (void)reloadData {
    [self getUserInfo];
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
