//
//  LearnViewShowModel.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LearnViewShowModel.h"

@implementation LearnViewShowModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"TabName": @"TabName",
                                                       @"addTime": @"addTime",
                                                       @"contents": @"contents",
                                                       @"id":@"learnId",
                                                       @"img": @"img",
                                                       @"readCount": @"readCount",
                                                       @"isDel": @"isDel",
                                                       @"studyType":@"studyType",
                                                       @"summary": @"summary",
                                                       @"title": @"title",
                                                       @"GoodCount":@"GoodCount",
                                                       @"BadCount": @"BadCount",
                                                       @"CommentCount": @"CommentCount"
                                                       }];
}


@end
