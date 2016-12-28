//
//  SignRankingModel.h
//  EnergyCycles
//
//  Created by 王斌 on 2016/12/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface SignRankingModel : JSONModel

// 用户签到排名
@property (nonatomic, strong) NSString<Optional> *RankNum;
// 签到次数
@property (nonatomic, strong) NSString<Optional> *Num;
// 用户昵称
@property (nonatomic, strong) NSString<Optional> *nickname;
// 用户ID
@property (nonatomic, strong) NSString<Optional> *use_id;
// 头像
@property (nonatomic, strong) NSString<Optional> *photourl;
// 总数
@property (nonatomic, strong) NSString<Optional> *RowsCount;

@end
