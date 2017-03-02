//
//  RadioNotificationController.h
//  EnergyCycles
//
//  Created by vj on 2016/12/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RadioClockModel.h"

@interface RadioNotificationController : NSObject

+ (RadioNotificationController *)shareInstance;

+ (NSArray*)findAll;

+ (void)add:(RadioClockModel*)model;

+ (void)remove:(RadioClockModel*)model;

+ (void)addObjects:(NSArray*)models;

+ (void)removeAll;

- (NSArray*)getAllRequests;

- (void)findNotificationWithModel:(RadioClockModel*)model success:(void(^)(BOOL isExist))isExist;

@end
