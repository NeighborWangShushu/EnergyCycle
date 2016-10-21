//
//  BedgeModel.h
//  EnergyCycles
//
//  Created by 王斌 on 16/9/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface BadgeModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *HasNum;
@property (nonatomic, strong) NSString<Optional> *day;
@property (nonatomic, strong) NSString<Optional> *flag;

@end
