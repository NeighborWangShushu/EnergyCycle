//
//  DraftsModel.h
//  EnergyCycles
//
//  Created by 王斌 on 16/8/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JKDBModel.h"

@interface DraftsModel : JKDBModel

@property (nonatomic, copy) NSString *context;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSArray *imageArr;

@end