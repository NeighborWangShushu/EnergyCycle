//
//  MallModel.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface MallModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *RealPrice;
@property (nonatomic, strong) NSString<Optional> *ReferencePrice;
@property (nonatomic, strong) NSString<Optional> *addTime;
@property (nonatomic, strong) NSString<Optional> *counts;
@property (nonatomic, strong) NSString<Optional> *descriptions;
@property (nonatomic, strong) NSString<Optional> *img;
@property (nonatomic, strong) NSString<Optional> *isOnline;
@property (nonatomic, strong) NSString<Optional> *jifen;
@property (nonatomic, strong) NSString<Optional> *merchantType;
@property (nonatomic, strong) NSString<Optional> *merchantid;
@property (nonatomic, strong) NSString<Optional> *name;


@end
