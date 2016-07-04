//
//  JiFenHistoryModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface JiFenHistoryModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *AddTime;
@property (nonatomic, strong) NSString<Optional> *jifen;
@property (nonatomic, strong) NSString<Optional> *jifenType;
@property (nonatomic, strong) NSString<Optional> *recordid;
@property (nonatomic, strong) NSString<Optional> *userid;



@end
