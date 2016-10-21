//
//  MessageModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface MessageModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *MessageContent;
@property (nonatomic, strong) NSString<Optional> *MessageId;
@property (nonatomic, strong) NSString<Optional> *MessageIsRead;
@property (nonatomic, strong) NSString<Optional> *MessagePeople;
@property (nonatomic, strong) NSString<Optional> *MessageTime;
@property (nonatomic, strong) NSString<Optional> *MessageedPeople;
@property (nonatomic, strong) NSString<Optional> *photourl;
@property (nonatomic, strong) NSString<Optional> *UserID;
@property (nonatomic, strong) NSString<Optional> *bImg;
@property (nonatomic, strong) NSString<Optional> *bNickname;
@property (nonatomic, strong) NSString<Optional> *cImg;
@property (nonatomic, strong) NSString<Optional> *cNickname;

@property (nonatomic, strong) NSString<Optional> *nickname;


@end
