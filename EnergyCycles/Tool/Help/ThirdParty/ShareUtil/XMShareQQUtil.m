//
//  XMShareQQUtil.m
//  
//
//

#import "XMShareQQUtil.h"

@interface XMShareQQUtil ()<QQApiInterfaceDelegate> {
    TencentOAuth *tencentOAuth;
    NSArray *permissions;
    
    NSString *openId;
    NSString *token;
}

@end

@implementation XMShareQQUtil

#pragma mark - 分享
- (void)shareToQQ {
    [self shareToQQBase:SHARE_QQ_TYPE_SESSION];
}

- (void)shareToQzone {
    [self shareToQQBase:SHARE_QQ_TYPE_QZONE];
}

- (void)shareToQQBase:(SHARE_QQ_TYPE)type {
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:APP_KEY_QQ andDelegate:self];
//    [QQApiInterface handleOpenURL:url delegate:[XMShareQQUtil sharedInstance]];
    
    NSString *utf8String = self.shareUrl;
    NSString *theTitle = self.shareTitle;
    NSString *description = self.shareText;
    NSData *imageData = UIImageJPEGRepresentation(SHARE_IMG, SHARE_IMG_COMPRESSION_QUALITY);
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:theTitle
                                description:description
                                previewImageData:imageData];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    if (type == SHARE_QQ_TYPE_SESSION) {//将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        NSLog(@"QQApiSendResultCode:%d", sent);
    }else{//将内容分享到qzone
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        NSLog(@"Qzone QQApiSendResultCode:%d", sent);
    }
}

#pragma mark QQ



#pragma mark - 登录
- (void)login {
//    tencentOAuth = [[TencentOAuth alloc] initWithAppId:APP_KEY_QQ andDelegate:self];
//    permissions= [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
//    
//    [tencentOAuth authorize:permissions inSafari:NO];
    
    
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
        associateHandler (user.uid, user, user);
        NSLog(@"dd%@",user.rawData);
        NSLog(@"dd%@",user.credential);
    } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {
            
        }
    }];
    
}

//登陆完成调用
- (void)tencentDidLogin {
    self.inforDict = [[NSMutableDictionary alloc] init];
    
    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length]) {
        //记录登录用户的OpenID、Token以及过期时间
//        "access_token" = A361C6EFCCDBB853FD4A2AF749DC52C3;
//        encrytoken = 9a8728ddbd5a209f4e66215cfa2ef5db;
//        "expires_in" = 7776000;
//        msg = "";
//        openid = 9F03F30F12691FCAF5FD73264A9F175B;
//        "pay_token" = 24FBAAA373734C5212D72D7C9FD62AFB;
//        pf = "openmobile_ios";
//        pfkey = 162a90d0339149632864b6d1fc443c44;
//        ret = 0;
//        "user_cancelled" = NO;
        
        [tencentOAuth getUserInfo];
        
        [self.inforDict setObject:tencentOAuth.openId forKey:@"openId"];
        [self.inforDict setObject:tencentOAuth.accessToken forKey:@"accessToken"];
    }else {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@"登录不成功 没有获取accesstoken" forKey:@"nickname"];
        
        [self.delegate passQQLoginGetInformationWithDict:dic];
    }
}

#pragma mark - 获取用户信息
- (void)getUserInfoResponse:(APIResponse *)response {
//    city = "\U9ec4\U6d66";
//    figureurl = "http://qzapp.qlogo.cn/qzapp/1104987324/9F03F30F12691FCAF5FD73264A9F175B/30";
//    "figureurl_1" = "http://qzapp.qlogo.cn/qzapp/1104987324/9F03F30F12691FCAF5FD73264A9F175B/50";
//    "figureurl_2" = "http://qzapp.qlogo.cn/qzapp/1104987324/9F03F30F12691FCAF5FD73264A9F175B/100";
//    "figureurl_qq_1" = "http://q.qlogo.cn/qqapp/1104987324/9F03F30F12691FCAF5FD73264A9F175B/40";
//    "figureurl_qq_2" = "http://q.qlogo.cn/qqapp/1104987324/9F03F30F12691FCAF5FD73264A9F175B/100";
//    gender = "\U7537";
//    "is_lost" = 0;
//    "is_yellow_vip" = 0;
//    "is_yellow_year_vip" = 0;
//    level = 0;
//    msg = "";
//    nickname = "\U6768\U4eae";
//    province = "\U4e0a\U6d77";
//    ret = 0;
//    vip = 0;
//    "yellow_vip_level" = 0;
    
    [self.inforDict setObject:response.jsonResponse[@"nickname"] forKey:@"nickname"];
    [self.inforDict setObject:response.jsonResponse[@"city"] forKey:@"city"];
    [self.inforDict setObject:response.jsonResponse[@"figureurl_qq_1"] forKey:@"headimage"];
    
    [self.delegate passQQLoginGetInformationWithDict:self.inforDict];
}

//非网络错误导致登录失败
- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (cancelled) {
        [dict setObject:@"用户取消登录" forKey:@"nickname"];
        [self.delegate passQQLoginGetInformationWithDict:dict];
    }else {
        [dict setObject:@"登录失败" forKey:@"nickname"];
        [self.delegate passQQLoginGetInformationWithDict:dict];
    }
}

//网络错误导致登录失败
- (void)tencentDidNotNetWork {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"无网络链接,请检测网络" forKey:@"nickname"];
    [self.delegate passQQLoginGetInformationWithDict:dict];
}

+ (instancetype)sharedInstance {
    static XMShareQQUtil* util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[XMShareQQUtil alloc] init];
    });
    
    return util;
}

- (instancetype)init {
//    static id obj=nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        obj = [super init];
//        if (obj) {
//        }
//    });
//    self=obj;
//
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:APP_KEY_QQ andDelegate:self];
    return self;
}


- (void)responseDidReceived:(APIResponse *)response forMessage:(NSString *)message{
    
}
#pragma mark - 腾讯
//请求获得内容 当前版本只支持第三方相应腾讯业务请求
- (BOOL)onTencentReq:(TencentApiReq *)req{
    return YES;
}

// 响应请求答复 当前版本只支持腾讯业务相应第三方的请求答复
- (BOOL)onTencentResp:(TencentApiResp *)resp{
    return YES;
}

//分享回调函数
- (void)onResp:(QQBaseResp *)resp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QQShareSuccess" object:nil];
    if (resp.type == 2) {
        [[AppHttpManager shareInstance] getShareWithUserid:[User_ID intValue] Token:User_TOKEN Type:1 PostOrGet:@"post" success:^(NSDictionary *dict) {
            NSLog(@"%@",dict);
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
    }
}

@end
