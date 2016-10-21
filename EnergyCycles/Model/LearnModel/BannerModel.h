//
//  BannerModel.h
//  EnergyCycles
//
//  Created by 王斌 on 16/9/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface BannerModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *ID;
@property (nonatomic, strong) NSString<Optional> *ImageUrl;
// 外链地址
@property (nonatomic, strong) NSString<Optional> *OuterPath;
@property (nonatomic, strong) NSString<Optional> *Order;
@property (nonatomic, strong) NSString<Optional> *Status;
// banner类型 1.外链    2.标签页
@property (nonatomic, strong) NSString<Optional> *Banner_Type;
// 标枪名称
@property (nonatomic, strong) NSString<Optional> *Content;
// banner图展示位置  1.顶部大图  2.下方小图
@property (nonatomic, strong) NSString<Optional> *ShowArea;
@property (nonatomic, strong) NSString<Optional> *Title;

@end
