//
//  GetPhoneModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface GetPhoneModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *commState;
@property (nonatomic, strong) NSString<Optional> *phone;
@property (nonatomic, strong) NSString<Optional> *token;
@property (nonatomic, strong) NSString<Optional> *userId;


@end
