//
//  AttentionAndFansModel.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionAndFansModel : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, assign) NSInteger isHeart;

@end
