//
//  RadioListModel.h
//  EnergyCycles
//
//  Created by 王斌 on 16/8/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface RadioListModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *ID;
@property (nonatomic, strong) NSString<Optional> *Name;
@property (nonatomic, strong) NSString<Optional> *RadioUrl;
@property (nonatomic, strong) NSString<Optional> *ImgUrl;

@end
