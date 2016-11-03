//
//  OtherReportModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface OtherReportModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *FirstPic;
@property (nonatomic, strong) NSString<Optional> *RI_Name;
@property (nonatomic, strong) NSString<Optional> *RI_Pic;
@property (nonatomic, strong) NSString<Optional> *RI_Unit;
@property (nonatomic, strong) NSString<Optional> *RI_Num;
@property (nonatomic, strong) NSString<Optional> *hasLike;
@property (nonatomic, strong) NSString<Optional> *repItemId;
@property (nonatomic, strong) NSString<Optional> *orderNum;


@end
