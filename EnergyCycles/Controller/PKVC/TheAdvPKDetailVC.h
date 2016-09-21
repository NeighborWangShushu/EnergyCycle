//
//  TheAdvPKDetailVC.h
//  EnergyCycles
//
//  Created by 王斌 on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "WebVC.h"
#import "TheAdvMainModel.h"

@interface TheAdvPKDetailVC : UITableViewController

@property (nonatomic, copy) NSString *titleName;

@property (nonatomic, strong) TheAdvMainModel *model;

@property (nonatomic, copy) NSString *url;

@end
