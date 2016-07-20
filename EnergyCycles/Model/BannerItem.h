//
//  BannerItem.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerItem : NSObject

@property (nonatomic,copy)NSString * url;
@property (nonatomic,strong)NSURL * pic;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,copy)NSString *name;

@end
