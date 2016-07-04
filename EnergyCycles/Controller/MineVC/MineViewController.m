//
//  MineViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MineViewController.h"

#import "MineOneViewCell.h"
#import "MineTwoViewCell.h"
#import "UserModel.h"

#import "MyProfileViewController.h"
#import "leaderboardViewController.h"
#import "MyNewsViewController.h"

#import "MySocialCircleViewController.h"

#import "MineEneryCycleViewController.h"
#import "MineAdvPKViewController.h"
#import "MineEveryDayPKViewController.h"
#import "RecommentViewController.h"


@interface MineViewController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate> {
    UIImageView *pointImageView;
    
    NSMutableDictionary *userInformationDict;
    NSData *headImageData;
    UIImagePickerController *picker;
    
    NSString *pushType;
}

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mineTableView.showsVerticalScrollIndicator = NO;
    mineTableView.showsHorizontalScrollIndicator = NO;
    
    userInformationDict = [[NSMutableDictionary alloc] init];
    self.userImageButton.layer.masksToBounds = YES;
    self.userImageButton.layer.cornerRadius = 75/2.0f;
    self.nameLabel.text = nil;
    self.fensiLabel.text = [NSString stringWithFormat:@"粉丝 %@",@""];
    self.guanzhuLabel.text = [NSString stringWithFormat:@"关注 %@",@""];
    self.addressLabel.text = nil;
    
    //
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(Screen_width-50, 24, 50, 50);
    [rightButton setImage:[[UIImage imageNamed:@"xinfeng.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0);
    [self.headBackView addSubview:rightButton];
    
    pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(37, -3, 8, 8)];
    pointImageView.layer.masksToBounds = YES;
    pointImageView.layer.cornerRadius = 4.f;
    pointImageView.backgroundColor = [UIColor clearColor];
    if (EnetgyCycle.isHaveJPush) {
        pointImageView.backgroundColor = [UIColor redColor];
    }
    [rightButton addSubview:pointImageView];
    
    UIView *headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 337.5, Screen_width, 0.5)];
    headLineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    [self.headBackView addSubview:headLineView];
    
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO) {//6p
        self.energyCycleButton.imageEdgeInsets = UIEdgeInsetsMake(-23, 13*Screen_width/375+15, 0, -15*Screen_width/375);
        self.everyDayPKButton.imageEdgeInsets = UIEdgeInsetsMake(-23, 13*Screen_width/375+15, 0, -15*Screen_width/375);
        self.advPKButton.imageEdgeInsets = UIEdgeInsetsMake(-23, 13*Screen_width/375+15, 0, -15);
        self.recommentButton.imageEdgeInsets = UIEdgeInsetsMake(-23, 13*Screen_width/375-2, 0, -15);
    }else if ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO) {//6
        self.energyCycleButton.imageEdgeInsets = UIEdgeInsetsMake(-23, 13*Screen_width/375+5, 0, 0);
        self.everyDayPKButton.imageEdgeInsets = UIEdgeInsetsMake(-23, 13*Screen_width/375+2, 0, 0);
        self.advPKButton.imageEdgeInsets = UIEdgeInsetsMake(-23, 13*Screen_width/375+2, 0, 0);
        self.recommentButton.imageEdgeInsets = UIEdgeInsetsMake(-23, 13*Screen_width/375-2, 0, -15);
    }else {//5
        self.energyCycleButton.imageEdgeInsets = UIEdgeInsetsMake(-23, 13, 0, 0);
        self.everyDayPKButton.imageEdgeInsets = UIEdgeInsetsMake(-23, 13, 0, 0);
        self.advPKButton.imageEdgeInsets = UIEdgeInsetsMake(-23, 13, 0, 0);
        self.recommentButton.imageEdgeInsets = UIEdgeInsetsMake(-23, 13, 0, -15);
    }
    
    //消息中心,监听是否收到推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appGetJPush:) name:@"isAppGetJPush" object:nil];
    
    self.addressLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"AddRessStr"];
    self.iconImageView.image = [UIImage imageNamed:@""];
}

#pragma mark - 更新大图像
- (IBAction)userImageButtonClick:(id)sender {
    [self photoButtonClick];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBarHidden = YES;
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        [self getUserInformation];
        [self getMyFenSicCount];
        [self getMyGuanZhuCount];
    }
}

#pragma mark - 查询基本资料
- (void)getUserInformation {
    [[AppHttpManager shareInstance] getGetInfoByUseridWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if ([dict[@"Data"] count]) {
                self.nameLabel.text = dict[@"Data"][0][@"nickname"];
                NSLog(@"%@",[dict objectForKey:@"Data"]);
                [userInformationDict setObject:[dict[@"Data"][0][@"nickname"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"nickname"] forKey:@"nickname"];
                [userInformationDict setObject:[dict[@"Data"][0][@"username"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"username"] forKey:@"username"];
                [userInformationDict setObject:[dict[@"Data"][0][@"sex"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"sex"] forKey:@"sex"];
                [userInformationDict setObject:[dict[@"Data"][0][@"birth"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"birth"] forKey:@"birth"];
                [userInformationDict setObject:[dict[@"Data"][0][@"phone"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"phone"] forKey:@"phone"];
                [userInformationDict setObject:[dict[@"Data"][0][@"email"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"email"] forKey:@"email"];
                [userInformationDict setObject:[dict[@"Data"][0][@"city"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"city"] forKey:@"city"];
                [userInformationDict setObject:[dict[@"Data"][0][@"jifen"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"jifen"] forKey:@"jifen"];
//                [self.userImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"Data"][0][@"photourl"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
                [self.userImageButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"Data"][0][@"photourl"]]] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
                
                //认证期数（一阶 二阶   三阶）
                //老学员认证 状态 --> 审核通过 审核未通过 待审核 ""
                self.iconImageView.image = [UIImage imageNamed:@""];
                if (!(dict[@"Data"][0][@"VerifyCount"] == nil || [dict[@"Data"][0][@"VerifyCount"] isKindOfClass:[NSNull class]] || [dict[@"Data"][0][@"VerifyCount"] isEqual:[NSNull null]])) {
                    if ([dict[@"Data"][0][@"VerifyCount"] isEqualToString:@"一阶"]) {
                        self.iconImageView.image = [UIImage imageNamed:@"jiangpai01.png"];
                    }else if ([dict[@"Data"][0][@"VerifyCount"] isEqualToString:@"二阶"]) {
                        self.iconImageView.image = [UIImage imageNamed:@"jiangpai02.png"];
                    }else if ([dict[@"Data"][0][@"VerifyCount"] isEqualToString:@"三阶"]) {
                        self.iconImageView.image = [UIImage imageNamed:@"jiangpai03.png"];
                    }
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"VerifyCount"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"VerifyCount"] forKey:@"UserVerifyCount"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"jifen"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"jifen"] forKey:@"UserJiFen"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0 ][@"studyVal"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"studyVal"] forKey:@"UserStudyValues"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"powerSource"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"powerSource"] forKey:@"UserPowerSource"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"nickname"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"nickname"] forKey:@"UserNickName"];
                [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"photourl"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"photourl"] forKey:@"headpic"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        [mineTableView reloadData];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 我的粉丝
- (void)getMyFenSicCount {
    [[AppHttpManager shareInstance] getGetfensiCountWithUserid:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            self.fensiLabel.text = [NSString stringWithFormat:@"粉丝 %@",dict[@"Data"]];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 我关注的人
- (void)getMyGuanZhuCount {
    [[AppHttpManager shareInstance] getGetGuanzhuCountWithUserid:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            self.guanzhuLabel.text = [NSString stringWithFormat:@"关注 %@",dict[@"Data"]];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
        
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 收到推送消息
- (void)appGetJPush:(NSNotification *)notification {
    NSDictionary *notiDict = [notification object];
    if ([[NSString stringWithFormat:@"%@",pushType] length] <= 0) {
        pushType = [notiDict objectForKey:@"type"];
    }else {
        pushType = [NSString stringWithFormat:@"%@,%@",pushType,notiDict[@"type"]];
    }
    
    EnetgyCycle.isHaveJPush = NO;
    if (!EnetgyCycle.isAtInformationView) {
        pointImageView.backgroundColor = [UIColor redColor];
    }
}

#pragma mark - 跳转到消息界面
- (void)rightAction {
    pointImageView.backgroundColor = [UIColor clearColor];
    [self performSegueWithIdentifier:@"MineViewToMuNewsView" sender:nil];
}

#pragma mark - 能量圈按键响应事件
- (IBAction)energyCycleButtonClick:(id)sender {
    if (User_TOKEN.length <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        [self performSegueWithIdentifier:@"MineViewToEneryCycleView" sender:nil];
    }
}

#pragma mark - 每日PK按键响应事件
- (IBAction)everyDayPKButtonClick:(id)sender {
    if (User_TOKEN.length <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        [self performSegueWithIdentifier:@"MineViewToEvveryDayPKView" sender:nil];
    }
}

#pragma mark - 进阶PK按键响应事件
- (IBAction)advOKButtonClick:(id)sender {
    if (User_TOKEN.length <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        [self performSegueWithIdentifier:@"MineViewToAdvPKView" sender:nil];
    }
}

#pragma mark - 推荐按键响应事件
- (IBAction)recommentButtonClick:(id)sender {
    if (User_TOKEN.length <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        [self performSegueWithIdentifier:@"MineViewToRecommentView" sender:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 3;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *MineOneViewCellId = @"MineOneViewCellId";
            MineOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineOneViewCellId];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"MineOneViewCell" owner:self options:nil].lastObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateDataWithStr:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPowerSource"]]];
            
            return cell;
        }
    }else if (indexPath.section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = @"退出当前账号";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:246/255.0 green:100/255.0 blue:98/255.0 alpha:1];
        
        return cell;
    }
    
    static NSString *MineTwoViewCellId = @"MineTwoViewCellId";
    MineTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineTwoViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MineTwoViewCell" owner:self options:nil].lastObject;
    } 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateDataWithSection:indexPath.section withIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {//我的资料
            [self performSegueWithIdentifier:@"MineViewToMyProfilrView" sender:nil];
        }else if (indexPath.row == 2) {//我的社交圈
            [self performSegueWithIdentifier:@"MineVireToMySocialCertView" sender:nil];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {//积分排行榜
            [self performSegueWithIdentifier:@"MineViewToLeaderboardView" sender:nil];
        }else if (indexPath.row == 1) {//老学员认证
            [self performSegueWithIdentifier:@"MineViewToTheOldCerView" sender:nil];
        }else {//积分商城
            [self performSegueWithIdentifier:@"MineViewToIntergralMallView" sender:nil];
        }
    }else if (indexPath.section == 2) {//反馈
        [self performSegueWithIdentifier:@"MineViewToIWillAdviseView" sender:nil];
    }else {//退出登录
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma mark - == 新增需求
#pragma mark - 关注
- (IBAction)guanzhuButtonClick:(UIButton *)sender {
    MySocialCircleViewController *mySocialCircleVC = MainStoryBoard(@"MySoicalCircleVCID");
    mySocialCircleVC.showType = @"关注";
    [self.navigationController pushViewController:mySocialCircleVC animated:YES];
}

#pragma mark - 粉丝
- (IBAction)fensiButtonClick:(UIButton *)sender {
    MySocialCircleViewController *mySocialCircleVC = MainStoryBoard(@"MySoicalCircleVCID");
    mySocialCircleVC.showType = @"粉丝";
    [self.navigationController pushViewController:mySocialCircleVC animated:YES];
}

#pragma mark - 退出登录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {//退出登录
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"USERID"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"TOKEN"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"PHONE"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"UserPowerSource"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isUnLoginSetAPService" object:nil];
        EnetgyCycle.energyTabBar.selectedIndex = 0;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 15)];
    headView.backgroundColor = [UIColor clearColor];
    
    if (section != 0) {
        for (NSInteger i=0; i<2; i++) {
            UIView *lieView = [[UIView alloc] initWithFrame:CGRectMake(0, 9.5*i, Screen_width, 0.5)];
            lieView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
            
            [headView addSubview:lieView];
        }
    }else {
        UIView *lieView = [[UIView alloc] initWithFrame:CGRectMake(0, 9.5, Screen_width, 0.5)];
        lieView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
        
        [headView addSubview:lieView];
    }
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 15.f;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MineViewToMyProfilrView"]) {
        MyProfileViewController *myProVC = segue.destinationViewController;
        myProVC.inforDict = userInformationDict;
    }else if ([segue.identifier isEqualToString:@"MineViewToLeaderboardView"]) {
        leaderboardViewController *learVC = segue.destinationViewController;
        learVC.showName = userInformationDict[@"nickname"];
    }else if ([segue.identifier isEqualToString:@"MineViewToMuNewsView"]) {
        MyNewsViewController *myNewsVC = segue.destinationViewController;
        myNewsVC.pushType = pushType;
    }else if ([segue.identifier isEqualToString:@"MineViewToEneryCycleView"]) {//能量圈
        MineEneryCycleViewController *energyVC = segue.destinationViewController;
        energyVC.showTitle = @"我";
        energyVC.showUserID = User_ID;
    }else if ([segue.identifier isEqualToString:@"MineViewToEvveryDayPKView"]) {//每日
        
    }else if ([segue.identifier isEqualToString:@"MineViewToAdvPKView"]) {//进阶
        MineAdvPKViewController *advVC = segue.destinationViewController;
        advVC.showTitle = @"我";
        advVC.showUserID = User_ID;
    }else if ([segue.identifier isEqualToString:@"MineViewToRecommentView"]) {//推荐
        RecommentViewController *recommentVC = segue.destinationViewController;
        recommentVC.showTitle = @"我";
        recommentVC.showUserID = User_ID;
    }
}

#pragma mark - 调用相册相机操作
- (void)photoButtonClick {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册选取",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!picker) {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.allowsEditing=YES;
    }
    
    if (buttonIndex==0) {//从相册选择
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }else if (buttonIndex==1){//相机
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)_picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image= [info objectForKey:UIImagePickerControllerEditedImage];
    headImageData = UIImageJPEGRepresentation(image, 0.01);
    
    [_picker dismissViewControllerAnimated:YES completion:NULL];
    
//    [self.userImageButton setImage:[[UIImage imageWithData:headImageData] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

//    [self.userImageButton setImage:[[UIImage imageWithData:headImageData] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.userImageButton setImage:[UIImage imageWithData:headImageData]];

    [[AppHttpManager shareInstance] postAddImgWithPhoneNo:User_ID Img:headImageData PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self getUserInformation];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
