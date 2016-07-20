//
//  OtherUserModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/3/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface OtherUserModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *nickName;
@property (nonatomic, strong) NSString<Optional> *photoUrl;
@property (nonatomic, strong) NSString<Optional> *isHeart;
@property (nonatomic, strong) NSString<Optional> *Brief;


@end
