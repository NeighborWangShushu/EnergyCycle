//
//  UserModel.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/28.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface UserModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *use_id;
@property (nonatomic, strong) NSString<Optional> *userguid;
@property (nonatomic, strong) NSString<Optional> *token;
@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *username;
@property (nonatomic, strong) NSString<Optional> *sex;
@property (nonatomic, strong) NSString<Optional> *phone;
@property (nonatomic, strong) NSString<Optional> *email;
@property (nonatomic, strong) NSString<Optional> *city;
@property (nonatomic, strong) NSString<Optional> *birth;
@property (nonatomic, strong) NSString<Optional> *photourl;
@property (nonatomic, strong) NSString<Optional> *xinzuo;
@property (nonatomic, strong) NSString<Optional> *pwd;
@property (nonatomic, strong) NSString<Optional> *powerSource;
@property (nonatomic, strong) NSString<Optional> *poweredSource;

@property (nonatomic, strong) NSString<Optional> *oldName;
@property (nonatomic, strong) NSString<Optional> *oldSex;
@property (nonatomic, strong) NSString<Optional> *oldBirth;
@property (nonatomic, strong) NSString<Optional> *oldPhone;
@property (nonatomic, strong) NSString<Optional> *oldEmail;
@property (nonatomic, strong) NSString<Optional> *oldCity;
@property (nonatomic, strong) NSString<Optional> *OldGrade;
@property (nonatomic, strong) NSString<Optional> *OldState;
@property (nonatomic, strong) NSString<Optional> *VerifyCount;
@property (nonatomic, strong) NSString<Optional> *OldAddress;
@property (nonatomic, strong) NSString<Optional> *OldFatherName;
@property (nonatomic, strong) NSString<Optional> *OldFatherPhone;
@property (nonatomic, strong) NSString<Optional> *OldMotherName;
@property (nonatomic, strong) NSString<Optional> *OldMotherPhone;
@property (nonatomic, strong) NSString<Optional> *OldCount;

@property (nonatomic, strong) NSString<Optional> *jifen;
@property (nonatomic, strong) NSString<Optional> *studyVal;
@property (nonatomic, strong) NSString<Optional> *verifyCode;
@property (nonatomic, strong) NSString<Optional> *user_x;
@property (nonatomic, strong) NSString<Optional> *user_y;
@property (nonatomic, strong) NSString<Optional> *user_registerDate;
@property (nonatomic, strong) NSString<Optional> *isVerify;
@property (nonatomic, strong) NSString<Optional> *isdel;
@property (nonatomic, strong) NSString<Optional> *isEnable;
@property (nonatomic, strong) NSString<Optional> *isOnline;
@property (nonatomic, strong) NSString<Optional> *user_valide;
@property (nonatomic, strong) NSString<Optional> *pkImg;

@property (nonatomic, strong) NSString<Optional> *heartObjectId;
@property (nonatomic, strong) NSString<Optional> *heartUseid;
@property (nonatomic, strong) NSString<Optional> *heartedUseid;
@property (nonatomic, strong) NSString<Optional> *heartTime;

//flag =0 表示未点赞  flag =1 表示已点赞
@property (nonatomic, strong) NSString<Optional> *flag;

//是否彼此关注
@property (nonatomic, strong) NSString<Optional> *isFriend;



@end
