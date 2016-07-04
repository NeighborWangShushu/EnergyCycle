//
//  ReferralModel.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerItem.h"
#import "RadioItem.h"
#import "HealthModel.h"
#import "CCTalkModel.h"

@interface ReferralModel : NSObject

@property (nonatomic,strong)NSMutableArray * banners;
@property (nonatomic,strong)CCTalkModel * cctalk;
@property (nonatomic,strong)NSMutableArray * radios;
@property (nonatomic,strong)NSMutableArray * health;



// 推荐
- (id)initWithReferral:(NSDictionary *)data;

//热门
- (id)initWithHot:(NSDictionary *)data;

//其他
- (id)initWithOther:(NSDictionary *)data;


@end
