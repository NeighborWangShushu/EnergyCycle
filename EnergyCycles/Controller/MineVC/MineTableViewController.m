//
//  MineTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineTableViewController.h"

#import "MineHomePageViewController.h"

#import "MineHomeTableViewController.h"

#import "IntroViewController.h"
#import "UserModel.h"
#import "UserInfoModel.h"
#import "MineHeadTableViewCell.h"
#import "MineHeadViewTableViewCell.h"
#import "MineTableViewCell.h"

#import "AttentionAndFansTableViewController.h"
#import "MyProfileViewController.h"
#import "InformTableViewController.h"
#import "IntegralMallViewController.h"
#import "EnergyPostTableViewController.h"
#import "MineEveryDayPKViewController.h"
#import "PKGatherViewController.h"
#import "PKRecordTableViewController.h"
#import "leaderboardViewController.h"
#import "MessageViewController.h"
#import "SettingTableViewController.h"
#import "FriendViewController.h"
#import "MineAdvPKViewController.h"
#import "RecommendedTableViewController.h"
#import "DraftsTableViewController.h"

#import "AppDelegate.h"

@interface MineTableViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    BOOL isCheck;
    
}

@property (nonatomic, strong) NSMutableDictionary *userInfoDict;
@property (nonatomic, strong) UserModel *model;
@property (nonatomic, strong) UserInfoModel *infoModel;

@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) NSData *headImageData;
@property (nonatomic, strong) AppDelegate *delegate;

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
    return 5;
}

// 每一组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 8;
    } else if (section == 2) {
        return 2;
    } else {
        return 1;
    }
}

// 每一组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    if (section == 0) {
    //        return 0;
    //    }
    return 0.01f;
}

// 每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 286.f;
    }
    return 50.f;
}

// 每一组的底部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

//// 设置分区头的View
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
//    return view;
//}
//
//// 设置分区尾的View
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
//    return view;
//}

// 每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //        static NSString *mineHeadTableViewCell = @"mineHeadTableViewCell";
        //        MineHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineHeadTableViewCell];
        //
        //        if (cell == nil) {
        //            cell = [[NSBundle mainBundle] loadNibNamed:@"MineHeadTableViewCell" owner:self options:nil].lastObject;
        //        }
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        [cell updateDataWithModel:self.model infoModel:self.infoModel];
        
        static NSString *mineHeadViewTableViewCell = @"mineHeadViewTableViewCell";
        MineHeadViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineHeadViewTableViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineHeadViewTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateDataWithModel:self.model];
        
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
        [self.delegate.tabbarController hideTabbar:YES];
//        MineHomeTableViewController *mine = [[MineHomeTableViewController alloc] init];
//        mine.userId = User_ID;
//        [self.navigationController pushViewController:mine animated:YES];
        [self performSegueWithIdentifier:@"MineHomePageViewController" sender:nil];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) { // 能量圈
            //            EnergyPostTableViewController *enVC = [[EnergyPostTableViewController alloc] init];
            //            enVC.userId = self.model.use_id;
            //            enVC.isMineTableView = YES;
            //            [self.navigationController pushViewController:enVC animated:YES];
        } else if (indexPath.row == 1) { // 我的资料
            [self.delegate.tabbarController hideTabbar:YES];
            MyProfileViewController *myVC = MainStoryBoard(@"MyProfileViewController");
            myVC.model = self.model;
            [self.navigationController pushViewController:myVC animated:YES];
        } else if (indexPath.row == 2) { // 我的社交圈
            [self.delegate.tabbarController hideTabbar:YES];
            FriendViewController *friendVC = [[FriendViewController alloc] init];
            [self.navigationController pushViewController:friendVC animated:YES];
        } else if (indexPath.row == 3) { // 关注
            [self.delegate.tabbarController hideTabbar:YES];
            AttentionAndFansTableViewController *afVC = [[AttentionAndFansTableViewController alloc] init];
            afVC.type = 1;
            [self.navigationController pushViewController:afVC animated:YES];
        } else if (indexPath.row == 4) { // 粉丝
            [self.delegate.tabbarController hideTabbar:YES];
            AttentionAndFansTableViewController *afVC = [[AttentionAndFansTableViewController alloc] init];
            afVC.type = 2;
            [self.navigationController pushViewController:afVC animated:YES];
        } else if (indexPath.row == 5) { // 消息
            [self.delegate.tabbarController hideTabbar:YES];
            [self performSegueWithIdentifier:@"MessageViewController" sender:nil];
        } else if (indexPath.row == 6) { // 通知
            [self.delegate.tabbarController hideTabbar:YES];
            InformTableViewController *informVC = [[InformTableViewController alloc] init];
            [self.navigationController pushViewController:informVC animated:YES];
        } else if (indexPath.row == 7) { // 草稿箱
            [self.delegate.tabbarController hideTabbar:YES];
            DraftsTableViewController *draftsVC = [[DraftsTableViewController alloc] init];
            [self.navigationController pushViewController:draftsVC animated:YES];
        }
        //        } else if (indexPath.row == 4) { // PK记录
        //            PKRecordTableViewController *pkVC = [[PKRecordTableViewController alloc] init];
        //            pkVC.userId = self.model.use_id;
        //            pkVC.isMineTableView = YES;
        //            [self.navigationController pushViewController:pkVC animated:YES];
        //        } else if (indexPath.row == 5) { // 推荐用户
        //            RecommendedTableViewController *reVC = [[RecommendedTableViewController alloc] init];
        //            [self.navigationController pushViewController:reVC animated:YES];
        //        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) { // 积分榜
            [self.delegate.tabbarController hideTabbar:YES];
            leaderboardViewController *leadVC = MainStoryBoard(@"leaderboardViewController");
            leadVC.showName = self.model.nickname;
            leadVC.userId = self.model.use_id;
            [self.navigationController pushViewController:leadVC animated:YES];
        } else if (indexPath.row == 1) { // 积分商城
            [self.delegate.tabbarController hideTabbar:YES];
            IntegralMallViewController *imVC = MainStoryBoard(@"IntegralMallViewController");
            [self.navigationController pushViewController:imVC animated:YES];
        }
    } else if (indexPath.section == 3) { // 设置
        [self.delegate.tabbarController hideTabbar:YES];
        [self performSegueWithIdentifier:@"SettingTableViewController" sender:nil];
    } else if (indexPath.section == 4) { // 退出登录
        [self exit];
    }
}

// 退出
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
        //        EnetgyCycle.energyTabBar.selectedIndex = 0;
        [EnetgyCycle.tabbarController setSelectIndex:0];
        //        [self.tableView reloadData];
        
        //        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:exitAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MineHomePageViewController"]) {
        MineHomePageViewController *mineHomePageVC = segue.destinationViewController;
        mineHomePageVC.userId = User_ID;
    } else if([segue.identifier isEqualToString:@"IntroViewController"]){
        IntroViewController *introVC = segue.destinationViewController;
        introVC.introString = self.model.Brief;
    } else if([segue.identifier isEqualToString:@"SettingTableViewController"]) {
        SettingTableViewController *setVC = segue.destinationViewController;
        setVC.model = self.model;
    }
}
// 跳转到修改简介页面
- (void)jumpToIntroViewController {
    [self performSegueWithIdentifier:@"IntroViewController" sender:nil];
    [self.delegate.tabbarController hideTabbar:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.delegate.tabbarController hideTabbar:NO];
    [self getUserInfo];
    [self getUserInfoModel];
    
    self.tableView.scrollsToTop = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.delegate.isPushToMessageView) {
        self.delegate.isPushToMessageView = NO;
        [self.delegate.tabbarController hideTabbar:YES];
        [self performSegueWithIdentifier:@"MessageViewController" sender:nil];
    }
}

//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
//    scrollView.scrollsToTop = YES;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
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
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"studyVal"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"studyVal"] forKey:@"UserStudyValues"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"powerSource"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"powerSource"] forKey:@"UserPowerSource"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"nickname"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"nickname"] forKey:@"UserNickName"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"photourl"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"photourl"] forKey:@"headpic"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"phone"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"phone"] forKey:@"PHONE"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"Tel"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"Tel"] forKey:@"Tel"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"LoginType"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"LoginType"] forKey:@"LoginType"];
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
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.title = @"我的";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [self getUserInfo];
    //    [self getUserInfoModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToEnergyPostTableViewController) name:@"jumpToEnergyPostTableViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToToDayPKTableViewController) name:@"jumpToToDayPKTableViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToMineAdvPKViewController) name:@"jumpToMineAdvPKViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToRecommendedTableViewController) name:@"jumpToRecommendedTableViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToIntroViewController) name:@"JumpToIntroViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadImage) name:@"ChangeHeadImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToMessageViewController) name:@"PUSHTOMESSAGEVIEWCONTROLLER" object:nil];
    // Do any additional setup after loading the view.
}

// 能量帖
- (void)jumpToEnergyPostTableViewController {
    [self.delegate.tabbarController hideTabbar:YES];
    EnergyPostTableViewController *enVC = [[EnergyPostTableViewController alloc] init];
    enVC.userId = self.model.use_id;
    enVC.isMineTableView = YES;
    [self.navigationController pushViewController:enVC animated:YES];
}

// 每日PK
- (void)jumpToToDayPKTableViewController {
    [self.delegate.tabbarController hideTabbar:YES];
    //    MineEveryDayPKViewController *everyVC = MainStoryBoard(@"MineEveryDayPKVCID");
    //    [self.navigationController pushViewController:everyVC animated:YES];
    PKGatherViewController *pkVC = [[PKGatherViewController alloc] init];
    [self.navigationController pushViewController:pkVC animated:YES];
}

// 进阶PK
- (void)jumpToMineAdvPKViewController {
    [self.delegate.tabbarController hideTabbar:YES];
    MineAdvPKViewController *advVC = MainStoryBoard(@"MineAdvPKVCID");
    advVC.showTitle = @"我";
    advVC.showUserID = User_ID;
    [self.navigationController pushViewController:advVC animated:YES];
}

// 推荐
- (void)jumpToRecommendedTableViewController {
    [self.delegate.tabbarController hideTabbar:YES];
    RecommendedTableViewController *reVC = [[RecommendedTableViewController alloc] init];
    [self.navigationController pushViewController:reVC animated:YES];
}

- (void)jumpToMessageViewController {
    [self performSegueWithIdentifier:@"MessageViewController" sender:nil];
}

- (void)changeHeadImage {
    
    if (!self.picker) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        self.picker.allowsEditing = YES;
        self.picker.navigationBar.tintColor = [UIColor whiteColor];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.view.window.rootViewController presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *photoAciton = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.view.window.rootViewController presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cameraAction];
    [alert addAction:photoAciton];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.headImageData = UIImageJPEGRepresentation(image, 0.01);
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    
    [[AppHttpManager shareInstance] postAddImgWithPhoneNo:User_ID Img:self.headImageData PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self getUserInfo];
        } else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
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
