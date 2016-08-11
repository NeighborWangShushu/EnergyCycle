//
//  EveryDPKPMModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface EveryDPKPMModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *repId;
@property (nonatomic, strong) NSString<Optional> *repItemId;
@property (nonatomic, strong) NSString<Optional> *repItemNum;
@property (nonatomic, strong) NSString<Optional> *orderNum;
@property (nonatomic, strong) NSString<Optional> *repDate;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *photourl;
@property (nonatomic, strong) NSString<Optional> *pkImg;
@property (nonatomic, strong) NSString<Optional> *unit;
@property (nonatomic, strong) NSString<Optional> *haslike;
@property (nonatomic, strong) NSString<Optional> *Goods;
@property (nonatomic, strong) NSString<Optional> *BackgroundImg;

@end
