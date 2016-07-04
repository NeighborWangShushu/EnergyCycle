//
//  EnergyMainModel.h
//  EnergyCycles
//
//  Created by cAnddyyyy on 15/12/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface EnergyMainModel : JSONModel

@property(strong,nonatomic)NSString<Optional>*artId;
@property(strong,nonatomic)NSString<Optional>*artTitle;
@property(strong,nonatomic)NSString<Optional>*artContent;
@property(strong,nonatomic)NSArray<Optional>*artPic;
@property(strong,nonatomic)NSString<Optional>*videoUrl;
@property(strong,nonatomic)NSString<Optional>*createTime;
@property(strong,nonatomic)NSString<Optional>*likeNum;
@property(strong,nonatomic)NSString<Optional>*noLikeNum;
@property(strong,nonatomic)NSString<Optional>*commentNum;
@property(strong,nonatomic)NSString<Optional>*userId;
@property(strong,nonatomic)NSString<Optional>*nickName;
@property(strong,nonatomic)NSString<Optional>*photoUrl;
@property(strong,nonatomic)NSString<Optional>*commentList;
@property(strong,nonatomic)NSString<Optional>*isHasLike;
@property(strong,nonatomic)NSString<Optional>*isHasNoLike;

@property(strong,nonatomic)NSString<Optional>*videoTitle;
@property(strong,nonatomic)NSString<Optional>*videoFirstImg;

@property (nonatomic, strong) NSString<Optional> *oldOrderNumber;
@property (nonatomic, strong) NSString<Optional> *curuserOldOrderNumber;

@property (nonatomic, strong) NSString<Optional> *isTop;


@end
