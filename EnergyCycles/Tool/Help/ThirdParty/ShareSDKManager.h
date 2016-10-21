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

- (void)shareClientToQQSession:(ShareModel*)model block:(result)result;

- (void)shareClientToQQZone:(ShareModel*)model block:(result)result;

@end
