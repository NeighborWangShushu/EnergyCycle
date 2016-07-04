//
//  AllTabModel.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AllTabModel.h"

@implementation AllTabModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"enId",
                                                       @"name": @"name",
                                                       @"ordernum": @"ordernum",
                                                       }];
}


@end
