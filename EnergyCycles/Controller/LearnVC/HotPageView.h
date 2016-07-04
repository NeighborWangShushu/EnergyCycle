//
//  HotPageViewController.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReferralModel.h"

@interface HotPageView : UIView

@property (nonatomic,strong)NSDictionary * data;

@property (nonatomic,strong)ReferralModel*model;

@property (nonatomic,copy)NSString * type;
@property (nonatomic,copy)NSString * postType;

- (void)reloadData;

@end
