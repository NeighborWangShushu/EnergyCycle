//
//  PkSummary.h
//  EnergyCycles
//
//  Created by 王斌 on 16/8/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface PkSummaryModel : JSONModel

// 汇报次数
@property (nonatomic, strong) NSString<Optional> *ReportNum;
// 累计天数
@property (nonatomic, strong) NSString<Optional> *AllDayNum;
// 赞总数
@property (nonatomic, strong) NSString<Optional> *Goods;
// 赞排名
@property (nonatomic, strong) NSString<Optional> *GoodsRanking;

@end
