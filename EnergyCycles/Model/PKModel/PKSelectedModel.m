//
//  PKSelectedModel.m
//  EnergyCycles
//
//  Created by Adinnet on 16/1/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PKSelectedModel.h"

@implementation PKSelectedModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"myId",
                                                       @"name": @"name",
                                                       @"unit": @"unit",
                                                       @"picUrl": @"picUrl",
                                                       }];
}


@end
