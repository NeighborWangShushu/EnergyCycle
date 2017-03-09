//
//  RightNavMenuModel.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface RightNavMenuModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *imageName;
@property (nonatomic, strong) NSString<Optional> *title;

@end
