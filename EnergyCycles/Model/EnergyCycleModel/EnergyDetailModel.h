//
//  EnergyDetailModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface EnergyDetailModel : JSONModel


@property (nonatomic, strong) NSString<Optional> *artContent;
@property (nonatomic, strong) NSString<Optional> *artId;
@property (nonatomic, strong) NSArray<Optional> *artPic;
@property (nonatomic, strong) NSString<Optional> *artTitle;
@property (nonatomic, strong) NSArray<Optional> *commentList;
@property (nonatomic, strong) NSString<Optional> *commentNum;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *isHasLike;
@property (nonatomic, strong) NSString<Optional> *isHasNoLike;
@property (nonatomic, strong) NSString<Optional> *likeNum;
@property (nonatomic, strong) NSString<Optional> *noLikeNum;
@property (nonatomic, strong) NSString<Optional> *nickName;
@property (nonatomic, strong) NSString<Optional> *photoUrl;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *videoUrl;


@property (nonatomic, strong) NSString<Optional> *commId;
@property (nonatomic, strong) NSString<Optional> *pId;
@property (nonatomic, strong) NSString<Optional> *commContent;
@property (nonatomic, strong) NSString<Optional> *commTime;
@property (nonatomic, strong) NSString<Optional> *commUserId;
@property (nonatomic, strong) NSString<Optional> *commNickName;
@property (nonatomic, strong) NSString<Optional> *commPhotoUrl;



@end
