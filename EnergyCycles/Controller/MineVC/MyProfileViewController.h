//
//  MyProfileViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"

@interface MyProfileViewController : BaseViewController {
    IBOutlet UITableView *mineProfileTableView;
}

@property (nonatomic, strong) NSMutableDictionary *inforDict;
@property (nonatomic, strong) UserModel *model;

@end
