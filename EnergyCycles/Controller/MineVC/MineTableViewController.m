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
#import "UserModel.h"
#import "UserInfoModel.h"
#import "MineHeadTableViewCell.h"
#import "MineTableViewCell.h"

#import "AttentionAndFansTableViewController.h"
#import "EnergyPostTableViewController.h"
#import "PKRecordTableViewController.h"
#import "leaderboardViewController.h"
#import "MessageViewController.h"

@interface MineTableViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *userInfoDict;
@property (nonatomic, strong) UserModel *model;
@property (nonatomic, strong) UserInfoModel *infoModel;

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
        return 105.f;
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
        [cell updateDataWithModel:self.model infoModel:self.infoModel];

        return cell;
    } else {
        static NSString *mineTableViewCell = @"mineTableViewCell";
        MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineTableViewCell];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateDataWithSection:indexPath.section index:indexPath.row userInfoModel:self.infoModel];
        return cell;
    }
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // 个人主页
        [self performSegueWithIdentifier:@"MineHomePageViewController" sender:nil];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) { // 能量圈
            EnergyPostTableViewController *enVC = [[EnergyPostTableViewController alloc] init];
            enVC.userId = self.model.use_id;
            enVC.isMineTableView = YES;
            [self.navigationController pushViewController:enVC animated:YES];
        } else if (indexPath.row == 1) { // 关注
            AttentionAndFansTableViewController *afVC = [[AttentionAndFansTableViewController alloc] init];
            afVC.type = 1;
            [self.navigationController pushViewController:afVC animated:YES];
        } else if (indexPath.row == 2) { // 粉丝
            AttentionAndFansTableViewController *afVC = [[AttentionAndFansTableViewController alloc] init];
            afVC.type = 2;
            [self.navigationController pushViewController:afVC animated:YES];
        } else if (indexPath.row == 3) { // 消息
            [self performSegueWithIdentifier:@"MessageViewController" sender:nil];
        } else if (indexPath.row == 4) { // PK记录
            PKRecordTableViewController *pkVC = [[PKRecordTableViewController alloc] init];
            pkVC.userId = self.model.use_id;
            pkVC.isMineTableView = YES;
            [self.navigationController pushViewController:pkVC animated:YES];
        } else if (indexPath.row == 5) { // 推荐用户
            
        }
    } else if (indexPath.section == 2) { // 积分榜
        leaderboardViewController *leadVC = MainStoryBoard(@"leaderboardViewController");
        leadVC.showName = self.model.nickname;
        leadVC.userId = self.model.use_id;
        [self.navigationController pushViewController:leadVC animated:YES];
    } else if (indexPath.section == 3) { // 设置
        [self performSegueWithIdentifier:@"SettingTableViewController" sender:nil];
    }
}

// 传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MineHomePageViewController"]) {
        MineHomePageViewController *mineHomePageVC = segue.destinationViewController;
        mineHomePageVC.userId = User_ID;
    } else if([segue.identifier isEqualToString:@"IntroViewController"]){
        IntroViewController *introVC = segue.destinationViewController;
        introVC.introString = self.model.Brief;
    }
}
// 跳转到修改简介页面
- (void)jumpToIntroViewController {
    [self performSegueWithIdentifier:@"IntroViewController" sender:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadData];
}

// 获取用户信息
- (void)getUserInfo {
    [[AppHttpManager shareInstance] getGetInfoByUseridWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            
            if ([dict[@"Data"] count]) {
                for (NSDictionary *subDict in dict[@"Data"]) {
                    UserModel *model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                    self.model = model;
                }
                
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

// 获取关注数,粉丝数等数据
- (void)getUserInfoModel {
    [[AppHttpManager shareInstance] getGetUserInfoWithUserid:[User_ID intValue] OtherUserID:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:dict[@"Data"][0] error:nil];
            self.infoModel = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
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
    [self getUserInfoModel];
    
    
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
    [self getUserInfoModel];
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
