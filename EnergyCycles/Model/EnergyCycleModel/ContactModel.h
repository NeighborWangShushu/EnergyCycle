//
//  ContactModel.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface ContactModel : JSONModel

@property (nonatomic,strong) NSString <Optional>*portrait;
@property (nonatomic,strong) NSString <Optional>*name;
@property (nonatomic,strong) NSString <Ignore>*pinyin;//拼音

@end
