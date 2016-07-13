//
//  MineHomePageHeadModel.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineHomePageHeadModel : NSObject

/** 昵称 */
@property (nonatomic, copy) NSString *nickname;
/** 姓名 */
@property (nonatomic, copy) NSString *username;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 出生年月 */
@property (nonatomic, copy) NSString *birth;
/** 手机 */
@property (nonatomic, copy) NSString *phone;
/** 邮箱 */
@property (nonatomic, copy) NSString *email;
/** 地址 */
@property (nonatomic, copy) NSString *city;
/** 头像 */
@property (nonatomic, copy) NSString *photourl;
/** 简介 */
@property (nonatomic, copy) NSString *Brief;

@end
