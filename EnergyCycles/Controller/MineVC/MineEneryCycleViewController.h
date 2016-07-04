//
//  MineEneryCycleViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface MineEneryCycleViewController : BaseViewController {
    IBOutlet UITableView *mineEneryCycleTableView;
}

@property (nonatomic, strong) NSString *showUserID;
@property (nonatomic, strong) NSString *showTitle;


@end
