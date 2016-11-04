//
//  RadioModel.h
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface RadioModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *RowsNum;
@property (nonatomic, strong) NSString<Optional> *ID;
@property (nonatomic, strong) NSString<Optional> *Name;
@property (nonatomic, strong) NSString<Optional> *RadioUrl;
@property (nonatomic, strong) NSString<Optional> *ImgUrl;
@property (nonatomic, strong) NSString<Optional> *RowsCount;
@property (nonatomic, strong) NSString<Optional> *Intro;

@end
