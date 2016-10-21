//
//  ECNavMenuModel.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

@interface ECNavMenuModel : JKDBModel

@property (nonatomic,copy)NSString * name;
@property (nonatomic)NSInteger ID;
@property (nonatomic)BOOL isSelected;

@end
