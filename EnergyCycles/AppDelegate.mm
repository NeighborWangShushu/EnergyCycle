//
//  AppDelegate.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AppDelegate.h"

#import "CommonMarco.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "GuidePageViewController.h"
#import "XMShareQQUtil.h"


@interface AppDelegate () <WeiboSDKDelegate,WXApiDelegate,QQApiInterfaceDelegate,UIAlertViewDelegate>
//引导页
@property (nonatomic, strong) GuidePageViewController *guidePageView;


@end

AppDelegate *EnetgyCycle = nil;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    EnetgyCycle = self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    //第三方_微信
    [WXApi registerApp:APP_KEY_WEIXIN withDescription:@"weixin"];
    //第三方_微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:APP_KEY_WEIBO];
    [XMShareQQUtil sharedInstance];

    
    self.audioPlayIndex = -1;
    //进入引导页
    NSString *isEnterGuidePage = [[NSUserDefaults standardUserDefaults] objectForKey:@"IsEnterGuidePage"];
    if (!isEnterGuidePage) {
        [self creatGuidePageView];
    }
    
    //登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAPService:) name:@"isSetAPService" object:nil];
    //退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUnLoginAPService:) name:@"isUnLoginSetAPService" object:nil];
    
    //注册推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }else {
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    [APService setupWithOption:launchOptions];
    
    //设置启动页停留时间
//    [NSThread sleepForTimeInterval:10.0];
    
    return YES;
}

#pragma mark - 设置推送别名
- (void)setAPService:(NSNotification *)notification {
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    [APService setAlias:[NSString stringWithFormat:@"MY_%@",userId] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

#pragma mark - 退出登录
- (void)setUnLoginAPService:(NSNotification *)notification {
    [APService setAlias:@"MY_" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

#pragma mark - 进入引导页
- (void)creatGuidePageView {
    NSArray *coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
    UIButton *enterButton = [UIButton new];
    [enterButton setBackgroundImage:[UIImage imageNamed:@"bg_bar"] forState:UIControlStateNormal];
    self.guidePageView = [[GuidePageViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:@[@"GuidePage_1.png",@"GuidePage_2.png",@"GuidePage_3.png"] button:enterButton];
    self.window.rootViewController = self.guidePageView;
    
    __weak AppDelegate *weakSelf = self;
    self.guidePageView.didSelectedEnter = ^() {
        weakSelf.guidePageView = nil;
        
        [weakSelf enterApp];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IsEnterGuidePage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
}

#pragma mark - 进入App
- (void)enterApp {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.window.rootViewController = [storyBoard instantiateInitialViewController];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    NSArray *urlArr = [urlStr componentsSeparatedByString:@":"];
    if ([urlArr.firstObject isEqualToString:@"wx4db0f86a514ef7ef"]) {//微信
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([urlArr.firstObject isEqualToString:@"tencent1104987324"]) {//QQ
        [QQApiInterface handleOpenURL:url delegate:[XMShareQQUtil sharedInstance]];
        return [TencentOAuth HandleOpenURL:url];
    }else if ([urlArr.firstObject isEqualToString:@"wb4273175200"]) {//微博
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return YES;
}

#pragma mark - 腾讯
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    NSArray *urlArr = [urlStr componentsSeparatedByString:@":"];
    if ([urlArr.firstObject isEqualToString:@"wx4db0f86a514ef7ef"]) {//微信
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([urlArr.firstObject isEqualToString:@"tencent1104987324"]) {//QQ
        return [TencentOAuth HandleOpenURL:url];
    }else if ([urlArr.firstObject isEqualToString:@"wb4273175200"]) {//微博
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return YES;
}



#pragma mark - 微博
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    NSLog(@"微博请求");
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    NSLog(@"微博回调");
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        if (response.statusCode == 0) {//登录成功
            [WBHttpRequest requestForUserProfile:[(WBAuthorizeResponse *)response userID] withAccessToken:[(WBAuthorizeResponse *)response accessToken] andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                WeiboUser *userInfo = result;
                
                if (userInfo == nil || [userInfo isKindOfClass:[NSNull class]] || [userInfo isEqual:[NSNull null]]) {
                    [SVProgressHUD showImage:nil status:@"微博登录失败"];
                }else {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    
                    [dict setObject:userInfo.userID forKey:@"openId"];
                    [dict setObject:userInfo.screenName forKey:@"nickname"];
                    [dict setObject:userInfo.profileImageUrl forKey:@"photoUrl"];
                    
                    NSString *weiboSex = @"";
                    if ([userInfo.gender isEqualToString:@"m"]) {
                        weiboSex = @"男";
                    }else if ([userInfo.gender isEqualToString:@"f"]) {
                        weiboSex = @"女";
                    }
                    [dict setObject:weiboSex forKey:@"sex"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isWeiboNotification" object:dict];
                }
            }];
        }else {
            NSLog(@"微博登录失败");
            [SVProgressHUD dismiss];
        }
    }else if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        if (response.statusCode == 0) {
            [[AppHttpManager shareInstance] getShareWithUserid:[User_ID intValue] Token:User_TOKEN Type:1 PostOrGet:@"post" success:^(NSDictionary *dict) {
                NSLog(@"微博分享成功%@",dict);
            } failure:^(NSString *str) {
                NSLog(@"%@",str);
            }];
        }
    }
}

#pragma mark - 微信
- (void)onResp:(BaseResp *)resp {
    NSLog(@"微信回调");
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (!([aresp isKindOfClass:[NSNull class]] || [aresp isEqual:[NSNull null]] || aresp == nil)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isWeixinNotification" object:@{@"weixin":aresp}];
    }
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == 0) {
            //分享成功
            [[AppHttpManager shareInstance] getShareWithUserid:[User_ID intValue] Token:User_TOKEN Type:1 PostOrGet:@"post" success:^(NSDictionary *dict) {
                NSLog(@"微信分享成功%@",dict);
            } failure:^(NSString *str) {
                NSLog(@"%@",str);
            }];
        }
    }
}

- (void)onReq:(BaseReq *)req {
    NSLog(@"微信请求");
    NSLog(@"onReq");
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {
    NSLog(@"%@",[NSString stringWithFormat:@"%d, tags: %@, alias: %@\n", iResCode,tags, alias]);
}

#pragma mark - 获取极光推送注册设备的ID
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
    self.appJPushRegisterId = [APService registrationID];
//    NSLog(@"%@",[APService registrationID]);
}

#pragma mark - 接收推送的处理//APNs.正在前台或者后台运行
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSDictionary *apsDictionary = (NSDictionary *)userInfo;
//    NSLog(@"推送：%@",apsDictionary);
    if (apsDictionary) {
        [application setApplicationIconBadgeNumber:0];
//        EnetgyCycle.mineNavC.mineItem.badgeValue = @"";
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        if ([apsDictionary[@"type"] isKindOfClass:[NSNull class]] || [apsDictionary[@"type"] isEqual:[NSNull null]] || apsDictionary[@"type"] == nil) {
            [dict setObject:@"1" forKey:@"type"];
        }else {
            [dict setObject:apsDictionary[@"type"] forKey:@"type"];
        }
 
        self.isHaveJPush = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isAppGetJPush" object:dict];
    }
}

#pragma mark - 判断点击icon
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSString *isEnterGuidePage = [[NSUserDefaults standardUserDefaults] objectForKey:@"IsEnterGuidePage"];
    if (!isEnterGuidePage) {
        [self creatGuidePageView];
    }else {
        //有推送
        if (application.applicationIconBadgeNumber != 0) {
            self.isHaveJPush = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isAppGetJPush" object:nil];
            [application setApplicationIconBadgeNumber:0];
        }
    }
}

#pragma mark - 判断是否已签到
- (void)getIsQianDao {
    if ([User_TOKEN length] > 0 && [User_ID integerValue] != 0) {
        [[AppHttpManager shareInstance] getIsHasSignWithUserId:[User_ID intValue] Token:User_TOKEN PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                if ([dict[@"Data"] integerValue] == 0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"今天还没有签到" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {

    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self getIsQianDao];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end
