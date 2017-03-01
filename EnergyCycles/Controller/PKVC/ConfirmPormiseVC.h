//
//  ConfirmPormiseVC.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import "PKSelectedModel.h"

@interface ConfirmPormiseVC : BaseViewController


@property (nonatomic, strong) PKSelectedModel *model;
@property (nonatomic, assign) NSInteger promise_number;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end
