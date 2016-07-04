//
//  TheAdvTabModel.m
//  EnergyCycles
//
//  Created by Adinnet on 16/1/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TheAdvTabModel.h"

@implementation TheAdvTabModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"myId",
                                                       @"name": @"name",
                                                       @"ordernum": @"",
                                                       }];
}


@end
