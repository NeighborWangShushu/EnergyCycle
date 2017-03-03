//
//  PromiseDetailModel.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface PromiseDetailModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *IsFinish; // 是否完成
@property (nonatomic, strong) NSString<Optional> *P_NAME; // 项目名称
@property (nonatomic, strong) NSString<Optional> *P_UNIT; // 数目单位
@property (nonatomic, strong) NSString<Optional> *ProjectID; // 项目ID
@property (nonatomic, strong) NSString<Optional> *ReportDate; // 提交日期
@property (nonatomic, strong) NSString<Optional> *ReportNum; // 每日个数
@property (nonatomic, strong) NSString<Optional> *TargetID; // 目标ID
@property (nonatomic, strong) NSString<Optional> *UserID; // 用户ID

@end
