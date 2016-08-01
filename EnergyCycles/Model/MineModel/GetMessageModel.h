//
//  GetMessageModel.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface GetMessageModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *NotifyContent;
@property (nonatomic, strong) NSString<Optional> *NotifyTime;
@property (nonatomic, strong) NSString<Optional> *NotifyIsRead;
@property (nonatomic, strong) NSString<Optional> *A_ID;
@property (nonatomic, strong) NSString<Optional> *A_CONTENT;
@property (nonatomic, strong) NSString<Optional> *use_id;
@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *FirstImg;
@property (nonatomic, strong) NSString<Optional> *RowCounts;

@end
