//
//  ReferralView.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//  推荐页面

#import <UIKit/UIKit.h>
#import "ReferralModel.h"
#import "BaseViewController.h"


@interface ReferralPageView : UIView


@property (nonatomic,strong)NSDictionary * data;

@property (nonatomic,strong)NSDictionary *radioData;

@property (nonatomic,strong)ReferralModel * model;

@property (nonatomic,copy)NSString * type;
@property (nonatomic,copy)NSString * postType;


- (void)reloadData;

@end
