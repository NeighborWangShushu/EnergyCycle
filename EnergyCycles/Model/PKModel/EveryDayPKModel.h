//
//  EveryDayPKModel.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/28.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface EveryDayPKModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *PKId;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *unit;
@property (nonatomic, strong) NSString<Optional> *picUrl;


@end
