//
//  TheInvitationViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TheInvitationViewController.h"

#import "InvitationOneViewCell.h"
#import "InvitationTwoViewCell.h"
#import "InviteThreeTableViewCell.h"

#import "XMShareWeiboUtil.h"
#import "XMShareWechatUtil.h"
#import "XMShareQQUtil.h"

#import "OtherUesrViewController.h"

#define  FOCUSColor [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1]

@interface TheInvitationViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    NSMutableArray * _dataArray;
    NSInteger tempIndex;
    NSMutableArray * _stateArray;
    
    BOOL isSearch;
}

@end

@implementation TheInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邀请好友";
    _dataArray =[NSMutableArray array];
    _stateArray=[NSMutableArray array];
    invitationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    invitationTableView.showsHorizontalScrollIndicator = NO;
    invitationTableView.showsVerticalScrollIndicator = NO;
    
    //
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    
    if ([User_TOKEN length] > 0 && !isSearch) {
        [self getDataList];
    }
}

#pragma mark - 获取推荐列表
- (void)getDataList {
    [[AppHttpManager shareInstance] getGetRecommendUserWithUserId:[User_ID intValue] Token:User_TOKEN PostOrGet:@"get" success:^(NSDictionary *dict) {
        [_dataArray removeAllObjects];
        if ([dict[@"Code"] intValue]==200||[dict[@"IsSuccess"] intValue]==1) {
            for (NSDictionary * dic in dict[@"Data"]) {
                [_dataArray addObject:dic];
                if ([dic[@"isHeart"]intValue]==0) {
                    [_stateArray addObject:@"0"];
                }else{
                    [_stateArray addObject:@"1"];
                }
            }
            [invitationTableView reloadData];
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popViewControllerAnimated:NO];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section==1){
        return 4;
    }
     return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50.f;
    }else if (indexPath.section == 1) {
        return 60.f;
    }
    return 60.f;
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *InvitationOneViewCellId = @"InvitationOneViewCellId";
        InvitationOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InvitationOneViewCellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"InvitationOneViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.searchTextField.delegate = self;
        
        return cell;
    }else if (indexPath.section == 1) {
        static NSString *InvitationTwoViewCellId = @"InvitationTwoViewCellId";
        InvitationTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InvitationTwoViewCellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"InvitationTwoViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *titleArr = @[@"通讯录",@"QQ",@"微信",@"微博"];
        NSArray *subTitleArr = @[@"添加通讯录好友",@"添加QQ好友",@"添加微信好友",@"添加微博好友"];
        NSArray *imageArr = @[@"07tongxun.png",@"08QQ.png",@"09weixin.png",@"10weibo.png"];
        
        cell.iconImageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
        cell.titleLabel.text = titleArr[indexPath.row];
        cell.subTitleLabel.text = subTitleArr[indexPath.row];
        
        cell.lineView.hidden = NO;
        if (indexPath.row == 3) {
            cell.lineView.hidden = YES;
        }
        
        return cell;
    }
    
    static NSString *InviteThreeTableViewCellID = @"InviteThreeTableViewCellID";
    InviteThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InviteThreeTableViewCellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"InviteThreeTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.focusButton addTarget:self action:@selector(foucusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (_dataArray.count) {
        NSDictionary * dic=_dataArray[indexPath.row];
        [cell.iconButton sd_setBackgroundImageWithURL:[NSURL URLWithString:dic[@"photoUrl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
        cell.iconButton.tag = 10001 + indexPath.row;
        cell.nameLabel.text=dic[@"nickName"];
        
        if ([_stateArray[indexPath.row] intValue]==1) {
            cell.focusButton.selected=YES;
            cell.focusButton.backgroundColor=FOCUSColor;
            [cell.focusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [cell.focusButton setBackgroundColor:[UIColor whiteColor]];
            [cell.focusButton setTitleColor:FOCUSColor forState:UIControlStateNormal];
        }
        cell.focusButton.layer.masksToBounds=YES;
        cell.focusButton.layer.cornerRadius=2.5f;
        cell.focusButton.layer.borderWidth=0.5f;
        cell.focusButton.layer.borderColor=[FOCUSColor CGColor];
        cell.focusButton.tag=1000+indexPath.row;
        
        cell.lineView.hidden = NO;
        if (indexPath.row == _dataArray.count-1) {
            cell.lineView.hidden = YES;
        }
        
        //跳转到其他人详情
        [cell setIconButtonClick:^(NSInteger cellIndex) {
            OtherUesrViewController *otherUserVC = MainStoryBoard(@"OtherUserInformationVCID");
            NSDictionary *dic = (NSDictionary *)_dataArray[cellIndex-10001];
            otherUserVC.otherUserId = dic[@"userId"];
            otherUserVC.otherName = dic[@"nickName"];
            otherUserVC.otherPic = dic[@"photoUrl"];
            [self.navigationController pushViewController:otherUserVC animated:YES];
        }];
    }
    
    return cell;
}

//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSString *shareTitle = [NSString stringWithFormat:@"我的邀请码是%@，一起加入能量圈吧！",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPowerSource"]];
        if ([User_TOKEN length] <= 0) {
            shareTitle = @"一起加入能量圈吧！";
        }
        NSString *shareText = @"能量圈—新圈子，新起点，新生活；输入能量源，获得100积分，赢取丰厚奖品！";
        NSString *shareUrl = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",MYJYAppId];
        
        if (indexPath.row == 0) {//通讯录
            [AppHelpManager CheckAddressBookAuthorization:^(bool isAuthorized) {
                if (isAuthorized) {
                    if ([User_TOKEN length] <= 0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
                    }else {
                        [self performSegueWithIdentifier:@"TheInviteViewToTheAddressBookView" sender:nil];
                    }
                }else {
                    [SVProgressHUD showImage:nil status:@"请到设置>隐私>通讯录打开本应用的权限设置"];
                }
            }];
        }else if (indexPath.row == 1) {//QQ
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                XMShareQQUtil *util = [XMShareQQUtil sharedInstance];
                util.shareTitle = shareTitle;
                util.shareText = shareText;
                util.shareUrl = shareUrl;
                [util shareToQQ];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示信息", nil) message:NSLocalizedString(@"手机未安装相关应用", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
                [alertView show];
            }

        }else if (indexPath.row == 2) {//微信
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
                XMShareWechatUtil *util = [XMShareWechatUtil sharedInstance];
                util.shareTitle = shareTitle;
                util.shareText = shareText;
                util.shareUrl = shareUrl;
                
                [util shareToWeixinSession];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示信息", nil) message:NSLocalizedString(@"手机未安装相关应用", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
                [alertView show];
            }
        }else {//微博
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]]) {
                XMShareWeiboUtil *util = [XMShareWeiboUtil sharedInstance];
                util.shareTitle = shareTitle;
                util.shareText = shareText;
                util.shareUrl = shareUrl;
                
                [util shareToWeibo];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示信息", nil) message:NSLocalizedString(@"手机未安装相关应用", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 20.f;
    }
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 50)];
        headView.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 27, Screen_width-24, 17)];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"推荐用户";
        if (isSearch) {
            label.text = @"搜索结果";
        }
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [headView addSubview:label];
        
        return headView;
    }
    return nil;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 50.f;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - 添加、取消关注
- (void)foucusButtonClick:(UIButton *)sender {
    NSInteger index=sender.tag-1000;
    if (_stateArray.count==0) {
        return;
    }
    NSDictionary * dic = _dataArray[index];
    int userId = [dic[@"userId"] intValue];
    if ([_stateArray[index] intValue]==0) {// 添加关注
        sender.selected=YES;
        [_stateArray replaceObjectAtIndex:index withObject:@"1"];
        [self focusOrCancelFocus:1 userID:userId];
    }else {
        sender.selected=NO;// 取消关注
         [_stateArray replaceObjectAtIndex:index withObject:@"0"];
         [self focusOrCancelFocus:2 userID:userId];
    }
    
    tempIndex=0;
    [invitationTableView reloadData];
}

-(void)focusOrCancelFocus:(int)typeId userID:(int)userId{
    [[AppHttpManager shareInstance] getAddOrCancelFriendWithType:typeId UserId:[User_ID intValue] Token:User_TOKEN OUserId:userId PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] intValue]==200||[dict[@"IsSuccess"] intValue]==1) {
            
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 搜索事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length] > 0) {
        isSearch = YES;
        [self getSearchWithTextFieldText:textField.text];
        [textField resignFirstResponder];
        textField.text = nil;
    }else {
        [SVProgressHUD showImage:nil status:@"请输入姓名"];
    }
    
    return YES;
}

- (void)getSearchWithTextFieldText:(NSString *)text {
    if (User_TOKEN.length <= 0) {
        [SVProgressHUD showImage:nil status:@"请登录后搜索"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        [[AppHttpManager shareInstance] getGetLikeUserWithuserId:[User_ID intValue] Where:text PostOrGet:@"get" success:^(NSDictionary *dict) {
            [_dataArray removeAllObjects];
            [_stateArray removeAllObjects];
            if ([dict[@"Code"] intValue]==200||[dict[@"IsSuccess"] intValue]==1) {
                for (NSDictionary * dic in dict[@"Data"]) {
                    [_dataArray addObject:dic];
                    if ([dic[@"isHeart"]intValue]==0) {
                        [_stateArray addObject:@"0"];
                    }else{
                        [_stateArray addObject:@"1"];
                    }
                }
                [invitationTableView reloadData];
            }else if ([dict[@"Code"] integerValue] == 10000) {
                [SVProgressHUD showImage:nil status:@"登录失效"];
                [self.navigationController popViewControllerAnimated:NO];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
