//
//  OtherUesrViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "OtherUesrViewController.h"

#import "ChatViewController.h"

#import "MineEneryCycleViewController.h"
#import "MineAdvPKViewController.h"
#import "RecommentViewController.h"

#import "OtherUserEDPKViewController.h"

#import "OtherUserGuanZhuViewController.h"
#import "OtherUserFenSiViewController.h"
#import "ECAvatarManager.h"

@interface OtherUesrViewController () {
    BOOL isGuanZhu;
}

@end

@implementation OtherUesrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleAvatar)];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 75/2.f;
    [self.iconImageView addGestureRecognizer:tap];
    
    
    self.nengButtonAutoLayoutHight.constant = Screen_width/375 * 131;
    self.nengButtonAutoLayoutWith.constant = Screen_width/375 * 131;
    self.nengLabelAutoLayoutWith.constant = Screen_width/375 *131;
    
    self.guanzhuButton.layer.masksToBounds = YES;
    self.guanzhuButton.layer.cornerRadius = 3.f;
    self.guanzhuButton.layer.borderWidth = 1.f;
    self.guanzhuButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.fasixinButton.layer.masksToBounds = YES;
    self.fasixinButton.layer.cornerRadius = 3.f;
    self.fasixinButton.layer.borderWidth = 1.f;
    self.fasixinButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //标题
    self.nameLabel.text = self.otherName;
    //头像
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.otherPic]] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
    
    self.guanzhuButton.hidden = NO;
    self.fasixinButton.hidden = NO;
    if ([self.otherUserId integerValue] == [User_ID integerValue]) {
        self.guanzhuButton.hidden = YES;
        self.fasixinButton.hidden = YES;
    }
    
    if (Screen_width< 375.f) {
        self.oneButtonHeadHightAutoLayout.constant = 20;
        self.teoButtonHeadHightAutoLayout.constant = 20;
    }
}

- (void)scaleAvatar {
    [ECAvatarManager showImage:self.iconImageView];
}

#pragma mark - 返回按键响应事件
- (IBAction)backButtonClick:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

#pragma mark - 关注按键响应事件
- (IBAction)guanzhuButtonClick:(id)sender {
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        int type = 1;
        if (isGuanZhu) {//取消关注
            type = 2;
        }
        
        NSArray *fenNumArr = [self.fensiLabel.text componentsSeparatedByString:@" "];
        int fenNum = [fenNumArr.lastObject intValue];
        
        [[AppHttpManager shareInstance] getAddOrCancelFriendWithType:type UserId:[User_ID intValue] Token:User_TOKEN OUserId:[self.otherUserId intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                isGuanZhu = !isGuanZhu;
                if (type == 1) {
                    [self.guanzhuButton setTitle:@"已关注" forState:UIControlStateNormal];
                    self.fensiLabel.text = [NSString stringWithFormat:@"粉丝 %d",fenNum+1];
                }else {
                    [self.guanzhuButton setTitle:@"关注" forState:UIControlStateNormal];
                    self.fensiLabel.text = [NSString stringWithFormat:@"粉丝 %d",fenNum-1];
                }
            }else if ([dict[@"Code"] integerValue] == 10000) {
                [SVProgressHUD showImage:nil status:@"登录失效"];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
    }
}

#pragma mark - 发私信响应事件
- (IBAction)fasixinButtonClick:(id)sender {
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        ChatViewController *chatVC = MainStoryBoard(@"ChatViewVCID");
        chatVC.otherName = self.otherName;
        chatVC.otherID = self.otherUserId;
        chatVC.otherPic = self.otherPic;
        
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

#pragma mark -
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    [self getNetDataWithOtherUserId:self.otherUserId];
}

#pragma mark - 获取网络数据
- (void)getNetDataWithOtherUserId:(NSString *)otherUserId {
    [[AppHttpManager shareInstance] getGetPeopleDataInfoWithUserid:[User_ID intValue] UseredId:[otherUserId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            NSArray *dataArr = [dict[@"Data"] componentsSeparatedByString:@","];
            [self changeStatusWithArr:dataArr];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark -
- (void)changeStatusWithArr:(NSArray *)arr {
    self.fensiLabel.text = [NSString stringWithFormat:@"粉丝 %@",arr[0]];
    self.guanzhuLabel.text = [NSString stringWithFormat:@"关注 %@",arr[1]];
    
    [self.nengButton setTitle:arr[3] forState:UIControlStateNormal];
    [self.meiButton setTitle:arr[4] forState:UIControlStateNormal];
    [self.jinButton setTitle:arr[5] forState:UIControlStateNormal];
    [self.tuijianButton setTitle:arr[6] forState:UIControlStateNormal];
    
    if ([arr[2] integerValue] == 0) {
        isGuanZhu = NO;
        [self.guanzhuButton setTitle:@"关注" forState:UIControlStateNormal];
    }else {
        isGuanZhu = YES;
        [self.guanzhuButton setTitle:@"已关注" forState:UIControlStateNormal];
    }
}

#pragma mark - 关注的人
- (IBAction)guanzhuNumButtonClick:(UIButton *)sender {
    OtherUserGuanZhuViewController *guanzhuVC = MainStoryBoard(@"OtherUserGuanZhuVCID");
    guanzhuVC.otherUserID = self.otherUserId;
    [self.navigationController pushViewController:guanzhuVC animated:YES];
}

#pragma mark - 粉丝
- (IBAction)fensiNumButtonClick:(UIButton *)sender {
    OtherUserFenSiViewController *fensiVC = MainStoryBoard(@"OtherUserFenSiVCID");
    fensiVC.otherUserID = self.otherUserId;
    [self.navigationController pushViewController:fensiVC animated:YES];
}

#pragma mark - 能量圈
- (IBAction)mineEnergyButtonClick:(UIButton *)sender {
    MineEneryCycleViewController *energyVC = MainStoryBoard(@"MineEveryCycleVCID");
    energyVC.showUserID = self.otherUserId;
    energyVC.showTitle = self.otherName;
    [self.navigationController pushViewController:energyVC animated:YES];
}

#pragma mark - 今日pk
- (IBAction)mineEveryButtonClick:(UIButton *)sender {
    OtherUserEDPKViewController *everyVC = MainStoryBoard(@"OtherUserPKVCID");
    everyVC.showUserID = self.otherUserId;
    everyVC.showTitle = self.otherName;
    [self.navigationController pushViewController:everyVC animated:YES];
}

#pragma mark - 进阶pk
- (IBAction)mineAdvPKButtonClick:(UIButton *)sender {
    MineAdvPKViewController *advVC = MainStoryBoard(@"MineAdvPKVCID");
    advVC.showUserID = self.otherUserId;
    advVC.showTitle = self.otherName;
    [self.navigationController pushViewController:advVC animated:YES];
}

#pragma mark - 推荐
- (IBAction)mineRecommentButtonClick:(UIButton *)sender {
    RecommentViewController *recommentVC = MainStoryBoard(@"RecommentVCID");
    recommentVC.showUserID = self.otherUserId;
    recommentVC.showTitle = self.otherName;
    [self.navigationController pushViewController:recommentVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
