//
//  LoginViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LoginViewController.h"

#import "CommonMarco.h"
#import "WXApi.h"
#import "WXApiObject.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>

#import "WeiboSDK.h"
#import "XMShareWeiboUtil.h"

#import "SBJson.h"
#import "SLALertManager.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "Constant.h"
#import "ECTabbarViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>


@interface LoginViewController () <WBHttpRequestDelegate,WXApiDelegate> {
    NSString *weiBoOpenidStr;
}


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.iconImageViewAutoLayoutTop.constant = 84*Screen_Height/667;
    
    [self chageTextFieldWithTextField:self.loginPhoneTextField];
    [self chageTextFieldWithTextField:self.loginPassWordTextField];
    
    //微博
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiboNotification:) name:@"isWeiboNotification" object:nil];
    
    //微信
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinNotification:) name:@"isWeixinNotification" object:nil];
    
    [self setupLeftNavBarWithTitle:@"back"];
}

- (void)chageTextFieldWithTextField:(UITextField *)myTextField {
    [myTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [myTextField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [SVProgressHUD dismiss];
    
    self.loginPhoneTextField.text = nil;
    self.loginPassWordTextField.text = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"USERID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"TOKEN"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"PHONE"];

}

#pragma mark - 返回按键响应事件
- (IBAction)backButtonClick:(id)sender {
    EnetgyCycle.isEnterLoginView = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginViewBackButtonClick" object:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 忘记密码按键响应事件
- (IBAction)forgetPassWordButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"LoginViewToForgetPassWordView" sender:nil];
}

#pragma mark - 登录按键响应事件
- (IBAction)loginButtonClick:(id)sender {
    if ([self.loginPhoneTextField.text length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
    }else if ([self.loginPassWordTextField.text length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
    }
//    else if (![[AppHelpManager sharedInstance] isValidPassword:self.loginPassWordTextField.text]) {
//        [SVProgressHUD showImage:nil status:@"密码由6到16位数字或字母组成"];
//    }
    else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:@"请等待.."];
        
        [[AppHttpManager shareInstance] getLoginWithPhoneNo:self.loginPhoneTextField.text PassWord:[self md5StringForString:self.loginPassWordTextField.text] User_X:@"121" User_Y:@"131" PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                NSDictionary *subDict = (NSDictionary *)dict[@"Data"][0];
                [[NSUserDefaults standardUserDefaults] setObject:subDict[@"use_id"] forKey:@"USERID"];
                [[NSUserDefaults standardUserDefaults] setObject:subDict[@"token"] forKey:@"TOKEN"];
                [[NSUserDefaults standardUserDefaults] setObject:subDict[@"phone"] forKey:@"PHONE"];
                [[NSUserDefaults standardUserDefaults] setObject:subDict[@"Role"] forKey:@"ISROLE"];
                [[NSUserDefaults standardUserDefaults] setObject:subDict[@"pwd"] forKey:@"PASSWORD"];
                
                [[NSUserDefaults standardUserDefaults] setObject:subDict[@"jifen"] forKey:@"UserJiFen"];
                [[NSUserDefaults standardUserDefaults] setObject:subDict[@"studyVal"] forKey:@"UserStudyValues"];
                [[NSUserDefaults standardUserDefaults] setObject:subDict[@"powerSource"] forKey:@"UserPowerSource"];
                [[NSUserDefaults standardUserDefaults] setObject:subDict[@"nickname"] forKey:@"UserNickName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [SVProgressHUD dismiss];
                
                EnetgyCycle.isEnterLoginView = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginViewBackButtonClick" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"isSetAPService" object:nil];
                [self dismissViewControllerAnimated:NO completion:nil];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
            [SVProgressHUD dismiss];
        }];
    }
}

#pragma mark - 注册按键响应事件
- (IBAction)registerButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"LoginViewToRegisterView" sender:nil];
}

#pragma mark - 密文按键响应事件
- (IBAction)isMiWenButtonClick:(UIButton *)sender {
    static BOOL isShowMiWen = NO;
    
    if (!isShowMiWen) {
        [sender setImage:[UIImage imageNamed:@"loginxianshi.png"] forState:UIControlStateNormal];
        self.loginPassWordTextField.secureTextEntry = NO;
        isShowMiWen = YES;
    }else {
        [sender setImage:[UIImage imageNamed:@"loginyincang.png"] forState:UIControlStateNormal];
        self.loginPassWordTextField.secureTextEntry = YES;
        isShowMiWen = NO;
    }
}

#pragma mark - 第三方登录-调用接口
- (void)thirdLoginInWithType:(int)type withOpenId:(NSString *)openId withNickName:(NSString *)nickName withPhotoUrl:(NSString *)photoUrl withSex:(NSString *)sex withPhone:(NSString *)phone {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"登录中.."];
    
    [[AppHttpManager shareInstance] IsFirstLoginWithLoginType:type openId:openId PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {

            NSLog(@"%@",dict);
            NSInteger isFirst = [dict[@"Data"] integerValue];
            [[AppHttpManager shareInstance] getOtherLoginWithLoginType:type OpenId:openId NickName:nickName PhotoUrl:photoUrl Sex:sex Phone:phone PostOrGet:@"post" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                    NSDictionary *subDict = (NSDictionary *)dict[@"Data"][0];
                    [[NSUserDefaults standardUserDefaults] setObject:subDict[@"use_id"] forKey:@"USERID"];
                    [[NSUserDefaults standardUserDefaults] setObject:subDict[@"token"] forKey:@"TOKEN"];
                    [[NSUserDefaults standardUserDefaults] setObject:subDict[@"Role"] forKey:@"ISROLE"];
                    [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:@"UserNickName"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [SVProgressHUD dismiss];
                    if (isFirst) {
                        [self isFirstLoginWithUserID:[subDict[@"use_id"] intValue] Token:subDict[@"token"]];
                    } else {
                        EnetgyCycle.isEnterLoginView = NO;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginViewBackButtonClick" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"isSetAPService" object:nil];
                        
                        [self dismissViewControllerAnimated:NO completion:nil];
                    }
                    
                }else {
                    [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                }
            } failure:^(NSString *str) {
                NSLog(@"%@",str);
                [SVProgressHUD dismiss];
            }];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
    
    
}

- (void)isFirstLoginWithUserID:(int)userid Token:(NSString *)token {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加能量源" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入要添加的能量源";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        if ([textField.text isEqualToString:@""] || textField.text == nil) {
            [SVProgressHUD showImage:nil status:@"能量源不能为空" maskType:SVProgressHUDMaskTypeClear];
        } else {
            [[AppHttpManager shareInstance] getPowerSourceRelevanceWithUserID:userid Token:token PowerSource:textField.text PostOrGet:@"post" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                    [[SLALertManager shareManager] showAlert:SLScroeTypeFifty];
//                    [SVProgressHUD showImage:nil status:@"能量源添加成功" maskType:SVProgressHUDMaskTypeClear];
                    EnetgyCycle.isEnterLoginView = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginViewBackButtonClick" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isSetAPService" object:nil];
                    
                    [self dismissViewControllerAnimated:NO completion:nil];
                } else {
                    [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                }
            } failure:^(NSString *str) {
                NSLog(@"%@", str);
            }];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EnetgyCycle.isEnterLoginView = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginViewBackButtonClick" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isSetAPService" object:nil];
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - 第三方登录-QQ登录
- (IBAction)qqButtonClick:(id)sender {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"登录中.."];
    
    //设备安装QQ应用,调用QQ应用,否则走网页
//    [[XMShareQQUtil sharedInstance] login];
//    [XMShareQQUtil sharedInstance].delegate = self;
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess) {
            NSLog(@"uid=%@",user.uid);
            NSLog(@"%@",user.credential);
            NSLog(@"token=%@",user.credential.token);
            NSLog(@"nickname=%@",user.nickname);
            NSLog(@"icon=%@",user.icon);
            
            [self thirdLoginInWithType:1 withOpenId:user.uid withNickName:user.nickname withPhotoUrl:user.icon withSex:@"" withPhone:@""];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示信息", nil) message:NSLocalizedString(@"手机未安装相关应用", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [alertView show];
            NSLog(@"%@",error);
        }
    }];
    
    
    //检测设备是否安装QQ,安装获取权限,否则提示未安装相关应用

}

#pragma mark - 第三方登录-QQ登录代理方法
- (void)passQQLoginGetInformationWithDict:(NSDictionary *)dict {
    [SVProgressHUD dismiss];
    if (!dict[@"openId"]) {//取消登录
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"登录信息", nil) message:dict[@"nickname"] delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }else {
        //第三方QQ登录成功,通过网络接口,提交数据
        
        
        
        [self thirdLoginInWithType:1 withOpenId:dict[@"openId"] withNickName:dict[@"nickname"] withPhotoUrl:dict[@"headimage"] withSex:@"" withPhone:@""];
    }
}

#pragma mark - 第三方登录-微博登录
- (IBAction)weiboButtonClick:(id)sender {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"登录中.."];
    
    //设备安装微博应用,调用微博应用,否则走网页
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess) {
            NSLog(@"uid=%@",user.uid);
            NSLog(@"%@",user.credential);
            NSLog(@"token=%@",user.credential.token);
            NSLog(@"nickname=%@",user.nickname);
            [self thirdLoginInWithType:3 withOpenId:user.uid withNickName:user.nickname withPhotoUrl:user.icon withSex:@"" withPhone:@""];

        }else {
            NSLog(@"%@",error);
        }
    }];
}


#pragma mark - 第三方登录-微博登录代理方法---消息中心
- (void)weiboNotification:(NSNotification *)notification {
    NSDictionary *dict = [notification object];
    [self thirdLoginInWithType:3 withOpenId:dict[@"openId"] withNickName:dict[@"nickname"] withPhotoUrl:dict[@"photoUrl"] withSex:dict[@"sex"] withPhone:@""];
}

//请求异常
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)receiveWeiBoResponse:(NSNotification *)notification {
    NSMutableArray *contentArray = notification.object;
    if (contentArray.count <= 0) {
        return;
    }
    
    NSString *notificationStr = [[contentArray objectAtIndex:0] lowercaseString];
    NSString *userid = [contentArray objectAtIndex:1];
    
    if ([notificationStr isEqualToString:@"登录失败"]) {
        // [SVProgressHUD showErrorWithStatus:notificationStr];
    }else {
        weiBoOpenidStr = [[contentArray objectAtIndex:0] lowercaseString];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [dic setObject:[contentArray objectAtIndex:0] forKey:@"access_token"];
        [dic setObject:userid forKey:@"uid"];
        
        [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:dic delegate:self withTag:@"0"];
    }
}

//收到网络回调
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    NSDictionary *resultDic = [result JSONValue];
    NSLog(@"微博回调: %@",resultDic);
    //微博名称: resultDic[@"name"]
    //微博OpenId: weiBoOpenidStr
    //根据获取的信息,调用网络接口,向后台提交数据,实现微博登录
}

#pragma mark - 第三方登录-微信登录
- (IBAction)weixinButtonClick:(id)sender {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"登录中.."];
    
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
//        SendAuthReq* req =[[SendAuthReq alloc ] init];
////        req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
//        req.scope = @"snsapi_userinfo,snsapi_base";
//        req.state = @"0744" ;
//
//        [WXApi sendReq:req];
//    }else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示信息", nil) message:NSLocalizedString(@"手机未安装相关应用", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
//        [alertView show];
//    }
    

//    
//   BOOL success = [WXApiRequestHandler sendAuthRequestScope:kAuthScope
//                                        State:kAuthState
//                                       OpenID:kAuthOpenID
//                             InViewController:self];
    
    
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess)
        {
            
            NSLog(@"uid=%@",user.uid);
            NSLog(@"%@",user.credential);
            NSLog(@"token=%@",user.credential.token);
            NSLog(@"nickname=%@",user.nickname);
            [self getUserInfoWithToken:user.credential.token withOpenId:user.uid];

        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
    
}

#pragma mark - 第三方登录-微信登录实现方法
//消息中心
- (void)weixinNotification:(NSNotification *)notification {
    /* ErrCode    ERR_OK = 0(用户同意)
                ERR_AUTH_DENIED = -4（用户拒绝授权）
                ERR_USER_CANCEL = -2（用户取消）
     code       用户换取access_token的code，仅在ErrCode为0时有效
     state      第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang       微信客户端当前语言
     country    微信用户当前国家信息 */
    
    NSDictionary *dict = [notification object];
    SendAuthResp *aresp = (SendAuthResp *)dict[@"weixin"];
    if (aresp.errCode == 0) {
        NSString *code = aresp.code;
        [self getAccess_tokenWithCode:code];
    }else if (aresp.errCode == -2) {//用户取消
        [SVProgressHUD showImage:nil status:@"用户取消"];
    }else if (aresp.errCode == -4) {//用户拒绝授权
        [SVProgressHUD showImage:nil status:@"用户拒绝授权"];
    }
}

- (void)getAccess_tokenWithCode:(NSString *)code {
    /* appid         应用唯一标识，在微信开放平台提交应用审核通过后获得
    secret        应用密钥AppSecret，在微信开放平台提交应用审核通过后获得
    code          填写第一步获取的code参数
    grant_type    填authorization_code */
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",APP_KEY_WEIXIN,APP_SECRECT_WEIXIN,code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"微信token:%@",dic);
                /* access_token       接口调用凭证
                 expires_in         access_token接口调用凭证超时时间，单位（秒）
                 refresh_token      用户刷新access_token
                 openid             授权用户唯一标识
                 scope              用户授权的作用域，使用逗号（,）分隔
                 unionid            只有在用户将公众号绑定到微信开放平台帐号后，才会出现该字段。 */
                [self getUserInfoWithToken:dic[@"access_token"] withOpenId:dic[@"openid"]];
            }
        });
    });
}

- (void)getUserInfoWithToken:(NSString *)token withOpenId:(NSString *)openId {
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"微信用户信息:%@",dic);
                /*
                 openid         普通用户的标识，对当前开发者帐号唯一
                 nickname       普通用户昵称
                 sex            普通用户性别，1为男性，2为女性
                 province       普通用户个人资料填写的省份
                 city           普通用户个人资料填写的城市
                 country        国家，如中国为CN
                 headimgurl     用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空
                 privilege      用户特权信息，json数组，如微信沃卡用户为（chinaunicom）
                 unionid        用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。
                 */
                
                NSString *postSex = @"";
                if ([dic[@"sex"] integerValue] == 1) {
                    postSex = @"男";
                }else if ([dic[@"sex"] integerValue] == 2) {
                    postSex = @"女";
                }
                
                [self thirdLoginInWithType:2 withOpenId:dic[@"openid"] withNickName:dic[@"nickname"] withPhotoUrl:dic[@"headimgurl"] withSex:postSex withPhone:@""];
            }
        });
    });
}

//如果是第三方登录就绑定手机号
- (void)gotoBindPhone {
    
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
