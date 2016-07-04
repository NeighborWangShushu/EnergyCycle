//
//  InformationModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface InformationModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *NotifyId;
@property (nonatomic, strong) NSString<Optional> *NotyfiyUserId;
@property (nonatomic, strong) NSString<Optional> *NotifyTitle;
@property (nonatomic, strong) NSString<Optional> *NotifyContent;
@property (nonatomic, strong) NSString<Optional> *NotifyTime;
@property (nonatomic, strong) NSString<Optional> *NotifyType;
@property (nonatomic, strong) NSString<Optional> *NotifyIsRead;
@property (nonatomic, strong) NSString<Optional> *nickname;


@end
