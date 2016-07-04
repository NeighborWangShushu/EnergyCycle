//
//  OtherPageView.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReferralModel.h"

@interface OtherPageView : UIView


@property (nonatomic,strong)ReferralModel*model;

@property (nonatomic,copy)NSString * type;
@property (nonatomic,copy)NSString * postType;

@property (nonatomic,strong)NSDictionary * data;

- (void)reloadData;

@end
