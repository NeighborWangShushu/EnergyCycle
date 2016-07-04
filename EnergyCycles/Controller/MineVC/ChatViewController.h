//
//  ChatViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

#import "MessageModel.h"

@interface ChatViewController : BaseViewController

//显示标题
@property (nonatomic, strong) NSString *chatTitleStr;

//@property (nonatomic, strong) MessageModel *model;

@property (nonatomic, strong) NSString *otherName;
@property (nonatomic, strong) NSString *otherID;
@property (nonatomic, strong) NSString *otherPic;

@property (nonatomic, strong) NSString *touchIndex;


@end
