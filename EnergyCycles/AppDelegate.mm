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
//#import "XMShareQQUtil.h"
#import "ShareSDKManager.h"
#import <AdSupport/AdSupport.h>
#import <AudioToolbox/AudioToolbox.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "RadioClockModel.h"


@interface AppDelegate () <WeiboSDKDelegate,WXApiDelegate,QQApiInterfaceDelegate,UIAlertViewDelegate,JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>
//引导页
@property (nonatomic, strong) GuidePageViewController *guidePageView;


@end

AppDelegate *EnetgyCycle = nil;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    EnetgyCycle = self;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [ShareSDKManager shareInstance];
    
     NSString *isEnterGuidePage = [[NSUserDefaults standardUserDefaults] objectForKey:@"IsEnterGuidePage"];
    if (!isEnterGuidePage) {
        [self creatGuidePageView];
    }
    
    //登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAPService:) name:@"isSetAPService" object:nil];
    //退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUnLoginAPService:) name:@"isUnLoginSetAPService" object:nil];
    

    
    //注册推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                NSLog(@"注册成功");
            }else{
                //用户点击不允许
                NSLog(@"注册失败");
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
        
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
        
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    //设置启动页停留时间
//    [NSThread sleepForTimeInterval:10.0];
    
    return YES;
}


#pragma mark - 设置推送别名
- (void)setAPService:(NSNotification *)notification {
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    [JPUSHService setAlias:[NSString stringWithFormat:@"MY_%@",userId] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

#pragma mark - 退出登录
- (void)setUnLoginAPService:(NSNotification *)notification {
    [JPUSHService setAlias:@"MY_" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
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
//        [QQApiInterface handleOpenURL:url delegate:[XMShareQQUtil sharedInstance]];
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
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"weiboShareSuccess" object:nil];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatShareSuccess" object:nil];
            
//            [[AppHttpManager shareInstance] getShareWithUserid:[User_ID intValue] Token:User_TOKEN Type:1 PostOrGet:@"post" success:^(NSDictionary *dict) {
//                NSLog(@"微信分享成功%@",dict);
//                
//            } failure:^(NSString *str) {
//                NSLog(@"%@",str);
//            }];
        }
    }if ([resp isKindOfClass:[QQBaseResp class]]) {
        if (resp.errCode == 0) {
            NSLog(@"分享qq成功");
            
        }
    }
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {
    NSLog(@"%@",[NSString stringWithFormat:@"%d, tags: %@, alias: %@\n", iResCode,tags, alias]);
}

#pragma mark - 获取极光推送注册设备的ID
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    self.appJPushRegisterId = [JPUSHService registrationID];
    
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    
    NSDictionary * userInfo = notification.request.content.userInfo; if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo]; }
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo]; }
    
  
    NSArray * notifications = [RadioClockModel findAll];
    RadioClockModel*model = [notifications firstObject];
    if (model) {
        model.isNotification = YES;
        [model saveOrUpdate];
        if ([response.notification.request.content.categoryIdentifier isEqualToString:model.identifier]) {
            NSLog(@"收到通知%@",response.notification.request.content.categoryIdentifier);
            self.translateRadioList = YES;
            [self.tabbarController setSelectIndex:2];
        }
    }
   
    
    completionHandler(); //
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler {
        // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSDictionary *apsDictionary = (NSDictionary *)userInfo;
    
    NSString *type = [NSString stringWithFormat:@"%@", apsDictionary[@"type"]];
    if ([type isEqualToString:@"1"] || [type isEqualToString:@"2"] || [type isEqualToString:@"3"]) {
        // 通知推送 type = 1
        // 活动推送 type = 2
        // 私信推送 type = 3
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushReloadData" object:nil];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
}

#pragma mark - UNNotificationCenter iOS10通知

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"actionIdentifier:%@",response.actionIdentifier);
    NSLog(@"categoryIdentifier:%@",response.notification.request.content.categoryIdentifier);

    NSArray * notifications = [RadioClockModel findAll];
    [notifications enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RadioClockModel*model = [notifications firstObject];
        model.isNotification = YES;
        [model saveOrUpdate];
        if (model) {
            if ([response.notification.request.content.categoryIdentifier isEqualToString:model.identifier]) {
                NSLog(@"收到通知%@",response.notification.request.content.categoryIdentifier);
                self.translateRadioList = YES;
                [self.tabbarController setSelectIndex:2];
            }
        }
    }];
    
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error { //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
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
                    [SVProgressHUD showImage:nil status:@"今日您还未签到!"];
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
