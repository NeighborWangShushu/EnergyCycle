//
//  CourseTuiJianModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface CourseTuiJianModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *BadCount;
@property (nonatomic, strong) NSString<Optional> *CommentCount;
@property (nonatomic, strong) NSString<Optional> *GoodCount;
@property (nonatomic, strong) NSString<Optional> *TabName;
@property (nonatomic, strong) NSString<Optional> *Video;
@property (nonatomic, strong) NSString<Optional> *addTime;
@property (nonatomic, strong) NSString<Optional> *contents;
@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *img;
@property (nonatomic, strong) NSString<Optional> *isDel;
@property (nonatomic, strong) NSString<Optional> *readCount;
@property (nonatomic, strong) NSString<Optional> *studyType;
@property (nonatomic, strong) NSString<Optional> *summary;
@property (nonatomic, strong) NSString<Optional> *title;


@end
