//
//  ShareSDKManager.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareModel.h"
#import <ShareSDK/ShareSDK.h>


@interface ShareSDKManager : NSObject

typedef void (^result)(SSDKResponseState state);
@property (nonatomic,strong)result rs;


+ (instancetype)shareInstance;

- (void)shareClientToWeixinSession:(ShareModel*)model block:(result)result;

- (void)shareClientToWeixinTimeLine:(ShareModel*)model block:(result)result;

- (void)shareClientToWeibo:(ShareModel*)model block:(result)result;


//model.title  分享的标题。注：PARAM_TITLE、PARAM_IMAGE_URL、PARAM_	SUMMARY不能全为空，最少必须有一个是有值的。
//model.shareUrl 分享的图片URL
//model.content 分享的消息摘要，最长50个字

- (void)shareClientToQQSession:(ShareModel*)model block:(result)result;

- (void)shareClientToQQZone:(ShareModel*)model block:(result)result;



- (void)shareClientToWeixinSession:(ShareModel*)model imageUrl:(NSString *)imageUrl block:(result)result;

- (void)shareClientToWeixinTimeLine:(ShareModel*)model imageUrl:(NSString *)imageUrl block:(result)result;

- (void)shareClientToWeibo:(ShareModel*)model imageUrl:(NSString *)imageUrl block:(result)result;

- (void)shareClientToQQSession:(ShareModel*)model imageUrl:(NSString *)imageUrl block:(result)result;

- (void)shareClientToQQZone:(ShareModel*)model imageUrl:(NSString *)imageUrl block:(result)result;

@end
