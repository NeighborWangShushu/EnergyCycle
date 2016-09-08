//
//  theAdvMainModel.h
//  EnergyCycles
//
//  Created by cAnddyyyy on 16/1/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface TheAdvMainModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *postId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *nickName;
@property (nonatomic, strong) NSString<Optional> *photoUrl;
@property (nonatomic, strong) NSString<Optional> *postType;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *videoUrl;
@property (nonatomic, strong) NSString<Optional> *hits;
@property (nonatomic, strong) NSString<Optional> *commNum;
@property (nonatomic, strong) NSString<Optional> *daysHits;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSArray <Optional> *postPic;
@property (nonatomic, strong) NSString<Optional>*commentOfPost;

@property (nonatomic, strong) NSString<Optional> *videoTitle;
@property (nonatomic, strong) NSString<Optional> *videoFirstImg;

@property (nonatomic, strong) NSString<Optional> *oldOrderNumber;
@property (nonatomic, strong) NSString<Optional> *curuserOldOrderNumber;

@property (nonatomic, strong) NSString<Optional> *isHasLike;


@end
