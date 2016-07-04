//
//  LearnCommentModel.m
//  EnergyCycles
//
//  Created by Adinnet on 16/1/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LearnCommentModel.h"

@implementation LearnCommentModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"addtime": @"addtime",
                                                       @"back1": @"back1",
                                                       @"comment": @"comment",
                                                       @"id": @"commID",
                                                       @"nickname": @"nickname",
                                                       @"photourl": @"photourl",
                                                       @"pid": @"pid",
                                                       @"studyId": @"studyId",
                                                       @"use_id": @"use_id",
                                                       @"userid": @"userid"
                                                       }];
}


@end
