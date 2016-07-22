    //
//  AttentionAndFansTableViewController.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"


@interface AttentionAndFansTableViewController : BaseTableViewController

// 获取用户的ID
@property (nonatomic, copy) NSString *userId;
// 列表的类型(关注或者粉丝),必须要给
@property (nonatomic, assign) int type; // 1是关注,2是粉丝

@end