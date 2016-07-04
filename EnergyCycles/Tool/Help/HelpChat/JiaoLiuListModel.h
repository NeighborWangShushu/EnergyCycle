//
//  JiaoLiuListModel.h
//  TuChuDoc
//
//  Created by Apple on 15/6/15.
//  Copyright (c) 2015年 Lingday. All rights reserved.
//

#import "JSONModel.h"

@interface JiaoLiuListModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *ccid;
@property (nonatomic, strong) NSString<Optional> *mid;
@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *headpic;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *mark;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *createtime;
@property (nonatomic, strong) NSString<Optional> *ismy;
@property (nonatomic, strong) NSString<Optional> *isitself;


@end
