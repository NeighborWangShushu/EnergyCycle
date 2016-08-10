//
//  NotifyModel.h
//  EnergyCycles
//
//  Created by 王斌 on 16/8/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface NotifyModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *RowNum;
@property (nonatomic, strong) NSString<Optional> *NotifyId;
@property (nonatomic, strong) NSString<Optional> *NotyfiyUserId;
@property (nonatomic, strong) NSString<Optional> *NotifyTitle;
@property (nonatomic, strong) NSString<Optional> *NotifyContent;
@property (nonatomic, strong) NSString<Optional> *NotifyTime;
@property (nonatomic, strong) NSString<Optional> *NotifyType;
@property (nonatomic, strong) NSString<Optional> *NotifyIsRead;
@property (nonatomic, strong) NSString<Optional> *FromUserID;
@property (nonatomic, strong) NSString<Optional> *SourceID;
@property (nonatomic, strong) NSString<Optional> *SourceName;
@property (nonatomic, strong) NSString<Optional> *RowCounts;

@end
