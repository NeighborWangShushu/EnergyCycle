//
//  DraftsModel.h
//  EnergyCycles
//
//  Created by 王斌 on 16/8/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JKDBModel.h"

@interface DraftsModel : JKDBModel

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *imgLocalURL;
@property (nonatomic, copy) NSString *contacts;

@end