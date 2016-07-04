//
//  ServerModel.m
//  EnergyCycles
//
//  Created by Adinnet on 16/1/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ServerModel.h"

@implementation ServerModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"courseId": @"addtime",
                                                       @"serverContent": @"serverContent",
                                                       @"serverTitle": @"serverTitle",
                                                       @"id": @"myId"
                                                       }];
}


@end
