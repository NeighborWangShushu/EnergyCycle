//
//  TheAdvDetailModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface TheAdvDetailModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *commNum;
@property (nonatomic, strong) NSArray<Optional> *commentOfPost;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *daysHits;
@property (nonatomic, strong) NSString<Optional> *hits;
@property (nonatomic, strong) NSString<Optional> *isHasLike;
@property (nonatomic, strong) NSString<Optional> *nickName;
@property (nonatomic, strong) NSString<Optional> *photoUrl;
@property (nonatomic, strong) NSString<Optional> *postId;
@property (nonatomic, strong) NSArray<Optional> *postPic;
@property (nonatomic, strong) NSString<Optional> *postType;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *videoUrl;


@property (nonatomic, strong) NSString<Optional> *commId;
@property (nonatomic, strong) NSString<Optional> *commPhotoUrl;
@property (nonatomic, strong) NSString<Optional> *pId;
@property (nonatomic, strong) NSString<Optional> *commContent;
@property (nonatomic, strong) NSString<Optional> *commTime;
@property (nonatomic, strong) NSString<Optional> *commUserId;
@property (nonatomic, strong) NSString<Optional> *commNickName;



@end
