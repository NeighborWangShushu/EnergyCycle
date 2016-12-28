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
    self = [super init];
    if (self) {
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
    
    [shareParams SSDKSetupQQParamsByText:model.content title:model.title url:[NSURL URLWithString:model.shareUrl] thumbImage:SHARE_IMG image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
    
    [self share:SSDKPlatformSubTypeQZone params:shareParams block:^(SSDKResponseState state) {
        result(state);
    }];
}

- (void)shareClientToWeixinSession:(ShareModel *)model imageUrl:(NSString *)imageUrl block:(result)result{
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
        [shareParams SSDKSetupWeChatParamsByText:model.content title:model.title url:[NSURL URLWithString:model.shareUrl] thumbImage:SHARE_IMG image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    } else {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:imageUrl]
                              options:0
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    [shareParams SSDKSetupShareParamsByText:model.content images:@[image] url:[NSURL URLWithString:model.shareUrl] title:model.title type:SSDKContentTypeAuto];                                }
                                [weakSelf share:SSDKPlatformSubTypeWechatSession params:shareParams block:^(SSDKResponseState state) {
                                    result(state);
                                }];
                                
                            }];
    }

}

- (void)shareClientToWeixinTimeLine:(ShareModel *)model imageUrl:(NSString *)imageUrl block:(result)result {
    
    __weak typeof(self) weakSelf = self;

    NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
        [shareParams SSDKSetupWeChatParamsByText:model.content title:model.title url:[NSURL URLWithString:model.shareUrl] thumbImage:SHARE_IMG image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    } else {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:imageUrl]
                              options:0
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    [shareParams SSDKSetupShareParamsByText:model.content images:@[image] url:[NSURL URLWithString:model.shareUrl] title:model.title type:SSDKContentTypeAuto];
                                }
                                [weakSelf share:SSDKPlatformSubTypeWechatTimeline params:shareParams block:^(SSDKResponseState state) {
                                    result(state);
                                }];

                            }];
    }
    
    
}

- (void)shareClientToWeibo:(ShareModel *)model imageUrl:(NSString *)imageUrl block:(result)result {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    
    NSString * content = @"";
    NSInteger length = model.content.length;

    if (model.content) {
        content = [model.content substringWithRange:NSMakeRange(0, MIN(length, 140))];
        content = [content stringByAppendingString:@"..."];
    }
    if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
        [shareParams SSDKSetupSinaWeiboShareParamsByText:content title:model.title image:SHARE_IMG url:[NSURL URLWithString:model.shareUrl] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeWebPage];
    } else {
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:imageUrl]
                              options:0
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    [shareParams SSDKSetupShareParamsByText:content images:@[image] url:[NSURL URLWithString:model.shareUrl] title:model.title type:SSDKContentTypeAuto];
                                }
                                [weakSelf share:SSDKPlatformTypeSinaWeibo params:shareParams block:^(SSDKResponseState state) {
                                    result(state);
                                }];
                              
                            }];
    }
    
    
}

- (void)shareClientToQQSession:(ShareModel *)model imageUrl:(NSString *)imageUrl block:(result)result {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    
    NSString * content = @"";
    NSInteger length = model.content.length;

    if (model.content) {
        content = [model.content substringWithRange:NSMakeRange(0, MIN(length, 48))];
        content = [content stringByAppendingString:@"..."];
    }
    
    if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
        [shareParams SSDKSetupQQParamsByText:content title:model.title url:[NSURL URLWithString:model.shareUrl] thumbImage:SHARE_IMG image:SHARE_IMG type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    } else {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:imageUrl]
                              options:0
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    
                                    [shareParams SSDKSetupShareParamsByText:content images:@[image] url:[NSURL URLWithString:model.shareUrl] title:model.title type:SSDKContentTypeAuto];
                                    
                                }
                            }];
    }
    
    [self share:SSDKPlatformSubTypeQQFriend params:shareParams block:^(SSDKResponseState state) {
        result(state);
    }];
}

- (void)shareClientToQQZone:(ShareModel *)model imageUrl:(NSString *)imageUrl block:(result)result {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    
    NSString * content = @"";
    NSInteger length = model.content.length;
    if (model.content) {
        content = [model.content substringWithRange:NSMakeRange(0, MIN(length, 100))];
        content = [content stringByAppendingString:@"..."];
    }
    
    if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
        [shareParams SSDKSetupQQParamsByText:content title:content url:[NSURL URLWithString:model.shareUrl] thumbImage:SHARE_IMG image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
    } else {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:imageUrl]
                              options:0
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    [shareParams SSDKSetupShareParamsByText:content images:@[image] url:[NSURL URLWithString:model.shareUrl] title:content type:SSDKContentTypeAuto];
                                }
                            }];
    }
    
    [self share:SSDKPlatformSubTypeQZone params:shareParams block:^(SSDKResponseState state) {
        result(state);
    }];
    
}


- (void)share:(SSDKPlatformType)type params:(NSMutableDictionary*)params block:(result)result {
    
    switch (type) {
        case SSDKPlatformSubTypeWechatSession:
        {
            [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                    [self getScoreByShareSuccess];
                }
                result(state);
            }];
        }
            break;
        case SSDKPlatformSubTypeWechatTimeline:
        {
            [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                    [self getScoreByShareSuccess];
                }
                result(state);
                
            }];
        }
            break;
        case SSDKPlatformTypeSinaWeibo:
        {
            [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                    [self getScoreByShareSuccess];
                }
                result(state);
                NSLog(@"%@",error);
            }];
        }
            break;
        case SSDKPlatformSubTypeQQFriend:
        {
            [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                    [self getScoreByShareSuccess];
                }
                result(state);
            }];
        }
            break;
        case SSDKPlatformSubTypeQZone:
        {
            [ShareSDK share:SSDKPlatformSubTypeQZone parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                    [self getScoreByShareSuccess];
                }
                result(state);
            }];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)getScoreByShareSuccess {
    [[AppHttpManager shareInstance] getShareWithUserid:[User_ID intValue] Token:User_TOKEN Type:3 PostOrGet:@"post" success:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
    } failure:^(NSString *str) {
        
    }];
}

@end
