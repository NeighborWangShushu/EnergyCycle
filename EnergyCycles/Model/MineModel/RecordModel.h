//
//  RecordModel.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface RecordModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *merchantid;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *img;
@property (nonatomic, strong) NSString<Optional> *ReferencePrice;
@property (nonatomic, strong) NSString<Optional> *RealPrice;
@property (nonatomic, strong) NSString<Optional> *jifen;
@property (nonatomic, strong) NSString<Optional> *counts;
@property (nonatomic, strong) NSString<Optional> *descriptions;
@property (nonatomic, strong) NSString<Optional> *isOnline;
@property (nonatomic, strong) NSString<Optional> *merchantType;
@property (nonatomic, strong) NSString<Optional> *addTime;

@property (nonatomic, strong) NSString<Optional> *ExchangeDate;
@property (nonatomic, strong) NSString<Optional> *expressCode;
@property (nonatomic, strong) NSString<Optional> *expressName;
@property (nonatomic, strong) NSString<Optional> *expressState;
@property (nonatomic, strong) NSString<Optional> *orderCode;
@property (nonatomic, strong) NSString<Optional> *merchantid1;
@property (nonatomic, strong) NSString<Optional> *orderState;
@property (nonatomic, strong) NSString<Optional> *receiveName;
@property (nonatomic, strong) NSString<Optional> *recevieAddress;
@property (nonatomic, strong) NSString<Optional> *receviePhone;
@property (nonatomic, strong) NSString<Optional> *recordid;
@property (nonatomic, strong) NSString<Optional> *userid;

@property (nonatomic, strong) NSString<Optional> *chance;
@property (nonatomic, strong) NSString<Optional> *jifen1;



@end
