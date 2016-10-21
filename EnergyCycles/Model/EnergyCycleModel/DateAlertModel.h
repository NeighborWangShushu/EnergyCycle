//
//  DateAlertModel.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

//记录每天提醒一次的model

@interface DateAlertModel : JKDBModel

@property (nonatomic,assign)long long  last_alert_date;

@property (nonatomic)BOOL is_alert;

@end
