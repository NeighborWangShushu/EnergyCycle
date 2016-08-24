//
//  UserModel.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/28.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "UserModel.h"
#import "NSString+Utils.h"

@implementation UserModel

- (void)setNickname:(NSString<Optional> *)name{
    if (name) {
        _nickname=name;
        _pinyin=_nickname.pinyin;
    }
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}

@end
