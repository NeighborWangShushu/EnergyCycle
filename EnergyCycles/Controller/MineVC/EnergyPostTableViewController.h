//
//  EnergyPostTableViewController.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineHomePageTableViewControllerProtocol.h"

@interface EnergyPostTableViewController : MineHomePageTableViewControllerProtocol

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) BOOL isMineTableView;

@end
