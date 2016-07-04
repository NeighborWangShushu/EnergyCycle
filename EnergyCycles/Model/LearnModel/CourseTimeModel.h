//
//  CourseTimeModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface CourseTimeModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *timeContent;
@property (nonatomic, strong) NSString<Optional> *timeTitle;


@end
