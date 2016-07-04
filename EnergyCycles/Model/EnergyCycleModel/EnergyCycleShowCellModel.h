//
//  EnergyCycleShowCellModel.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface EnergyCycleShowCellModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *artId;
@property (nonatomic, strong) NSString<Optional> *artTitle;
@property (nonatomic, strong) NSString<Optional> *artContent;
@property (nonatomic, strong) NSArray<Optional> *artPic;
@property (nonatomic, strong) NSString<Optional> *videoUrl;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *likeNum;
@property (nonatomic, strong) NSString<Optional> *noLikeNum;
@property (nonatomic, strong) NSString<Optional> *commentNum;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *nickName;
@property (nonatomic, strong) NSString<Optional> *photoUrl;
@property (nonatomic, strong) NSArray<Optional> *commentList;

//
@property (nonatomic, strong) NSString<Optional> *commId;
@property (nonatomic, strong) NSString<Optional> *pId;
@property (nonatomic, strong) NSString<Optional> *commContent;
@property (nonatomic, strong) NSString<Optional> *commTime;
@property (nonatomic, strong) NSString<Optional> *commUserId;
@property (nonatomic, strong) NSString<Optional> *commNickName;
@property (nonatomic, strong) NSString<Optional> *commPhotoUrl;


@end
