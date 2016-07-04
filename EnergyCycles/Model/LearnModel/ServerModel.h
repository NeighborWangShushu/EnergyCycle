//
//  ServerModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface ServerModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *myId;
@property (nonatomic, strong) NSString<Optional> *serverContent;
@property (nonatomic, strong) NSString<Optional> *serverTitle;


@end
