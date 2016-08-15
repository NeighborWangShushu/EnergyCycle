//
//  RecommentModel.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface RecommentModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *photourl;
@property (nonatomic, strong) NSString<Optional> *use_id;
@property (nonatomic, strong) NSString<Optional> *Brief;
@property (nonatomic, strong) NSString<Optional> *user_registerDate;



@end
