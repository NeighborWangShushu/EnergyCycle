//
//  MyPkEveryModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface MyPkEveryModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *pId;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *picUrl;
@property (nonatomic, strong) NSString<Optional> *RI_DATE;
@property (nonatomic, strong) NSString<Optional> *tCount;

@end
