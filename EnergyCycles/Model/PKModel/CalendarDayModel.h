//
//  CalendarDayModel.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface CalendarDayModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *IsFinish;
@property (nonatomic, strong) NSString<Optional> *ReportDate;

@end
