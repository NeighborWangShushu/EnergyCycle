//
//  LearnViewShowModel.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface LearnViewShowModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *TabName;
@property (nonatomic, strong) NSString<Optional> *addTime;
@property (nonatomic, strong) NSString<Optional> *contents;
@property (nonatomic, strong) NSString<Optional> *learnId;
@property (nonatomic, strong) NSString<Optional> *img;
@property (nonatomic, strong) NSString<Optional> *isDel;
@property (nonatomic, strong) NSString<Optional> *readCount;
@property (nonatomic, strong) NSString<Optional> *studyType;
@property (nonatomic, strong) NSString<Optional> *summary;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *GoodCount;
@property (nonatomic, strong) NSString<Optional> *BadCount;
@property (nonatomic, strong) NSString<Optional> *CommentCount;
@property (nonatomic, strong) NSString<Optional> *isGood;
@property (nonatomic, strong) NSString<Optional> *isBad;


@end
