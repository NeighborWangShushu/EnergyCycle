//
//  LearnCommentModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface LearnCommentModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *addtime;
@property (nonatomic, strong) NSString<Optional> *back1;
@property (nonatomic, strong) NSString<Optional> *comment;
@property (nonatomic, strong) NSString<Optional> *commID;
@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *photourl;
@property (nonatomic, strong) NSString<Optional> *pid;
@property (nonatomic, strong) NSString<Optional> *studyId;
@property (nonatomic, strong) NSString<Optional> *use_id;
@property (nonatomic, strong) NSString<Optional> *userid;



@end
