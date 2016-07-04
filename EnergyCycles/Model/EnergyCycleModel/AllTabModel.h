//
//  AllTabModel.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface AllTabModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *enId;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *ordernum;


@end
