//
//  PKSelectedModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface PKSelectedModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *myId;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *unit;
@property (nonatomic, strong) NSString<Optional> *picUrl;


@end
