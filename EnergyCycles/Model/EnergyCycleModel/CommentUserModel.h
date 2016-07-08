//
//  CommentUserModel.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentUserModel : NSObject

@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * url;
@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,assign)BOOL isHeart;

@end
