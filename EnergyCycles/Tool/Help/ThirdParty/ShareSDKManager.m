//
//  ShareSDKManager.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ShareSDKManager.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "CommonMarco.h"

@interface ShareSDKManager () {
   
}



@end




@implementation ShareSDKManager

+ (instancetype)shareInstance {
    static ShareSDKManager *shareNetworkMessage = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareNetworkMessage = [[self alloc] init];
    });
    
    return shareNetworkMessage;
}


- (instancetype)init {
    if (self == [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    [ShareSDK registerApp:@"153f499755e1c"
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;

 
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:APP_KEY_WEIBO
                                           appSecret:APP_SECRECT_WEIBO
                                         redirectUri:APP_KEY_WEIBO_RedirectURL
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:APP_KEY_WEIXIN
                                       appSecret:APP_SECRECT_WEIXIN];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:APP_ID_QQ
                                      appKey:APP_KEY_QQ
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}


- (void)shareClientToWeixinSession:(ShareModel *)model block:(result)result{
    NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupWeChatParamsByText:model.content title:model.title url:[NSURL URLWithString:model.shareUrl] thumbImage:SHARE_IMG image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    
    [self share:SSDKPlatformSubTypeWechatSession params:shareParams block:^(SSDKResponseState state) {
        result(state);
    }];

}

- (void)shareClientToWeixinTimeLine:(ShareModel *)model block:(result)result {
    NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupWeChatParamsByText:model.content title:model.title url:[NSURL URLWithString:model.shareUrl] thumbImage:SHARE_IMG image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    [self share:SSDKPlatformSubTypeWechatTimeline params:shareParams block:^(SSDKResponseState state) {
        result(state);
    }];
    
}

- (void)shareClientToWeibo:(ShareModel *)model block:(result)result {
    NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    
    [shareParams SSDKSetupSinaWeiboShareParamsByText:model.content title:model.title image:SHARE_IMG url:[NSURL URLWithString:model.shareUrl] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeWebPage];
    
    [self share:SSDKPlatformTypeSinaWeibo params:shareParams block:^(SSDKResponseState state) {
        result(state);
    }];

}

- (void)shareClientToQQSession:(ShareModel *)model block:(result)result {
    
    NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupQQParamsByText:model.content title:model.title url:[NSURL URLWithString:model.shareUrl] thumbImage:SHARE_IMG image:SHARE_IMG type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    [self share:SSDKPlatformSubTypeQQFriend params:shareParams block:^(SSDKResponseState state) {
        result(state);
    }];
}

- (void)shareClientToQQZone:(ShareModel *)model block:(result)result {
    NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupWeChatParamsByText:model.content title:model.title url:[NSURL URLWithString:model.shareUrl] thumbImage:SHARE_IMG image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
    
    [self share:SSDKPlatformSubTypeQZone params:shareParams block:^(SSDKResponseState state) {
        result(state);
    }];
}


- (void)share:(SSDKPlatformType)type params:(NSMutableDictionary*)params block:(result)result {
    
    switch (type) {
        case SSDKPlatformSubTypeWechatSession:
        {
            [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                result(state);
                
            }];
        }
            break;
        case SSDKPlatformSubTypeWechatTimeline:
        {
            [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                result(state);
                
            }];
        }
            break;
        case SSDKPlatformTypeSinaWeibo:
        {
            [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                result(state);
                NSLog(@"%@",error);
            }];
        }
            break;
        case SSDKPlatformSubTypeQQFriend:
        {
            [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                result(state);
                
            }];
        }
            break;
        case SSDKPlatformSubTypeQZone:
        {
            [ShareSDK share:SSDKPlatformSubTypeQZone parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                result(state);
                
            }];
        }
            
            break;
            
        default:
            break;
    }
    
}

@end
