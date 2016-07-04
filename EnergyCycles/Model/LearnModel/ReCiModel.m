//
//  ReCiModel.m
//  EnergyCycles
//
//  Created by Adinnet on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ReCiModel.h"

@implementation ReCiModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"addTime": @"addTime",
                                                       @"rID": @"id",
                                                       @"word": @"word",
                                                       }];
}


@end
