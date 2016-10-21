//
//  ShareModel.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject

@property (nonatomic,copy)NSString * title;

@property (nonatomic,copy)NSString * content;

@property (nonatomic,copy)NSString * shareUrl;

@property (nonatomic,strong)NSArray * imgs;

@end
