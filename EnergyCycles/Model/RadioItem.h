//
//  RadioItem.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioItem : NSObject

@property (nonatomic,copy)NSString * pic;
@property (nonatomic,copy)NSString * url;
@property (nonatomic)BOOL isPlay;

@property (nonatomic)NSInteger ID;

@end
