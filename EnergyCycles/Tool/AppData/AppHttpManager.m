//
//  AppHttpManager.m
//
//

#import "AppHttpManager.h"
#import "SLALertManager.h"



static AFHTTPSessionManager *manager;

@implementation AppHttpManager

#pragma mark - 单例
+ (AppHttpManager *)shareInstance {
    static AppHttpManager *shareNetworkMessage = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareNetworkMessage = [[self alloc] init];
    });
    
    return shareNetworkMessage;
}


+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ca" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

#pragma mark - GET请求
- (void)getDataWithMethod:(NSString *)methodName
          parametersDict:(NSDictionary *)postDict
                 success:(void (^)(NSDictionary *dict))success
                 failure:(void (^)(NSError *errorStr))failure {
    if (manager == nil) {
        manager = [AFHTTPSessionManager manager];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setSecurityPolicy:[AppHttpManager customSecurityPolicy]];
    
    manager.requestSerializer.timeoutInterval=30.0f;
    NSString *str = [NSString stringWithFormat:@"%@/%@",INTERFACE_URL,methodName];
    NSLog(@"url------%@\r type=%@&content=%@",str,[postDict objectForKey:@"types"],[postDict objectForKey:@"content"]);
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    
    [manager GET:str parameters:postDict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responDict = (NSDictionary *)responseObject;
        if ([responDict[@"Code"] integerValue] == 10000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}

#pragma mark - POST请求
- (void)postDataWithMethod:(NSString *)methodName
           parametersDict:(NSDictionary *)postDict
                  success:(void (^)(NSDictionary *dict))success
                  failure:(void (^)(NSError *errorStr))failure {
    if (manager == nil) {
        manager = [AFHTTPSessionManager manager];
    }
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager setSecurityPolicy:[AppHttpManager customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval=30.0f;
    NSString *str = [NSString stringWithFormat:@"%@/%@",INTERFACE_URL,methodName];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    [manager POST:str parameters:postDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responDict = (NSDictionary *)responseObject;
        if ([responDict[@"Code"] integerValue] == 10000) {
            //发送消息,跳转到登录界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];

        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 请求数据
- (void)callInterfaceByUrl:(NSString *)requestUrl
                 PostOrGet:(NSString *)type
                  withDict:(NSDictionary *)postDict
                   success:(void (^)(NSDictionary *dict))success
                   failure:(void (^)(NSString *str))failure {
    if ([type isEqualToString:@"post"]) {
        [self postDataWithMethod:requestUrl
                  parametersDict:postDict
                         success:^(NSDictionary *dict) {
                             success(dict);
                         }
                         failure:^(NSError *errorStr){
                             failure(errorStr.debugDescription);
                         }];
    }else {
        [self getDataWithMethod:requestUrl
                 parametersDict:postDict
                        success:^(NSDictionary *dict) {
                            success(dict);
                        }
                        failure:^(NSError *errorStr) {
                            failure(errorStr.debugDescription);
                        }];
    }
}


#pragma mark - 1.发送短信验证码
//输入参数：phoneno
- (void)postGetCodeWithPhoneNo:(NSString *)phoneno
                     PostOrGet:(NSString *)postOrGetType
                       success:(void (^)(NSDictionary *dict))success
                       failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:phoneno forKey:@"phoneno"];
    
    [self callInterfaceByUrl:GetCode
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 2.注册基本资料
//输入参数：nickname
//输入参数：phoneno
//输入参数：verifyCode
//输入参数：pwd
//输入参数：poweredSource
- (void)getRegisterWithNickname:(NSString *)nickname
                        PhoneNo:(NSString *)phoneno
                     VerifyCode:(NSString *)verifyCode
                            Pwd:(NSString *)pwd
                  PoweredSource:(NSString *)poweredSource
                      PostOrGet:(NSString *)postOrGetType
                        success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:nickname forKey:@"nickname"];
    [dic setObject:phoneno forKey:@"phoneno"];
    [dic setObject:verifyCode forKey:@"verifyCode"];
    [dic setObject:pwd forKey:@"pwd"];
    [dic setObject:poweredSource forKey:@"poweredSource"];
    
    [self callInterfaceByUrl:Register
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 3.登陆
//输入参数：phoneno
//输入参数：password //加密的密码
//输入参数：user_x//经度
//输入参数：user_y//纬度
- (void)getLoginWithPhoneNo:(NSString *)phoneno
                   PassWord:(NSString *)password
                     User_X:(NSString *)user_x
                     User_Y:(NSString *)user_y
                  PostOrGet:(NSString *)postOrGetType
                    success:(void (^)(NSDictionary *dict))success
                    failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:phoneno forKey:@"phoneno"];
    [dic setObject:password forKey:@"password"];
    [dic setObject:user_x forKey:@"user_x"];
    [dic setObject:user_y forKey:@"user_y"];
    
    [self callInterfaceByUrl:Login
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 4.添加大图像
//输入参数：phoneno
//输入参数：img  FileUpload 空间对象的Id
- (void)postAddImgWithPhoneNo:(NSString *)userId
                          Img:(NSData *)imageData
                    PostOrGet:(NSString *)postOrGetType
                      success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userId forKey:@"userId"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@/%@",INTERFACE_URL,AddImg] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageData != nil) {
            [formData appendPartWithFileData:imageData name:@"header" fileName:@"file.jpg" mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.domain);
    }];
    
}

#pragma mark - 5.查询基本资料
//输入参数：userid
- (void)getGetInfoByUseridWithUserid:(NSString *)userid
                           PostOrGet:(NSString *)postOrGetType
                             success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userid forKey:@"userid"];
    
    [self callInterfaceByUrl:GetInfoByUserid
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 6.根据手机号查询个人信息
//输入参数：phone
- (void)getGetUserInfoByPhoneWithPhone:(NSString *)phone
                             PostOrGet:(NSString *)postOrGetType
                               success:(void (^)(NSDictionary *dict))success
                               failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:phone forKey:@"phone"];
    
    [self callInterfaceByUrl:GetUserInfoByPhone
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 7.完善基本资料
//输入参数：nickname
//输入参数：username
//输入参数：sex
//输入参数：birth
//输入参数：phoneno
//输入参数：email
//输入参数：city
- (void)getFinishRegisterWithNickname:(NSString *)nickname
                             Username:(NSString *)username
                                  Sex:(NSString *)sex
                                Birth:(NSString *)birth
                              Phoneno:(NSString *)phoneno
                                Email:(NSString *)email
                                 City:(NSString *)city
                               userId:(int)userId
                                Token:(NSString *)token
                            PostOrGet:(NSString *)postOrGetType
                              success:(void (^)(NSDictionary *dict))success
                              failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:nickname forKey:@"nickname"];
    [dic setObject:username forKey:@"username"];
    [dic setObject:sex forKey:@"sex"];
    [dic setObject:birth forKey:@"birth"];
    [dic setObject:phoneno forKey:@"phoneno"];
    [dic setObject:email forKey:@"email"];
    [dic setObject:city forKey:@"city"];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    
    [self callInterfaceByUrl:FinishRegister
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 8.申请老学员认证
//输入参数：oldName
//输入参数：oldSex
//输入参数：oldBirth
//输入参数：oldPhone
//输入参数：oldEmail
//输入参数：oldCity
//输入参数：OldAddress
//输入参数：OldGrade
//输入参数：OldFatherName
//输入参数：OldFatherPhone
//输入参数：OldMotherName
//输入参数：OldMotherPhone
//输入参数：OldCount
//输入参数：phoneno
- (void)getOldPeopleVerifyWithOldName:(NSString *)oldName
                               OldSex:(NSString *)oldSex
                             OldBirth:(NSString *)oldBirth
                             OldPhone:(NSString *)oldPhone
                             OldEmail:(NSString *)oldEmail
                              OldCity:(NSString *)oldCity
                           OldAddress:(NSString *)OldAddress
                             OldGrade:(NSString *)OldGrade
                        OldFatherName:(NSString *)OldFatherName
                       OldFatherPhone:(NSString *)OldFatherPhone
                        OldMotherName:(NSString *)OldMotherName
                       OldMotherPhone:(NSString *)OldMotherPhone
                             OldCount:(int)OldCount
                              phoneno:(NSString *)phoneno
                               userId:(int)userId
                                Token:(NSString *)token
                            PostOrGet:(NSString *)postOrGetType
                              success:(void (^)(NSDictionary *dict))success
                              failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:oldName forKey:@"oldName"];
    [dic setObject:oldSex forKey:@"oldSex"];
    [dic setObject:oldBirth forKey:@"oldBirth"];
    [dic setObject:oldPhone forKey:@"oldPhone"];
    [dic setObject:oldEmail forKey:@"oldEmail"];
    [dic setObject:oldCity forKey:@"oldCity"];
    [dic setObject:OldAddress forKey:@"OldAddress"];
    [dic setObject:OldGrade forKey:@"OldGrade"];
    [dic setObject:OldFatherName forKey:@"OldFatherName"];
    [dic setObject:OldFatherPhone forKey:@"OldFatherPhone"];
    [dic setObject:OldMotherName forKey:@"OldMotherName"];
    [dic setObject:OldMotherPhone forKey:@"OldMotherPhone"];
    [dic setObject:[NSNumber numberWithInt:OldCount] forKey:@"OldCount"];
    [dic setObject:phoneno forKey:@"phoneno"];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    
    [self callInterfaceByUrl:OldPeopleVerify
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 9.我的消息或者通知
//输入参数：type 通知 或者活动
- (void)getGetMessageWithType:(NSString *)type
                       userid:(int)userid
                    PostOrGet:(NSString *)postOrGetType
                      success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:type forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    
    [self callInterfaceByUrl:GetMessage
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 9-1.我的消息或者通知
//输入参数：NotifyId    int   消息或者通知的id
- (void)getGetMessageDetailWithNotifyId:(NSString *)NotifyId
                              PostOrGet:(NSString *)postOrGetType
                                success:(void (^)(NSDictionary *dict))success
                                failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:NotifyId forKey:@"NotifyId"];
    
    [self callInterfaceByUrl:GetMessageDetail
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 10.我的消息或者通知（待定）

#pragma mark - 11.我的好友
//输入参数：userid
- (void)getBothHeartWithUserid:(NSString *)userid
                     PostOrGet:(NSString *)postOrGetType
                       success:(void (^)(NSDictionary *dict))success
                       failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userid forKey:@"userid"];
    
    [self callInterfaceByUrl:BothHeart
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 12.我的粉丝
//输入参数：userid
- (void)getHeartMeWithUserid:(NSString *)userid
                   PostOrGet:(NSString *)postOrGetType
                     success:(void (^)(NSDictionary *dict))success
                     failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userid forKey:@"userid"];
    
    [self callInterfaceByUrl:HeartMe
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 13.删除粉丝（取消关注）
//输入参数：heartObjectId  关系表的主键id
- (void)getDeleteHeartMeWithHeartObjectId:(NSString *)heartObjectId
                                   userId:(NSString *)userId
                                PostOrGet:(NSString *)postOrGetType
                                  success:(void (^)(NSDictionary *dict))success
                                  failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:heartObjectId forKey:@"useredId"];
    
    [self callInterfaceByUrl:DeleteHeartMe
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 13-1.删除粉丝（取消关注我的人）
//输入参数：userId    //  int 当前登陆人的id
//输入参数：useredId  //  关注我的人的userId（粉丝的id）
- (void)getDeleteMeHeartWithHeartObjectId:(NSString *)heartObjectId
                                   userId:(NSString *)userId
                                PostOrGet:(NSString *)postOrGetType
                                  success:(void (^)(NSDictionary *dict))success
                                  failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:heartObjectId forKey:@"useredId"];
    
    [self callInterfaceByUrl:DeleteMeHeart
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 14.我关注的人的列表
//输入参数：userid
- (void)getMyHeartWithUserid:(NSString *)userid
                   PostOrGet:(NSString *)postOrGetType
                     success:(void (^)(NSDictionary *dict))success
                     failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userid forKey:@"userid"];
    
    [self callInterfaceByUrl:MyHeart
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 15.获取积分列表
//输入参数：page 当前页 默认传入 1 代表第1页，滑动一下传2 ，类似 ，3,4
- (void)getGetJiFenListWithPage:(int)page
                     withUserId:(int)userId
                      PostOrGet:(NSString *)postOrGetType
                        success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    
    [self callInterfaceByUrl:GetJiFenList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 15-1.根据userid获取积分列表
//输入参数：userid  int 用户id
//输入参数：page 当前页 默认传入 1 代表第1页，滑动一下传2 ，类似 ，3,4
- (void)getGetJiFenListByUseridWithUserid:(int)userid
                                     Page:(int)page
                                PostOrGet:(NSString *)postOrGetType
                                  success:(void (^)(NSDictionary *dict))success
                                  failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    
    [self callInterfaceByUrl:GetJiFenListByUserid
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 16.获取商城商品列表
//输入参数：page 当前页 默认传入 1 代表第1页，滑动一下传2 ，类似 ，3,4
- (void)getGetMerchantListWithPage:(int)page
                         PostOrGet:(NSString *)postOrGetType
                           success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    
    [self callInterfaceByUrl:GetMerchantList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 17.兑换记录列表
//输入参数：userid  类型 int
- (void)getGetExchangeRecordListWithUserid:(int)userid
                                 PostOrGet:(NSString *)postOrGetType
                                   success:(void (^)(NSDictionary *dict))success
                                   failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    
    [self callInterfaceByUrl:GetExchangeRecordList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 18.兑换记录详情
//输入参数：recordid  类型 int
- (void)getGetExchangeRecordListWithRecordid:(int)recordid
                                   PostOrGet:(NSString *)postOrGetType
                                     success:(void (^)(NSDictionary *dict))success
                                     failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:recordid] forKey:@"recordid"];
    
    [self callInterfaceByUrl:GetExchangeRecordDetail
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 19.我的建议
//输入参数：userid类型 int
//输入参数：contents 建议内容 类型 string
- (void)getMySuggestionWithUserid:(int)userid
                         Contents:(NSString *)contents
                        PostOrGet:(NSString *)postOrGetType
                          success:(void (^)(NSDictionary *dict))success
                          failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:contents forKey:@"contents"];
    
    [self callInterfaceByUrl:MySuggestion
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 20.商品兑换
//输入参数：userid类型 int
//输入参数：merchantId 商品id 类型 int
//输入参数：name 收件人姓名 类型 string
//输入参数：phoneno手机 类型 string
//输入参数：address地址 类型 string
- (void)getdoExchangeWithUserid:(int)userid
                     merchantId:(int)merchantId
                           name:(NSString *)name
                        Phoneno:(NSString *)phoneno
                        Address:(NSString *)address
                      PostOrGet:(NSString *)postOrGetType
                        success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:merchantId] forKey:@"merchantId"];
    [dic setObject:name forKey:@"name"];
    [dic setObject:phoneno forKey:@"phoneno"];
    [dic setObject:address forKey:@"address"];
    
    [self callInterfaceByUrl:doExchange
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 21.商品抽奖
//输入参数：userid   //类型 int
//输入参数：merchantId //商品id 类型 int
- (void)getdoChouJiangWithUserid:(int)userid
                      merchantId:(int)merchantId
                       PostOrGet:(NSString *)postOrGetType
                         success:(void (^)(NSDictionary *dict))success
                         failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:merchantId] forKey:@"merchantId"];
    
    [self callInterfaceByUrl:doChouJiang
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 21-1.商品抽奖成功，填写收货人信息 调用的接口
//输入参数：userid   //类型 int
//输入参数：merchantId //商品id 类型 int
//输入参数：name //收件人姓名 类型 string
//输入参数：phoneno  //手机 类型 string
//输入参数：address   //地址 类型 string
- (void)getdoChouJiangRecordWithUserid:(int)userid
                            merchantId:(int)merchantId
                                  name:(NSString *)name
                               Phoneno:(NSString *)phoneno
                               Address:(NSString *)address
                             PostOrGet:(NSString *)postOrGetType
                               success:(void (^)(NSDictionary *dict))success
                               failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:merchantId] forKey:@"merchantId"];
    [dic setObject:name forKey:@"name"];
    [dic setObject:phoneno forKey:@"phoneno"];
    [dic setObject:address forKey:@"address"];
    
    [self callInterfaceByUrl:doChouJiangRecord
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 22.积分赠送
//输入参数：userid类型 int
//输入参数：useredId 被赠送人id 类型 int
//输入参数：jifen 积分数量  类型 int
- (void)getSendJifenWithUserid:(int)userid
                  withUseredId:(int)useredId
                         Jifen:(int)jifen
                     PostOrGet:(NSString *)postOrGetType
                       success:(void (^)(NSDictionary *dict))success
                       failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:useredId] forKey:@"useredId"];
    [dic setObject:[NSNumber numberWithInt:jifen] forKey:@"jifen"];
    
    [self callInterfaceByUrl:SendJifen
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 23.找回密码
//输入参数：phoneNo  //手机号 string
//输入参数：verifyCode// 验证码 string
//输入参数：pwd//新密码 string
- (void)getFindPwdWithPhoneNo:(NSString *)phoneNo
                   verifyCode:(NSString *)verifyCode
                          pwd:(NSString *)pwd
                    PostOrGet:(NSString *)postOrGetType
                      success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:phoneNo forKey:@"phoneNo"];
    [dic setObject:verifyCode forKey:@"verifyCode"];
    [dic setObject:pwd forKey:@"pwd"];
    
    [self callInterfaceByUrl:FindPwd
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 24.找回密码发送验证码
//输入参数：phoneNo  //手机号  类型 string
- (void)getSendPwdCodeWithPhoneNo:(NSString *)phoneNo
                        PostOrGet:(NSString *)postOrGetType
                          success:(void (^)(NSDictionary *dict))success
                          failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:phoneNo forKey:@"phoneNo"];
    
    [self callInterfaceByUrl:SendPwdCode
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 25.添加发送私信
//输入参数：userId     		//发送人id    类型 int
//输入参数：useredId		//接受人id    类型 int
//输入参数：content		//积分数量     类型 int
- (void)getAddMessageWithUserid:(int)userId
                   withUseredId:(int)useredId
                        content:(NSString *)content
                      PostOrGet:(NSString *)postOrGetType
                        success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:[NSNumber numberWithInt:useredId] forKey:@"useredId"];
    [dic setObject:content forKey:@"content"];
    
    [self callInterfaceByUrl:AddMessage
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 26.获取2个人的对话列表
//输入参数：userId     		//发送人id    类型 int
//输入参数：useredId		//接受人id    类型 int
- (void)getGetTalkListWithUserid:(int)userId
                    withUseredId:(int)useredId
                       PostOrGet:(NSString *)postOrGetType
                         success:(void (^)(NSDictionary *dict))success
                         failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:[NSNumber numberWithInt:useredId] forKey:@"useredId"];
    
    [self callInterfaceByUrl:GetTalkList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 27.获取私信列表
//输入参数：userId     		//用户id
- (void)getGetTopOnePeopleWithUserid:(int)userId
                           PostOrGet:(NSString *)postOrGetType
                             success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    
    [self callInterfaceByUrl:GetTopOnePeople
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 28.查询我的积分排名
//输入参数：userId     		//用户id
- (void)getGetJinfenCountWithUserid:(int)userId
                          PostOrGet:(NSString *)postOrGetType
                            success:(void (^)(NSDictionary *dict))success
                            failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    
    [self callInterfaceByUrl:GetJinfenCount
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 28-1.查询我的学习值排名
//输入参数：userId     		//用户id
- (void)getGetMyStudyValCountWithUserid:(int)userId
                              PostOrGet:(NSString *)postOrGetType
                                success:(void (^)(NSDictionary *dict))success
                                failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    
    [self callInterfaceByUrl:GetMyStudyValCount
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 29.我的粉丝
//输入参数：userId     		//用户id
- (void)getGetfensiCountWithUserid:(int)userId
                         PostOrGet:(NSString *)postOrGetType
                           success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    
    [self callInterfaceByUrl:GetfensiCount
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 30.我关注的人的数量
//输入参数：userId     		//用户id
- (void)getGetGuanzhuCountWithUserid:(int)userId
                           PostOrGet:(NSString *)postOrGetType
                             success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    
    [self callInterfaceByUrl:GetGuanzhuCount
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 30-1.其他人信息界面
//输入参数：userId     		//当前登陆人的用户id
//输入参数：useredId		//被查询数据的用户的id
- (void)getGetPeopleDataInfoWithUserid:(int)userId
                              UseredId:(int)useredId
                             PostOrGet:(NSString *)postOrGetType
                               success:(void (^)(NSDictionary *dict))success
                               failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:[NSNumber numberWithInt:useredId] forKey:@"useredId"];
    
    [self callInterfaceByUrl:GetPeopleDataInfo
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 30-2.获取我的推荐的人列表
//输入参数：userId     		//当前登陆人的用户id
- (void)getGetMyTuiJianListWithUserid:(int)userId
                            PostOrGet:(NSString *)postOrGetType
                              success:(void (^)(NSDictionary *dict))success
                              failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    
    [self callInterfaceByUrl:GetMyTuiJianList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}




#pragma mark - 31.学习文章列表 最新 最热 精选 课程 4 个
//输入参数：tabName类型 string   最新 最热 精选 课程 4 个 4 选一
- (void)getGetStudyListByTabWithTabName:(NSString *)tabName
                              PostOrGet:(NSString *)postOrGetType
                                  useId:(int)userID
                               withPage:(int)pageIndex
                               withSize:(int)pageSize
                                success:(void (^)(NSDictionary *dict))success
                                failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:tabName forKey:@"tabName"];
    [dic setObject:[NSNumber numberWithInt:userID] forKey:@"userId"];
    [dic setObject:[NSNumber numberWithInt:pageIndex] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    [self callInterfaceByUrl:GetStudyListByTab
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 32.学习文章列表 最新 最热 精选 课程 4 个
//输入参数：id 类型 int   文章id
- (void)getGetStudyDetailByIdWithId:(int)wenzhangID
                          PostOrGet:(NSString *)postOrGetType
                            success:(void (^)(NSDictionary *dict))success
                            failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:wenzhangID] forKey:@"id"];
    
    [self callInterfaceByUrl:GetStudyDetailById
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 33.学霸榜列表
//输入参数：userId   int  //当前登陆人的userid
- (void)getGetStudyGoodListWithUserId:(NSString *)userId
                            PostOrGet:(NSString *)postOrGetType
                              success:(void (^)(NSDictionary *dict))success
                              failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userId forKey:@"userId"];
    
    [self callInterfaceByUrl:GetStudyGoodList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 34.课程详情里面的相关推荐 3条
//输入参数：studyType string类型  课程文章 所属的类型  APP_studyType 表里的信息
- (void)getGetAboutCourseListWithStudyType:(NSString *)studyType
                                 PostOrGet:(NSString *)postOrGetType
                                   success:(void (^)(NSDictionary *dict))success
                                   failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:studyType forKey:@"studyType"];
    
    [self callInterfaceByUrl:GetAboutCourseList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 35.课程报名
//输入参数：courseId    int   课程id
//输入参数：people       string  填表人
//输入参数：courseTime   string  课程时间
//输入参数：coursePath   string  获取途径
//输入参数：courseServer  string 增值服务
//输入参数：back			string 备注
//输入参数：stuName		string  姓名
//输入参数：stuSex			string  性别   男 或者女
//输入参数：stuBirth		string  生日  格式：‘1990-909-09’
//输入参数：stuPhone		string 手机
//输入参数：stuEmail		string 邮件
//输入参数：stuCity		string 城市
//输入参数：stuAddress		string 地址
//输入参数：stuGrade		string 班级
//输入参数：stuFatherName	string 父亲名字
//输入参数：stuFatherPhone string 父亲电话
//输入参数：stuMotherName string  母亲名字
//输入参数：stuMotherPhone string  母亲手机
- (void)getGetStudyGoodListWithPeople:(NSString *)people
                             courseId:(int)courseId
                           CourseTime:(NSString *)courseTime
                           CoursePath:(NSString *)coursePath
                         CourseServer:(NSString *)courseServer
                                 Back:(NSString *)back
                              StuName:(NSString *)stuName
                               StuSex:(NSString *)stuSex
                             StuBirth:(NSString *)stuBirth
                             StuPhone:(NSString *)stuPhone
                             StuEmail:(NSString *)stuEmail
                              StuCity:(NSString *)stuCity
                           StuAddress:(NSString *)stuAddress
                             StuGrade:(NSString *)stuGrade
                        StuFatherName:(NSString *)stuFatherName
                       StuFatherPhone:(NSString *)stuFatherPhone
                        StuMotherName:(NSString *)stuMotherName
                       StuMotherPhone:(NSString *)stuMotherPhone
                            PostOrGet:(NSString *)postOrGetType
                              success:(void (^)(NSDictionary *dict))success
                              failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:people forKey:@"people"];
    [dic setObject:[NSNumber numberWithInt:courseId] forKey:@"courseId"];
    [dic setObject:courseTime forKey:@"courseTime"];
    [dic setObject:coursePath forKey:@"coursePath"];
    [dic setObject:courseServer forKey:@"courseServer"];
    [dic setObject:back forKey:@"back"];
    [dic setObject:stuName forKey:@"stuName"];
    [dic setObject:stuSex forKey:@"stuSex"];
    [dic setObject:stuBirth forKey:@"stuBirth"];
    [dic setObject:stuPhone forKey:@"stuPhone"];
    [dic setObject:stuEmail forKey:@"stuEmail"];
    [dic setObject:stuCity forKey:@"stuCity"];
    [dic setObject:stuAddress forKey:@"stuAddress"];
    [dic setObject:stuGrade forKey:@"stuGrade"];
    [dic setObject:stuFatherName forKey:@"stuFatherName"];
    [dic setObject:stuFatherPhone forKey:@"stuFatherPhone"];
    [dic setObject:stuMotherName forKey:@"stuMotherName"];
    [dic setObject:stuMotherPhone forKey:@"stuMotherPhone"];
    
    [self callInterfaceByUrl:GetAddStudyInfo
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 36.学习版块搜索
//输入参数：types     1：按照分类   2：按照标题
//输入参数：content   分类名称 或者 标题名称
- (void)getSearchWithTypes:(NSString *)types
               withContent:(NSString *)content
                 PostOrGet:(NSString *)postOrGetType
                   success:(void (^)(NSDictionary *dict))success
                   failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:2];
    [dic setObject:types forKey:@"types"];
    [dic setObject:content forKey:@"content"];
    
    [self callInterfaceByUrl:Search
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 37.学霸点赞
//输入参数：userId   int //主动点赞的人
//输入参数：useredId  int //被点赞的人
- (void)getSendGoodWithUserId:(int)userId
                 withUseredId:(int)useredId
                    PostOrGet:(NSString *)postOrGetType
                      success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:[NSNumber numberWithInt:useredId] forKey:@"useredId"];
    
    [self callInterfaceByUrl:SendGood
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 38.学习版块搜索分类
- (void)getGetStudyTypeWithPostOrGet:(NSString *)postOrGetType
                             success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    
    [self callInterfaceByUrl:GetStudyType
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 39.课程时间列表
//输入参数：courseId int 课程id
- (void)getGetcourseTimeByIdWithcourseId:(int)courseId
                               PostOrGet:(NSString *)postOrGetType
                                 success:(void (^)(NSDictionary *dict))success
                                 failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:courseId] forKey:@"courseId"];
    
    [self callInterfaceByUrl:GetcourseTimeById
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 40.增值服务列表
//输入参数：courseId int 课程id
- (void)getGetcourseServerByIdWithCourseId:(int)courseId
                                 PostOrGet:(NSString *)postOrGetType
                                   success:(void (^)(NSDictionary *dict))success
                                   failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:courseId] forKey:@"courseId"];
    
    [self callInterfaceByUrl:GetcourseServerById
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 41.获取学习模块tab项
- (void)getGetStudyTabListWithPostOrGet:(NSString *)postOrGetType
                                success:(void (^)(NSDictionary *dict))success
                                failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    
    [self callInterfaceByUrl:GetStudyTabList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 42.学习模块点赞和踩
//type	true	int	类型（1-点赞，2-踩）
//articleId	true	int	文章id
//userId	true	int	用户id
//token	true	string	用户token
- (void)getStudyAddLikeOrNoLikeWithType:(int)type
                              articleId:(int)articleId
                                 userId:(int)userId
                                  token:(NSString *)token
                              PostOrGet:(NSString *)postOrGetType
                                success:(void (^)(NSDictionary *dict))success
                                failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:articleId] forKey:@"articleId"];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    
    [self callInterfaceByUrl:StudyAddLikeOrNoLike
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 43.获取热门搜索关键词列表
- (void)getGetHotSearchWithPostOrGet:(NSString *)postOrGetType
                             success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    
    [self callInterfaceByUrl:GetHotSearch
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 45.获取商品详细的页面
//参数：id    int   商品id
//链接直接获取

#pragma mark - 46.获取学习版本的新闻 详情页面
//输入参数：id    int   学习文章的id
//链接直接获取

#pragma mark - 47.添加学习版块的评论
//输入参数：userId   int //登陆人的id
//输入参数：studyId  int // 评论文章的id
//输入参数：pid      int//父级评论id，若为第一次评论，则传0
//输入参数：commnet  string //评论的内容
- (void)getAddCommnetWithUserId:(int)userId
                        StudyId:(int)studyId
                            Pid:(int)pid
                        Commnet:(NSString *)commnet
                      PostOrGet:(NSString *)postOrGetType
                        success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:[NSNumber numberWithInt:studyId] forKey:@"studyId"];
    [dic setObject:[NSNumber numberWithInt:pid] forKey:@"pid"];
    [dic setObject:commnet forKey:@"commnet"];
    
    [self callInterfaceByUrl:AddCommnet
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 48.根据学习版块的文章id 获取此文章的评论列表
//输入参数：studyId   int //文章id
- (void)getGetStudyCommentListWithStudyId:(int)studyId
                                PostOrGet:(NSString *)postOrGetType
                                  success:(void (^)(NSDictionary *dict))success
                                  failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:studyId] forKey:@"studyId"];
    
    [self callInterfaceByUrl:GetStudyCommentList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 49.获取活动详细的 h5 页面
//访问方式get
//参数：id   --int类型  活动id（NotifyId）
//链接直接获取

#pragma mark - 49-1.获取文章的点赞的条数和评论的条数，以及是否赞和踩
//输入参数：userId   int //登陆人的id
//输入参数：studyId  int // 文章的id
- (void)getGetStudyInfoByIdWithUserId:(int)userId
                              StudyId:(int)studyId
                            PostOrGet:(NSString *)postOrGetType
                              success:(void (^)(NSDictionary *dict))success
                              failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:studyId] forKey:@"studyId"];
    
    [self callInterfaceByUrl:GetStudyInfoById
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];

}



#pragma mark - 50.获取能量圈列表
//请求参数：
//type  // 1-最新 2-最热 3-精选 4-关注
//userid  //用户id  (当type=4的时候需要传)
//token   //用户token     (当type=4的时候需要传)
//pageIndex  //页码
//pageSize   //每页显示数
- (void)getGetArticleListWithType:(NSString *)type
                           Userid:(NSString *)userid
                            Token:(NSString *)token
                        PageIndex:(NSString *)pageIndex
                         PageSize:(NSString *)pageSize
                        PostOrGet:(NSString *)postOrGetType
                          success:(void (^)(NSDictionary *dict))success
                          failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:type forKey:@"type"];
    [dic setObject:userid forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:pageIndex forKey:@"pageIndex"];
    [dic setObject:pageSize forKey:@"pageSize"];
    
    [self callInterfaceByUrl:GetArticleList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 51.获取某个能量圈的详情
//请求参数：
//ArticleId  //能量圈id
//userId	true	int	当前用户id
//token	true	string	当前用户token
- (void)getGetArticleInfoByIdWithArticleId:(NSString *)ArticleId
                                    userId:(int)userId
                                     token:(NSString *)token
                                 PostOrGet:(NSString *)postOrGetType
                                   success:(void (^)(NSDictionary *dict))success
                                   failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:ArticleId forKey:@"ArticleId"];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    
    [self callInterfaceByUrl:GetArticleInfoById
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 52.添加能量圈评论回复
//请求参数
//int ArticleId  //文章id
//int PId  //若为回复，代表父级评论id，若为第一次评论，则传0
//string Content   //评论内容
//int CommUserId  //评论人id
//string token  //评论人的token
- (void)postAddCommentOfArticleWithArticleId:(int)ArticleId
                                         PId:(int)PId
                                     Content:(NSString *)Content
                                  CommUserId:(int)CommUserId
                                        type:(NSString *)type
                                       token:(NSString *)token
                                   PostOrGet:(NSString *)postOrGetType
                                     success:(void (^)(NSDictionary *dict))success
                                     failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:ArticleId] forKey:@"Id"];
    [dic setObject:[NSNumber numberWithInt:PId] forKey:@"pId"];
    [dic setObject:Content forKey:@"content"];
    [dic setObject:[NSNumber numberWithInt:CommUserId] forKey:@"commUserId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:type forKey:@"type"];
    
    [self callInterfaceByUrl:AddCommentOfArticle
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 53.发布能量圈
//请求参数：
//string Title  //标题
//string Content  //内容
//string VideoUrl  //视频地址
//int UserId  //发布人id
//string token   //发布人token
//List<String> ArticlePic //图片
//location      地点
//list          提醒人的列表

- (void)postAddArticleWithTitle:(NSString *)Title
                        Content:(NSString *)Content
                       VideoUrl:(NSString *)VideoUrl
                         UserId:(int)UserId
                          token:(NSString *)token
                           List:(NSArray *)list
                       Location:(NSString *)location
                       UserList:(NSArray *)userlist
                      PostOrGet:(NSString *)postOrGetType
                        success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:Title forKey:@"title"];
    [dic setObject:Content forKey:@"content"];
    [dic setObject:VideoUrl forKey:@"videoUrl"];
    [dic setObject:[NSNumber numberWithInt:UserId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSArray arrayWithArray:list] forKey:@"articlePic"];
    [dic setObject:location forKey:@"Location"];
    [dic setObject:[NSArray arrayWithArray:userlist] forKey:@"UserList"];

    
    [self callInterfaceByUrl:AddArticle
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 54.能量圈点赞和踩
//请求参数：
//int type  //类型（1-点赞，2-踩）
//int ArticleId  //文章id
//int UserId   //用户id
//string token  //用户token
- (void)postAddLikeOrNoLikeWithType:(NSString *)type
                            OpeType:(NSString *)opeType
                          ArticleId:(int)articleId
                             UserId:(int)userId
                              token:(NSString *)token
                          PostOrGet:(NSString *)postOrGetType
                            success:(void (^)(NSDictionary *dict))success
                            failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:type forKey:@"type"];
    [dic setObject:opeType forKey:@"opeType"];
    [dic setObject:[NSNumber numberWithInt:articleId] forKey:@"articleId"];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    
    [self callInterfaceByUrl:AddLikeOrNoLike
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 55.能量圈签到
//请求参数：
//int UserId  //签到人的id
//string token  //签到人的token
- (void)postArticleSignWithUserId:(int)UserId
                            Token:(NSString *)token
                        PostOrGet:(NSString *)postOrGetType
                          success:(void (^)(NSDictionary *dict))success
                          failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:UserId] forKey:@"UserId"];
    [dic setObject:token forKey:@"token"];
    
    [self callInterfaceByUrl:ArticleSign
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                             NSInteger integral = [dict[@"Data"] integerValue];
                             switch (integral) {
                                 case 10:
                                     [[SLALertManager shareManager] showAlert:SLScroeTypeTen];
                                     break;
                                 case 20:
                                     [[SLALertManager shareManager] showAlert:SLScroeTypeTwenty];
                                     break;
                                 case 30:
                                     [[SLALertManager shareManager] showAlert:SLScroeTypeThirty];
                                     break;
                                 case 40:
                                     [[SLALertManager shareManager] showAlert:SLScroeTypeForty];
                                     break;
                                 default:
                                     break;
                             }
                         }
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 56.获取本月已签到数据
//请求参数：
//userid  //签到人的id
//token  //签到人的token
- (void)getGetSignInfoWithUserid:(NSString *)userid
                           token:(NSString *)token
                       PostOrGet:(NSString *)postOrGetType
                         success:(void (^)(NSDictionary *dict))success
                         failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userid forKey:@"userid"];
    [dic setObject:token forKey:@"token"];
    
    [self callInterfaceByUrl:GetSignInfo
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 57.获取能量圈tab顺序
- (void)getGetTabOfArticleWithPostOrGet:(NSString *)postOrGetType
                                success:(void (^)(NSDictionary *dict))success
                                failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    
    [self callInterfaceByUrl:GetTabOfArticle
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}



#pragma mark - 58.获取pk广告
- (void)getGetADVWithPostOrGet:(NSString *)postOrGetType
                       success:(void (^)(NSDictionary *dict))success
                       failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    
    [self callInterfaceByUrl:GetADV
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 59.每日pk-获取下拉项目
- (void)getGetProjectWithPostOrGet:(NSString *)postOrGetType
                           success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    
    [self callInterfaceByUrl:GetProject
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 60.每日pk-项目汇报
//请求body：
//int userId  //汇报人的id
//string token  //汇报人的token
//List<ReportItem> reportItem  //汇报项目的集合
//List<String> reportPic  //汇报的图片地址
//
//ReportItem：
//int projectId //汇报项目的id
//int reportNum  //汇报项目的数量
- (void)getAddReportWithUserid:(NSString *)userId
                         Token:(NSString *)token
                    ReportList:(NSArray *)reportList
                     ImageList:(NSArray *)imageList
                     PostOrGet:(NSString *)postOrGetType
                       success:(void (^)(NSDictionary *dict))success
                       failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:reportList forKey:@"reportItem"];
    [dic setObject:imageList forKey:@"reportPic"];
    
    [self callInterfaceByUrl:AddReport
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 61.每日pk-获取排名列表
//userId  //用户id
//token   //用户token
//projectId  //项目id
//pageInex   //页码
//pageSize  //每页显示数
- (void)getGetReportListWithUserid:(NSString *)userId
                             Token:(NSString *)token
                         projectId:(NSString *)projectId
                          pageInex:(int)pageInex
                          pageSize:(int)pageSize
                         PostOrGet:(NSString *)postOrGetType
                           success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:projectId forKey:@"projectId"];
    [dic setObject:[NSNumber numberWithInt:pageInex] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    [self callInterfaceByUrl:GetReportList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 62.每日pk-点赞
//int type   //类型 1-点赞 2-取消点赞
//int userId  //当前用户id
//string token  //当前用户token
//int repItemId  //点赞项目的id
- (void)getZanReportItemWithType:(int)type
                          UserId:(int)userId
                           Token:(NSString *)token
                       RepItemId:(int)repItemId
                       PostOrGet:(NSString *)postOrGetType
                         success:(void (^)(NSDictionary *dict))success
                         failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInt:repItemId] forKey:@"repItemId"];
    
    [self callInterfaceByUrl:ZanReportItem
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 63.每日pk-获取某个人的当天汇报项目情况
//userId   //当前用户的id
//token    //当前用户的token
//oUserId  //要找的用户的id
- (void)getGetReportByUserWithUserid:(int)userId
                               Token:(NSString *)token
                             OUserId:(int)oUserId
                           PostOrGet:(NSString *)postOrGetType
                             success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInt:oUserId] forKey:@"oUserId"];
    
    [self callInterfaceByUrl:GetReportByUser
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 64.每日pk-添加/取消关注
//int type  //类型  1-添加关注 2-取消关注
//int userId  //当前用户的id
//string token  //当前用户的token
//int oUserId  //被关注或取消的用户的id
- (void)getAddOrCancelFriendWithType:(int)type
                              UserId:(int)userId
                               Token:(NSString *)token
                             OUserId:(int)oUserId
                           PostOrGet:(NSString *)postOrGetType
                             success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInt:oUserId] forKey:@"oUserId"];
    
    [self callInterfaceByUrl:AddOrCancelFriend
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 65.进阶pk-获取tab顺序
- (void)getGetTabOfPostWithPostOrGet:(NSString *)postOrGetType
                             success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    
    [self callInterfaceByUrl:GetTabOfPost
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 66.进阶pk-发布进阶pk时获取分类
- (void)getGetPostTypeWithPostOrGet:(NSString *)postOrGetType
                            success:(void (^)(NSDictionary *dict))success
                            failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    
    [self callInterfaceByUrl:GetPostType
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 67.进阶pk-发布进阶pk帖子
//postTypeId	true	int	类别id
//title	true	string	标题
//content	true	string	内容
//videoUrl	false	string	视频地址
//userId	true	int	发布人id
//token	true	string	发布人token
//postPic	false	List<String>	图片地址
- (void)getAddPostWithPostTypeId:(int)postTypeId
                           Title:(NSString *)title
                         Content:(NSString *)content
                        videoUrl:(NSString *)videoUrl
                          userId:(int)userId
                           token:(NSString *)token
                         postPic:(NSArray *)list
                       PostOrGet:(NSString *)postOrGetType
                         success:(void (^)(NSDictionary *dict))success
                         failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:postTypeId] forKey:@"postTypeId"];
    [dic setObject:title forKey:@"title"];
    [dic setObject:content forKey:@"content"];
    [dic setObject:videoUrl forKey:@"videoUrl"];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:list forKey:@"postPic"];
    
    [self callInterfaceByUrl:AddPost
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 68.进阶pk-获取进阶pk列表，包括本月奖品
//userId	false	int	用户id(type=7时需传)
//token	false	string	用户token(type=7时需传)
//type	true	int	类型（5-排行榜 6-最新 7-关注）
//pageIndex	true	int	页码
//pageSize	true	int	每页显示多少条
- (void)getGetPostListWithUserId:(int)userId
                           Token:(NSString *)token
                            Type:(int)type
                       pageIndex:(int)pageIndex
                        pageSize:(int)pageSize
                       PostOrGet:(NSString *)postOrGetType
                         success:(void (^)(NSDictionary *dict))success
                         failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:pageIndex] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    [self callInterfaceByUrl:GetPostList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 69.进阶pk-查看帖子详情
//userId	true	int	用户id
//token	true	string	用户token
//postId	true	int	帖子id
- (void)getGetPostInfoByIdWithUserId:(int)userId
                               Token:(NSString *)token
                              PostId:(int)postId
                           PostOrGet:(NSString *)postOrGetType
                             success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInt:postId] forKey:@"postId"];
    
    [self callInterfaceByUrl:GetPostInfoById
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 70.进阶pk-对帖子点赞
//接口请求参数
//把参数直接放到Body里面（Json格式）
//必选	类型及范围	说明
//type	true	int	类型（1-点赞）
//articleId	true	int	文章id
//userId	true	int	用户id
//token	true	string	用户token
- (void)getPKAddLikeOrNoLikeWithType:(int)type
                           ArticleId:(int)articleId
                              UserId:(NSString *)userId
                               Token:(NSString *)token
                           PostOrGet:(NSString *)postOrGetType
                             success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:articleId] forKey:@"articleId"];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    
    [self callInterfaceByUrl:PKAddLikeOrNoLike
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 71.进阶pk-添加帖子评论
//Id	true	int	帖子id
//pId	true	int	父级评论id，若为第一次评论，则传0
//content	true	string	评论内容
//commUserId	true	int	评论人id
//token	true	string	评论人的token
- (void)getAddCommentOfPostWithId:(int)Id
                              pId:(int)pId
                          content:(NSString *)content
                       commUserId:(int)commUserId
                            Token:(NSString *)token
                        PostOrGet:(NSString *)postOrGetType
                          success:(void (^)(NSDictionary *dict))success
                          failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:Id] forKey:@"Id"];
    [dic setObject:[NSNumber numberWithInt:pId] forKey:@"pId"];
    [dic setObject:content forKey:@"content"];
    [dic setObject:[NSNumber numberWithInt:commUserId] forKey:@"commUserId"];
    [dic setObject:token forKey:@"token"];
    
    [self callInterfaceByUrl:AddCommentOfPost
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 72.进阶pk-查看奖品详情
//awardId	true	int	奖品编号
- (void)getGetAwardInfoWithAwardId:(int)awardId
                         PostOrGet:(NSString *)postOrGetType
                           success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:awardId] forKey:@"awardId"];
    
    [self callInterfaceByUrl:GetAwardInfo
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 73.上传图片
//数据以multipart/form-data方式上传
- (void)postPostFileWithImageData:(NSData *)imageData
                        PostOrGet:(NSString *)postOrGetType
                          success:(void (^)(NSDictionary *dict))success
                          failure:(void (^)(NSString *str))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@/%@",INTERFACE_URL,PostFile] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageData != nil) {
            [formData appendPartWithFileData:imageData name:@"header" fileName:@"file.jpg" mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.domain);
    }];
    
}

#pragma mark - 74.判断是否已签到
//userId	true	int	用户编号
//token	true	string	用户令牌
- (void)getIsHasSignWithUserId:(int)userId
                         Token:(NSString *)token
                     PostOrGet:(NSString *)postOrGetType
                       success:(void (^)(NSDictionary *dict))success
                       failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    
    [self callInterfaceByUrl:IsHasSign
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 75.个人中心-我的每日pk中更换背景图
//userId	true	int	要更换背景图的用户id
//token	true	string	要更换背景图的用户token
//pkImg	true	string	图片路径
- (void)getChangeMyPkImgWithUserId:(int)userId
                             Token:(NSString *)token
                             PkImg:(NSString *)pkImg
                         PostOrGet:(NSString *)postOrGetType
                           success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:pkImg forKey:@"pkImg"];
    
    [self callInterfaceByUrl:ChangeMyPkImg
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 76.个人中心获取我的每日pk汇报的历史项目
//userId	true	int	用户编号
//token	true	string	用户令牌
- (void)getGetMyPkHistoryProjectWithUserId:(int)userId
                                     Token:(NSString *)token
                                 PostOrGet:(NSString *)postOrGetType
                                   success:(void (^)(NSDictionary *dict))success
                                   failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    
    [self callInterfaceByUrl:GetMyPkHistoryProject
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 77.个人中心获取我的每日pk项目的历史记录
//userId	true	int	用户编号
//token	true	string	用户令牌
//projectId	true	int	项目id
//type	true	int	1-本周 2-本月 3-总计
//pageIndex	false	int	页码
//pageSize	false	int	每页显示数
- (void)getGetMyPkProjectInfoWithUserId:(int)userId
                                  Token:(NSString *)token
                              ProjectId:(int)projectId
                                   Type:(int)type
                              PageIndex:(int)pageIndex
                               PageSize:(int)pageSize
                              PostOrGet:(NSString *)postOrGetType
                                success:(void (^)(NSDictionary *dict))success
                                failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInt:projectId] forKey:@"projectId"];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:pageIndex] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    [self callInterfaceByUrl:GetMyPkProjectInfo
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 78.获取推荐用户列表
//userId	true	int	用户编号
//token	true	string	用户令牌
- (void)getGetRecommendUserWithUserId:(int)userId
                                Token:(NSString *)token
                            PostOrGet:(NSString *)postOrGetType
                              success:(void (^)(NSDictionary *dict))success
                              failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    
    [self callInterfaceByUrl:GetRecommendUser
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 79.进阶pk-获取某个人发布的进阶pk列表
//必选	类型及范围	说明
//userId	true	int	用户编号
//token	true	string	用户令牌
//pageIndex	true	int	页码
//pageSize	true	int	每页显示数
- (void)getGetPostListByUserWithUserId:(int)userId
                                 Token:(NSString *)token
                             PageIndex:(int)pageIndex
                              PageSize:(int)pageSize
                             PostOrGet:(NSString *)postOrGetType
                               success:(void (^)(NSDictionary *dict))success
                               failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInt:pageIndex] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    [self callInterfaceByUrl:GetPostListByUser
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 80.获取某个人发布的能量圈列表
//必选	类型及范围	说明
//userId	true	int	用户编号
//token	true	string	用户令牌
//pageIndex	true	int	页码
//pageSize	true	int	每页显示数
- (void)getGetArticleListByUserWithUserId:(int)userId
                                    Token:(NSString *)token
                                PageIndex:(int)pageIndex
                                 PageSize:(int)pageSize
                                PostOrGet:(NSString *)postOrGetType
                                  success:(void (^)(NSDictionary *dict))success
                                  failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInt:pageIndex] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    [self callInterfaceByUrl:GetArticleListByUser
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 81.第三方登录
//loginType	true	int	登录类型  1-qq  2-微信  3-微博
//openId	true	string	openid
//nickName	true	string	昵称
//photoUrl	true	string	头像地址
//sex	false	string	性别
//phone	false	string	手机号
- (void)getOtherLoginWithLoginType:(int)loginType
                            OpenId:(NSString *)openId
                          NickName:(NSString *)nickName
                          PhotoUrl:(NSString *)photoUrl
                               Sex:(NSString *)sex
                             Phone:(NSString *)phone
                         PostOrGet:(NSString *)postOrGetType
                           success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:loginType] forKey:@"loginType"];
    [dic setObject:openId forKey:@"openId"];
    [dic setObject:nickName forKey:@"nickName"];
    [dic setObject:photoUrl forKey:@"photoUrl"];
    [dic setObject:sex forKey:@"sex"];
    [dic setObject:phone forKey:@"phone"];
    
    [self callInterfaceByUrl:OtherLogin
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 81.获取进阶pk奖品详情h5页面
//接口请求参数
//必选	类型及范围	说明
//awardId	true	int	奖品编号
//链接直接获取

#pragma mark - 82.获取能量圈详情h5页面
//接口请求参数
//必选	类型及范围	说明
//artId	true	int	能量圈编号
//链接直接获取

#pragma mark - 83.获取进阶pk帖子详情h5页面
//接口请求参数
//必选	类型及范围	说明
//postId	true	int	帖子编号
//链接直接获取

#pragma mark - 84.获取通讯录手机号与当前用户的关系
//把参数直接放到Body里面（Json格式）
//必选	类型及范围	说明
//userId	true	int	当前用户id
//token	true	string	当前用户token
//phones	true	List<string>	手机号
- (void)getJudgeCommunicationRelationWithuserId:(int)userId
                                          Token:(NSString *)token
                                         Phones:(NSArray *)phones
                                      PostOrGet:(NSString *)postOrGetType
                                        success:(void (^)(NSDictionary *dict))success
                                        failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:phones forKey:@"phones"];
    
    [self callInterfaceByUrl:JudgeCommunicationRelation
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 85.邀请-发送短信
//接口请求参数
//把参数直接放到Body里面（Json格式）
//必选	类型及范围	说明
//userId	true	int	当前用户id
//token	true	string	当前用户token
//sendPhone	true	string	手机号
- (void)getSendSmsFromInviteWithuserId:(int)userId
                                 Token:(NSString *)token
                             SendPhone:(NSString *)sendPhone
                             PostOrGet:(NSString *)postOrGetType
                               success:(void (^)(NSDictionary *dict))success
                               failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:sendPhone forKey:@"sendPhone"];
    
    [self callInterfaceByUrl:SendSmsFromInvite
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 86.好友模糊搜索
//接口请求参数
//必选	类型及范围	说明
//userId	true	int	用户编号
//where	true	string	模糊搜索词
- (void)getGetLikeUserWithuserId:(int)userId
                           Where:(NSString *)where
                       PostOrGet:(NSString *)postOrGetType
                         success:(void (^)(NSDictionary *dict))success
                         failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:where forKey:@"where"];
    
    [self callInterfaceByUrl:GetLikeUser
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}


#pragma mark - 87.添加好友备注名
//接口请求参数
//把参数直接放到Body里面（Json格式）
//必选	类型及范围	说明
//userId	true	int	当前用户id
//token	true	string	当前用户token
//ouId	true	int	好友的用户编号
//noteName	true	string	备注名称
- (void)getAddNoteNameWithuserId:(int)userId
                           Token:(NSString *)token
                            OuId:(int)ouId
                        NoteName:(NSString *)noteName
                       PostOrGet:(NSString *)postOrGetType
                         success:(void (^)(NSDictionary *dict))success
                         failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInt:ouId] forKey:@"ouId"];
    [dic setObject:noteName forKey:@"noteName"];
    
    [self callInterfaceByUrl:AddNoteName
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 88.删除能量圈或者进阶pk帖子
//接口请求参数
//把参数直接放到Body里面（Json格式）
//必选	类型及范围	说明
//userId	true	int	当前用户编号
//token	true	string	当前用户令牌
//aType	true	int	帖子类型 1-能量圈 2-进阶pk
//aId	true	int	帖子编号v
- (void)getDeleteArticleWithuserId:(int)userId
                             Token:(NSString *)token
                             AType:(int)aType
                               AId:(int)aId
                         PostOrGet:(NSString *)postOrGetType
                           success:(void (^)(NSDictionary *dict))success
                           failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInt:aType] forKey:@"aType"];
    [dic setObject:[NSNumber numberWithInt:aId] forKey:@"aId"];
    
    [self callInterfaceByUrl:DeleteArticle
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 90.获取用户关注/粉丝列表
//接口请求参数
//把参数直接放到Body里面（Json格式）
//必选	类型及范围	说明
//uid1	true	int	要获取关注/粉丝的用户的id
//uid2	true	int	当前用户的id
//type	true	int	 1-关注 2-粉丝
- (void)getGetFriendsListWithUid1:(int)uid1
                             Uid2:(int)uid2
                             Type:(int)type
                        PostOrGet:(NSString *)postOrGetType
                          success:(void (^)(NSDictionary *dict))success
                          failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:uid1] forKey:@"uid1"];
    [dic setObject:[NSNumber numberWithInt:uid2] forKey:@"uid2"];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    
    [self callInterfaceByUrl:GetFriendsList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 91.分享成功获得积分
//接口请求参数
//把参数直接放到Body里面（Json格式）
//必选	类型及范围	说明、
//userid	true	int	当前用户编号
//token	true	string	当前用户令牌
//type	true	int	1-每日pk 2-进阶pk
- (void)getShareWithUserid:(int)userid
                     Token:(NSString *)token
                      Type:(int)type
                 PostOrGet:(NSString *)postOrGetType
                   success:(void (^)(NSDictionary *dict))success
                   failure:(void (^)(NSString *str))failure {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int tempType = [[ud objectForKey:@"shareSuccessCallType"] intValue];
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInt:tempType] forKey:@"type"];
    
    [self callInterfaceByUrl:Share
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
//                         if (dict&&([dict[@"Code"] intValue] == 200)) {
//                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"获取积分成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                             [alertView show];
//                         }
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 92.更换手机号
//接口请求参数
//把参数直接放到Body里面（Json格式）
//必选  类型及范围   说明
//UserID  true    int 用户ID
//Token   true    string  令牌
//Phone   true    string  用户id
- (void)changePhoneNumberWithUserid:(int)userid
                              Token:(NSString *)token
                              Phone:(NSString *)phone
                          PostOrGet:(NSString *)postOrGetType
                            success:(void (^)(NSDictionary *dict))success
                            failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:phone forKey:@"phone"];
    
    [self callInterfaceByUrl:ChangePhoneNumber
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict){
                         success(dict);
                     }failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 93.更换、绑定手机号时发送验证码
//接口请求参数
//把参数直接放到Body里面（Json格式）
//必选  类型及范围   说明
//phoneNo string 用户id
//type  int 验证码类型
- (void)getVerificationCodeWithPhoneNo:(NSString *)phoneNo
                                  Type:(int)type
                         PostOrGet:(NSString *)postOrGetType
                            success:(void (^)(NSDictionary *dict))success
                            failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:phoneNo forKey:@"phoneNo"];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    
    [self callInterfaceByUrl:GetVerificationCode
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict){
                         success(dict);
                     }failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 94.修改密码、绑定手机号
//请求参数：
//把参数直接放到Body里面（Json格式）
//必选	类型及范围	说明
//UserID	true	int	用户ID
//Token	true	string	令牌
//Pwd	true	string	用户密码
//Phone true    string  用户手机号
- (void)changePasswordWithUserid:(int)userid
                           Token:(NSString *)token
                             Pwd:(NSString *)pwd
                           Phone:(NSString *)phone
                          PostOrGet:(NSString *)postOrGetType
                            success:(void (^)(NSDictionary *dict))success
                            failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:pwd forKey:@"pwd"];
    [dic setObject:phone forKey:@"phone"];
    
    [self callInterfaceByUrl:ChangePassword
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict){
                         success(dict);
                     }failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 95.修改个人简介
//请求参数:
//把参数直接放到Body里面(Json格式)
//UserID   int     用户ID
//token    string  令牌
//Brief    string  简介
- (void)changeBriefWithUserid:(int)userid
                        Token:(NSString *)token
                        Brief:(NSString *)brief
                    PostOrGet:(NSString *)postOrGetType
                      success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:brief forKey:@"Brief"];
    
    [self callInterfaceByUrl:ChangeBrief
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict){
                         success(dict);
                     }failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 96.获取用户粉丝/关注/能连贴等数量
//请求参数
//把参数直接放到Body里面(Json格式)
//UserID       int  当前登录用户ID
//OtherUserID  int  其他用户ID
- (void)getGetUserInfoWithUserid:(int)userid
                     OtherUserID:(int)otherUserID
                       PostOrGet:(NSString *)postOrGetType
                         success:(void (^)(NSDictionary *dict))success
                         failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:otherUserID] forKey:@"otherUserID"];
    
    [self callInterfaceByUrl:UserInfo_Get
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                        success(dict);
                    } failure:^(NSString *str) {
                        failure(str);
                    }];
}

#pragma mark - 97.修改个人主页背景图片
//请求参数
//把参数直接放到Body里面(Json格式)
//UserID            int     用户ID
//token             string  令牌
//BackgroundImg     string  图片地址
- (void)changeBackgroundImgWithUserid:(int)userid
                                Token:(NSString *)token
                        BackgroundImg:(NSString *)backgroundImg
                            PostOrGet:(NSString *)postOrGetType
                              success:(void (^)(NSDictionary *dict))success
                              failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:backgroundImg forKey:@"BackgroundImg"];
    
    [self callInterfaceByUrl:ChangeBackgroundImg
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *str) {
                         failure(str);
                     }];
}

#pragma mark - 98.获取能量圈列表(查看其他人的能量圈)
//请求参数：
//type  // 1-最新 2-最热 3-精选 4-关注
//userid  //用户id  (当type=4的时候需要传)
//otherUserId  // 其他用户id
//token   //用户token     (当type=4的时候需要传)
//pageIndex  //页码
//pageSize   //每页显示数
- (void)getGetArticleListWithType:(NSString *)type
                           Userid:(NSString *)userid
                      OtherUserId:(NSString *)otherUserId
                            Token:(NSString *)token
                        PageIndex:(NSString *)pageIndex
                         PageSize:(NSString *)pageSize
                        PostOrGet:(NSString *)postOrGetType
                          success:(void (^)(NSDictionary *dict))success
                          failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:type forKey:@"type"];
    [dic setObject:userid forKey:@"userId"];
    [dic setObject:otherUserId forKey:@"otherUserId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:pageIndex forKey:@"pageIndex"];
    [dic setObject:pageSize forKey:@"pageSize"];
    
    [self callInterfaceByUrl:GetOtherArticleList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}


#pragma mark - 99.获取用户点赞/评论消息
//请求参数:
//Type      int 1.评论 2.赞
//UserID    int 用户ID
//PageIndex int 页码
//PageSize  int 每页显示数
- (void)getMessageGetWithType:(int)type
                       Userid:(int)userid
                    PageIndex:(int)pageIndex
                     PageSize:(int)pageSize
                    PostOrGet:(NSString *)postOrGetType
                      success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:pageIndex] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    [self callInterfaceByUrl:Message_Get
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
    
}

#pragma mark - 100.将消息置为已读
//请求参数
//Type      int 1.评论 2.赞
//UserID    int 用户ID
- (void)getMessageReadedWithType:(int)type
                          Userid:(int)userid
                       PostOrGet:(NSString *)postOrGetType
                         success:(void (^)(NSDictionary *dict))success
                         failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    
    [self callInterfaceByUrl:Message_Readed
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                        success(dict);
                    } failure:^(NSString *dict) {
                        failure(dict);
                    }];

}


#pragma mark - 101 获取未读消息数量

- (void)getMyMessageNum:(int)userid success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure {
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"UserID"];
    
    [self callInterfaceByUrl:MyMessage PostOrGet:@"get" withDict:dic success:^(NSDictionary *dict) {
        success(dict);
    } failure:^(NSString *str) {
        failure(str);
    }];
}

#pragma mark - 102.获取通知列表

- (void)getAPPNotifyWithUserid:(int)userid
                     Pageindex:(int)pageindex
                      Pagesize:(int)pagesize
                     PostOrGet:(NSString *)postOrGetType
                       success:(void (^)(NSDictionary *dict))success
                       failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:pageindex] forKey:@"pageindex"];
    [dic setObject:[NSNumber numberWithInt:pagesize] forKey:@"pagesize"];
    
    [self callInterfaceByUrl:APP_Notify_Get
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
    
}

#pragma mark - 103.修改个人资料中的手机号发送验证码
//输入参数：UserID   int
//输入参数：Tel      string
- (void)getTelCodeWithUserid:(int)userid
                         Tel:(NSString *)tel
                   PostOrGet:(NSString *)postOrGetType
                     success:(void (^)(NSDictionary *dict))success
                     failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:tel forKey:@"tel"];
    
    [self callInterfaceByUrl:GetTelCode
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 104.修改个人资料中的手机号
//输入参数：UserID   int
//输入参数：Tel      string    //手机号
- (void)updateAppUserTelUpdWithUserid:(int)userid
                                  Tel:(NSString *)tel
                            PostOrGet:(NSString *)postOrGetType
                              success:(void (^)(NSDictionary *dict))success
                              failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:tel forKey:@"tel"];
    
    [self callInterfaceByUrl:AppUserTelUpdate
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 105.电台列表
// 输入参数:pageindex   int // 页码
// 输入参数:pagesize    int // 每页显示的数量
- (void)getAppRadioListWithPageIndex:(int)pageIndex
                            PageSize:(int)pageSize
                           PostOrGet:(NSString *)postOrGetType
                             success:(void (^)(NSDictionary *dict))success
                             failure:(void (^)(NSString *str))failure {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:pageIndex] forKey:@"pageindex"];
    [dic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pagesize"];
    
    [self callInterfaceByUrl:AppRadioList
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *dict) {
                         failure(dict);
                     }];
}

#pragma mark - 106.获取用户每日PK统计
// 输入参数:UserID      int // 用户ID
- (void)getPkStatisticsWithUserid:(int)userid
                        PostOrGet:(NSString *)postOrGetType
                          success:(void (^)(NSDictionary *dict))success
                          failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    
    [self callInterfaceByUrl:PkStatistics
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *str) {
                         failure(str);
                     }];
}

#pragma mark - 107.监测第三方是否第一次登录
// 输入参数:loginType   int // 登录类型
// 输入参数:openId      string // 登录ID
- (void)IsFirstLoginWithLoginType:(int)loginType
                           openId:(NSString *)openId
                        PostOrGet:(NSString *)postOrGetType
                          success:(void (^)(NSDictionary *dict))success
                          failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:loginType] forKey:@"loginType"];
    [dic setObject:openId forKey:@"openId"];
    
    [self callInterfaceByUrl:IsFirstLogin
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *str) {
                         failure(str);
                     }];
}

#pragma mark - 108.为第三方用户添加能量源
// 输入参数:UserID      int // 用户ID
// 输入参数:powerSource string // 能量源
- (void)getPowerSourceRelevanceWithUserID:(int)userid
                                    Token:(NSString *)token
                              PowerSource:(NSString *)powerSource
                                PostOrGet:(NSString *)postOrGetType
                                  success:(void (^)(NSDictionary *dict))success
                                  failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:powerSource forKey:@"powerSource"];
    
    [self callInterfaceByUrl:PowerSourceRelevance
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *str) {
                         failure(str);
                     }];
}

#pragma mark - 109.获得个人徽章数据
// 输入参数:UserID      int // 用户ID
- (void)getMyBedgeWithUserID:(int)userid
                   PostOrGet:(NSString *)postOrGetType
                     success:(void (^)(NSDictionary *dict))success
                     failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    
    [self callInterfaceByUrl:GetMyBedge
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                        success(dict);
                    } failure:^(NSString *str) {
                        failure(str);
                    }];
}


#pragma mark - 110.学习模块Banner列表
- (void)getBannerListPostOrGet:(NSString *)postOrGetType
                       success:(void (^)(NSDictionary *dict))success
                       failure:(void (^)(NSString *str))failure {
    [self callInterfaceByUrl:BannerList
                   PostOrGet:postOrGetType
                    withDict:nil
                     success:^(NSDictionary *dict) {
                        success(dict);
                    } failure:^(NSString *str) {
                        failure(str);
                    }];
}

#pragma mark - 111.获赞排名
- (void)getGoodOrderWithUserID:(int)userid
                     PageIndex:(int)pageIndex
                      PageSize:(int)pageSize
                     PostOrGet:(NSString *)postOrGetType
                       success:(void (^)(NSDictionary *dict))success
                       failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:pageIndex] forKey:@"pageindex"];
    [dic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pagesize"];
    [self callInterfaceByUrl:Good_Order
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *str) {
                         failure(str);
                     }];
}

#pragma mark - 112.上传图片有水印
//数据以multipart/form-data方式上传
- (void)postArticlePostFileWithImageData:(NSData *)imageData
                                PostOrGet:(NSString *)postOrGetType
                                  success:(void (^)(NSDictionary *dict))success
                                  failure:(void (^)(NSString *str))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@/%@",INTERFACE_URL,Article_PostFile] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageData != nil) {
            [formData appendPartWithFileData:imageData name:@"header" fileName:@"file.jpg" mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.domain);
    }];
    
}

#pragma mark - 113.加载html

- (void)loadHtmlStringWithUrl:(NSString *)url PostOrGet:(NSString *)postOrGetType parametersDict:(NSDictionary *)postDict
 success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:@"1" forKey:@"aid"];
    [dic setObject:@"0" forKey:@"userId"];
    
    
}

#pragma mark - 114. 请求队列
- (void)requestTasksWithUrls:(NSMutableArray *)urls success:(void (^)(NSDictionary *dic,NSInteger idx))success failure:(void (^)(NSError *error))failure complete:(void (^)(NSMutableArray *))complete {
    
    NSMutableArray * results = [NSMutableArray arrayWithCapacity:urls.count];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("tk.bourne.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < urls.count; i++) {
            
            dispatch_group_enter(group);
            NSURLSessionDataTask * task = [AppHttpManager requestWithURL:urls[i] success:^(NSURLSessionDataTask *task, id responseObject) {
                NSDictionary * data = (NSDictionary*)responseObject;
                success(data,i);
                @synchronized (results) {
                   [results addObject:data];
                }
            dispatch_group_leave(group);
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                failure(error);
                dispatch_group_leave(group);
            }];
            
            [task resume];
        }
        
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"完成 - %@", [NSThread currentThread]);
        complete(results);
    });
}

+ (NSURLSessionDataTask*)requestWithURL:(NSString*)url success:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock fail:(void (^)(NSURLSessionDataTask *task, NSError * error))failure{
    
    __block NSURLSessionDataTask * resultTask;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(task,responseObject);
        resultTask = task;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
        resultTask = task;
    }];
    
    return resultTask;
}

- (void)sticklyArticleWithUrl:(NSString *)url PostOrGet:(NSString *)postOrGetType articleId:(NSString *)articleId isChoice:(NSString*)isChoice token:(NSString *)token userId:(NSString *)userId success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:isChoice forKey:@"IsChoice"];
    [dic setObject:articleId forKey:@"ArticleID"];
    
    
    [self callInterfaceByUrl:SticklyArticle
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *str) {
                         failure(str);
                     }];

    
    
}

#pragma mark - 113.早起签到排行榜
- (void)getEarlySignRankingWithUserID:(int)userid
                            PageIndex:(int)pageIndex
                             PageSize:(int)pageSize
                            PostOrGet:(NSString *)postOrGetType
                              success:(void (^)(NSDictionary *dict))success
                              failure:(void (^)(NSString *str))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSNumber numberWithInt:userid] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:pageIndex] forKey:@"pageindex"];
    [dic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pagesize"];
    [self callInterfaceByUrl:Early_Sign_Ranking
                   PostOrGet:postOrGetType
                    withDict:dic
                     success:^(NSDictionary *dict) {
                         success(dict);
                     } failure:^(NSString *str) {
                         failure(str);
                     }];
}

@end
