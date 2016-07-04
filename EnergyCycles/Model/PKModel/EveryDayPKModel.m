//
//  EveryDayPKModel.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/28.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "EveryDayPKModel.h"

@implementation EveryDayPKModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"PKId",
                                                       @"name": @"name",
                                                       @"unit": @"unit",
                                                       @"picUrl":@"picUrl"
                                                       }];
}


@end
