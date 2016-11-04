//
//  PraiseRankingModel.h
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface PraiseRankingModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *RowNum;
@property (nonatomic, strong) NSString<Optional> *RankingNum;
@property (nonatomic, strong) NSString<Optional> *M_ID;
@property (nonatomic, strong) NSString<Optional> *Goods;
@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *photourl;
@property (nonatomic, strong) NSString<Optional> *RowsCount;

@end
