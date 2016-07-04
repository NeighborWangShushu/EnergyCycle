//
//  SignInModel.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface SignInModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *Id;
@property (nonatomic, strong) NSString<Optional> *UserId;
@property (nonatomic, strong) NSString<Optional> *DateTime;
@property (nonatomic, strong) NSString<Optional> *Continuons;


@end
