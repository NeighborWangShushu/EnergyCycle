//
//  CourseTuiJianModel.m
//  EnergyCycles
//
//  Created by Adinnet on 16/1/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CourseTuiJianModel.h"

@implementation CourseTuiJianModel


+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"BadCount": @"BadCount",
                                                       @"CommentCount": @"CommentCount",
                                                       @"GoodCount": @"GoodCount",
                                                       @"TabName": @"TabName",
                                                       @"addTime": @"addTime",
                                                       @"Video": @"Video",
                                                       @"contents": @"contents",
                                                       @"id": @"courseId",
                                                       @"img": @"img",
                                                       @"isDel": @"isDel",
                                                       @"readCount": @"readCount",
                                                       @"studyType": @"studyType",
                                                       @"summary": @"summary",
                                                       @"title": @"title"
                                                       }];
}



@end
