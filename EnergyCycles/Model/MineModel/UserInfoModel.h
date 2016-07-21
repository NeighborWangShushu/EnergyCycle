//
//  UserInfoModel.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface UserInfoModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *FenSiCount;
@property (nonatomic, strong) NSString<Optional> *GuanZhuCount;
@property (nonatomic, strong) NSString<Optional> *IsGuanZhu;
@property (nonatomic, strong) NSString<Optional> *NLQCount;
@property (nonatomic, strong) NSString<Optional> *EveryDayPK;
@property (nonatomic, strong) NSString<Optional> *JinJiePK;
@property (nonatomic, strong) NSString<Optional> *TuiJianCount;
@property (nonatomic, strong) NSString<Optional> *Brief;
@property (nonatomic, strong) NSString<Optional> *MsgCount;

@end
